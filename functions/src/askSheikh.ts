// askSheikhQuestion - Cloud Function for the Ask Sheikh feature.
//
// Flow:
//   1. Auth check (must be signed in, anonymous OK)
//   2. Validate input (non-empty, sane length)
//   3. Crisis check -> support-resources error
//   4. Risk classification -> high-risk routes to scholar (no AI)
//   5. Atomic daily-limit increment (throws if exhausted)
//   6. Search approved_answers by Jaccard similarity over the
//      normalized question
//   7. If matched -> return; persist user_questions row
//   8. If no match AND OPENAI_API_KEY is configured ->
//      call OpenAI (NOT YET IMPLEMENTED — currently throws
//      'failed-precondition' so the failure is loud, not silent)
//   9. Otherwise -> 'not-found'
//
// Deploy with `firebase deploy --only functions:askSheikhQuestion`.

import { onCall, HttpsError } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { defineSecret } from 'firebase-functions/params';

import {
  AskSheikhInput,
  AskSheikhResult,
  ApprovedAnswer,
  EvidenceReference,
} from './lib/types';
import { jaccardSimilarity, normalizeArabic } from './lib/normalize';
import { classifyRisk, isCrisis } from './lib/safety';
import {
  FREE_DAILY_ASK_SHEIKH_LIMIT,
  incrementLimit,
} from './lib/limits';

const openaiApiKey = defineSecret('OPENAI_API_KEY');

const MAX_QUESTION_LENGTH = 800;
const SIMILARITY_THRESHOLD = 0.55;

export const askSheikhQuestion = onCall(
  { secrets: [openaiApiKey], maxInstances: 5 },
  async (request) => {
    const auth = request.auth;
    if (!auth) {
      throw new HttpsError('unauthenticated', 'Sign in required.');
    }

    const data = request.data as AskSheikhInput | undefined;
    const question = (data?.question ?? '').trim();
    const language = (data?.language ?? 'ar') as 'ar' | 'en';

    if (!question) {
      throw new HttpsError('invalid-argument', 'Question is empty.');
    }
    if (question.length > MAX_QUESTION_LENGTH) {
      throw new HttpsError(
        'invalid-argument',
        `Question is too long (max ${MAX_QUESTION_LENGTH} chars).`,
      );
    }

    if (isCrisis(question, language)) {
      // Don't burn a quota slot, don't route to AI; let the app
      // surface a crisis-resources flow.
      throw new HttpsError(
        'permission-denied',
        'crisis_detected: please use the support resources flow.',
      );
    }

    const risk = classifyRisk(question, language);
    if (risk === 'high') {
      throw new HttpsError(
        'permission-denied',
        'high_risk_topic: this question requires a qualified scholar.',
      );
    }

    const limitState = await incrementLimit(
      auth.uid,
      'ask_sheikh',
      FREE_DAILY_ASK_SHEIKH_LIMIT,
    );
    if (limitState.blocked) {
      throw new HttpsError(
        'resource-exhausted',
        `Daily limit reached (${limitState.limit}/day).`,
      );
    }

    // 1) Search approved_answers in the requested language.
    const approvedSnapshot = await admin
      .firestore()
      .collection('approved_answers')
      .where('language', '==', language)
      .where('approved', '==', true)
      .limit(200)
      .get();

    const normalizedQuestion =
      language === 'ar' ? normalizeArabic(question) : question.toLowerCase();

    let bestMatch: ApprovedAnswer | null = null;
    let bestScore = 0;
    for (const doc of approvedSnapshot.docs) {
      const data = doc.data() as ApprovedAnswer;
      const normalizedCandidate = data.question_normalized || '';
      const score = jaccardSimilarity(normalizedQuestion, normalizedCandidate);
      if (score > bestScore) {
        bestScore = score;
        bestMatch = { ...data, id: doc.id };
      }
    }

    if (bestMatch && bestScore >= SIMILARITY_THRESHOLD) {
      const questionRef = await persistUserQuestion(
        auth.uid,
        question,
        language,
        bestMatch.id,
        false,
      );
      const result: AskSheikhResult = {
        source: 'approved_answers',
        answer: {
          short: bestMatch.answer_short,
          full: bestMatch.answer_full,
          evidence: bestMatch.evidence ?? [],
        },
        questionId: questionRef.id,
        questionsRemainingToday: limitState.remaining,
      };
      return result;
    }

    // 2) AI fallback. NOT YET IMPLEMENTED.
    // To enable: add the `openai` npm dep, import here, build a system
    // prompt that enforces the safety rules from ASK_SHEIKH_PLAN.md, and
    // call openai.chat.completions.create(...). Run rejectIfForbidden()
    // on the output. Persist as 'ai_pending_review' status so the admin
    // panel can approve/reject before it counts toward future matches.
    let key: string;
    try {
      key = openaiApiKey.value();
    } catch (_) {
      key = '';
    }
    if (!key) {
      throw new HttpsError(
        'failed-precondition',
        'ai_not_configured: no DB match and OPENAI_API_KEY is not set. ' +
          'Either expand approved_answers, or run ' +
          '`firebase functions:secrets:set OPENAI_API_KEY`.',
      );
    }

    throw new HttpsError(
      'unimplemented',
      'ai_path_pending_implementation: see askSheikh.ts for the OpenAI ' +
        'wiring contract. Add the `openai` dep and complete the call.',
    );
  },
);

async function persistUserQuestion(
  userId: string,
  questionText: string,
  language: 'ar' | 'en',
  approvedAnswerId: string | null,
  usedAi: boolean,
): Promise<admin.firestore.DocumentReference> {
  return admin.firestore().collection('user_questions').add({
    userId,
    questionText,
    language,
    approvedAnswerId,
    usedAi,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });
}
