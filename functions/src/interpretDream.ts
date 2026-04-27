// interpretDream - Cloud Function for Dream Interpretation.
//
// Mirrors the local Tafseer Ahlam logic (lib/presentation/screens/dream/
// in the mobile app), but server-side so the symbol catalogue can be
// expanded without app updates.
//
// Flow:
//   1. Auth check
//   2. Validate input
//   3. Crisis check -> support-resources error
//   4. Daily limit increment
//   5. Search dream_symbols (approved=true) for any whose symbol_ar or
//      keywords appear in the (normalized) dream text
//   6. If matches -> compose response from DB
//   7. If no matches AND OPENAI_API_KEY set -> AI fallback (pending)
//   8. Otherwise -> not-found
//
// Deploy with `firebase deploy --only functions:interpretDream`.

import { onCall, HttpsError } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { defineSecret } from 'firebase-functions/params';

import {
  InterpretDreamInput,
  DreamResult,
  DreamSymbol,
} from './lib/types';
import { normalizeArabic } from './lib/normalize';
import { isCrisis, isHighRisk } from './lib/safety';
import {
  FREE_DAILY_DREAM_LIMIT,
  incrementLimit,
} from './lib/limits';

const openaiApiKey = defineSecret('OPENAI_API_KEY');

const MAX_DREAM_LENGTH = 2000;

const REQUIRED_DISCLAIMER_AR =
  'هذا تفسير عام وليس حكماً مؤكداً، والله أعلم.';

export const interpretDream = onCall(
  { secrets: [openaiApiKey], maxInstances: 5 },
  async (request) => {
    const auth = request.auth;
    if (!auth) {
      throw new HttpsError('unauthenticated', 'Sign in required.');
    }

    const data = request.data as InterpretDreamInput | undefined;
    const dreamText = (data?.dreamText ?? '').trim();
    const language = (data?.language ?? 'ar') as 'ar' | 'en';

    if (!dreamText) {
      throw new HttpsError('invalid-argument', 'Dream text is empty.');
    }
    if (dreamText.length > MAX_DREAM_LENGTH) {
      throw new HttpsError(
        'invalid-argument',
        `Dream text is too long (max ${MAX_DREAM_LENGTH} chars).`,
      );
    }

    if (isCrisis(dreamText, language)) {
      throw new HttpsError(
        'permission-denied',
        'crisis_detected: please use the support resources flow.',
      );
    }

    if (isHighRisk(dreamText, language)) {
      throw new HttpsError(
        'permission-denied',
        'high_risk_topic: this dream contains content we will not interpret. ' +
          'Please consult a qualified scholar or specialist.',
      );
    }

    const limitState = await incrementLimit(
      auth.uid,
      'dream',
      FREE_DAILY_DREAM_LIMIT,
    );
    if (limitState.blocked) {
      throw new HttpsError(
        'resource-exhausted',
        `Daily dream-interpretation limit reached (${limitState.limit}/day).`,
      );
    }

    const normalized = normalizeArabic(dreamText);

    // Pull a small page of approved symbols. With a moderate catalogue
    // (~100-500 entries) this is fine. For larger catalogues add an
    // inverted index keyed by symbol root, server-side.
    const symbolsSnap = await admin
      .firestore()
      .collection('dream_symbols')
      .where('approved', '==', true)
      .limit(500)
      .get();

    const matched: DreamSymbol[] = [];
    for (const doc of symbolsSnap.docs) {
      const sym = { ...(doc.data() as DreamSymbol), id: doc.id };
      const symbolKey = normalizeArabic(sym.symbol_ar);
      if (symbolKey && normalized.includes(symbolKey)) {
        matched.push(sym);
      }
    }

    if (matched.length > 0) {
      const general = matched
        .map((s) => s.meaning_general_ar)
        .filter(Boolean)
        .join(' ');
      const meanings = matched
        .map((s) => s.meaning_safe_ar)
        .filter(Boolean);

      const interpretationRef = await admin
        .firestore()
        .collection('dream_interpretations')
        .add({
          userId: auth.uid,
          dreamText,
          matchedSymbolIds: matched.map((s) => s.id),
          source: 'dream_symbols',
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

      const result: DreamResult = {
        source: 'dream_symbols',
        matchedSymbolIds: matched.map((s) => s.id),
        generalInterpretation: general,
        possibleMeanings: meanings,
        islamicAdvice:
          'استغفر الله، وأكثر من الصلاة على النبي ﷺ، وتصدّق بما يسره الله لك.',
        disclaimer: REQUIRED_DISCLAIMER_AR,
        interpretationId: interpretationRef.id,
      };
      return result;
    }

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
          'Either expand dream_symbols, or run ' +
          '`firebase functions:secrets:set OPENAI_API_KEY`.',
      );
    }

    throw new HttpsError(
      'unimplemented',
      'ai_path_pending_implementation: see interpretDream.ts. Wire the ' +
        '`openai` SDK with the system prompt from DREAM_INTERPRETATION_PLAN.md, ' +
        'run rejectIfForbidden() on the output, then persist with ' +
        "source: 'ai_pending_review'.",
    );
  },
);
