// askSheikhQuestion - Cloud Function (Console paste-deploy variant).
// Plain JavaScript, self-contained. See README.md in this folder for
// deployment instructions.
//
// Flow:
//   1. Auth check (must be signed in)
//   2. Validate input
//   3. Crisis check -> permission-denied (app shows support resources)
//   4. High-risk topic -> permission-denied (route to scholar)
//   5. Atomic daily-limit increment (free tier: 7/day)
//   6. Search approved_answers by Jaccard similarity over normalized question
//   7. If matched -> return + persist user_questions row
//   8. If no match AND OPENAI_API_KEY set -> AI fallback (unimplemented)
//   9. Otherwise -> failed-precondition
//
// Persistent collections used:
//   approved_answers, user_questions, daily_limits

const functions = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

if (!admin.apps.length) admin.initializeApp();

const FREE_DAILY_LIMIT = 7;
const MAX_QUESTION_LENGTH = 800;
const SIMILARITY_THRESHOLD = 0.55;

// ---- Arabic normalization ----------------------------------------------

const TASHKEEL_REGEX = /[ؐ-ًؚ-ٰٟۖ-ۜ۟-۪ۤۧۨ-ۭ]/g;
const NON_ARABIC_REGEX = /[^؀-ۿ\s]/g;

function normalizeArabic(text) {
  if (!text) return '';
  return text
    .normalize('NFC')
    .toLowerCase()
    .replace(TASHKEEL_REGEX, '')
    .replace(/ـ/g, '')
    .replace(/[أإآ]/g, 'ا')
    .replace(/ة/g, 'ه')
    .replace(/ى/g, 'ي')
    .replace(NON_ARABIC_REGEX, '')
    .replace(/\s+/g, ' ')
    .trim();
}

function jaccardSimilarity(a, b) {
  const setA = new Set(normalizeArabic(a).split(/\s+/).filter(Boolean));
  const setB = new Set(normalizeArabic(b).split(/\s+/).filter(Boolean));
  if (setA.size === 0 || setB.size === 0) return 0;
  let inter = 0;
  for (const w of setA) if (setB.has(w)) inter++;
  const union = new Set([...setA, ...setB]).size;
  return inter / union;
}

// ---- Safety filters -----------------------------------------------------

const HIGH_RISK_AR = [
  'طلاق', 'الطلاق', 'تكفير', 'كافر', 'مرتد',
  'جهاد', 'قتال', 'ميراث', 'وراثه',
  'انتحار', 'اقتل نفسي', 'اؤذي نفسي',
  'يضربني', 'يضربها',
  'يخونني', 'تخونني', 'يسحرني', 'تسحرني',
];
const HIGH_RISK_EN = [
  'divorce', 'takfir', 'kafir', 'apostate', 'jihad',
  'inheritance', 'suicide', 'self-harm', 'self harm',
  'abuse', 'beating', 'cheating', 'witchcraft', 'sihr',
];
const CRISIS_AR = ['انتحار', 'اقتل نفسي', 'اؤذي نفسي'];
const CRISIS_EN = ['suicide', 'kill myself', 'self-harm', 'hurt myself'];

function isHighRisk(text, lang) {
  if (!text) return false;
  const list = lang === 'ar' ? HIGH_RISK_AR : HIGH_RISK_EN;
  const haystack = lang === 'ar' ? normalizeArabic(text) : text.toLowerCase();
  return list.some((kw) => haystack.includes(kw));
}

function isCrisis(text, lang) {
  if (!text) return false;
  const list = lang === 'ar' ? CRISIS_AR : CRISIS_EN;
  const haystack = lang === 'ar' ? normalizeArabic(text) : text.toLowerCase();
  return list.some((kw) => haystack.includes(kw));
}

// ---- Daily limit --------------------------------------------------------

function todayIsoUtc() {
  const d = new Date();
  return `${d.getUTCFullYear()}-${String(d.getUTCMonth() + 1).padStart(2, '0')}-${String(d.getUTCDate()).padStart(2, '0')}`;
}

async function incrementDailyLimit(userId, kind, limit) {
  const docId = `${userId}_${kind}_${todayIsoUtc()}`;
  const ref = admin.firestore().collection('daily_limits').doc(docId);
  return admin.firestore().runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const used = snap.exists ? (snap.data().count || 0) : 0;
    if (used >= limit) {
      return { used, limit, remaining: 0, blocked: true };
    }
    const next = used + 1;
    tx.set(
      ref,
      {
        userId,
        kind,
        count: next,
        date: todayIsoUtc(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true },
    );
    return { used: next, limit, remaining: Math.max(0, limit - next), blocked: false };
  });
}

// ---- Function -----------------------------------------------------------

exports.askSheikhQuestion = functions.onCall(
  { maxInstances: 5 },
  async (request) => {
    const auth = request.auth;
    if (!auth) {
      throw new functions.HttpsError('unauthenticated', 'Sign in required.');
    }

    const data = request.data || {};
    const question = String(data.question || '').trim();
    const language = data.language === 'en' ? 'en' : 'ar';

    if (!question) {
      throw new functions.HttpsError('invalid-argument', 'Question is empty.');
    }
    if (question.length > MAX_QUESTION_LENGTH) {
      throw new functions.HttpsError(
        'invalid-argument',
        `Question is too long (max ${MAX_QUESTION_LENGTH} chars).`,
      );
    }

    if (isCrisis(question, language)) {
      throw new functions.HttpsError(
        'permission-denied',
        'crisis_detected: please use the support resources flow.',
      );
    }
    if (isHighRisk(question, language)) {
      throw new functions.HttpsError(
        'permission-denied',
        'high_risk_topic: this question requires a qualified scholar.',
      );
    }

    const limitState = await incrementDailyLimit(
      auth.uid,
      'ask_sheikh',
      FREE_DAILY_LIMIT,
    );
    if (limitState.blocked) {
      throw new functions.HttpsError(
        'resource-exhausted',
        `Daily limit reached (${limitState.limit}/day).`,
      );
    }

    // Search approved_answers
    const snap = await admin
      .firestore()
      .collection('approved_answers')
      .where('language', '==', language)
      .where('approved', '==', true)
      .limit(200)
      .get();

    const normalizedQuestion =
      language === 'ar' ? normalizeArabic(question) : question.toLowerCase();

    let bestMatch = null;
    let bestScore = 0;
    snap.forEach((doc) => {
      const d = doc.data();
      const score = jaccardSimilarity(
        normalizedQuestion,
        d.question_normalized || '',
      );
      if (score > bestScore) {
        bestScore = score;
        bestMatch = { id: doc.id, data: d };
      }
    });

    if (bestMatch && bestScore >= SIMILARITY_THRESHOLD) {
      const qRef = await admin.firestore().collection('user_questions').add({
        userId: auth.uid,
        questionText: question,
        language,
        approvedAnswerId: bestMatch.id,
        usedAi: false,
        status: 'answered_db',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      return {
        source: 'approved_answers',
        answer: {
          short: bestMatch.data.answer_short,
          full: bestMatch.data.answer_full,
          evidence: bestMatch.data.evidence || [],
        },
        questionId: qRef.id,
        questionsRemainingToday: limitState.remaining,
      };
    }

    // No match. AI fallback would go here. Currently unimplemented.
    const apiKey = process.env.OPENAI_API_KEY || '';
    if (!apiKey) {
      throw new functions.HttpsError(
        'failed-precondition',
        'ai_not_configured: no DB match and OPENAI_API_KEY is not set.',
      );
    }
    throw new functions.HttpsError(
      'unimplemented',
      'ai_path_pending_implementation: see askSheikhQuestion.js header.',
    );
  },
);
