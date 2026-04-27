// interpretDream - Cloud Function (Console paste-deploy variant).
// Plain JavaScript, self-contained. See README.md in this folder.

const functions = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

if (!admin.apps.length) admin.initializeApp();

const FREE_DAILY_LIMIT = 3;
const MAX_DREAM_LENGTH = 2000;
const REQUIRED_DISCLAIMER_AR = 'هذا تفسير عام وليس حكماً مؤكداً، والله أعلم.';

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

// ---- Safety filters -----------------------------------------------------

const HIGH_RISK_AR = [
  'طلاق', 'تكفير', 'كافر', 'انتحار', 'اقتل نفسي', 'اؤذي نفسي',
  'يضربني', 'يضربها', 'يخونني', 'تخونني', 'يسحرني',
];
const CRISIS_AR = ['انتحار', 'اقتل نفسي', 'اؤذي نفسي'];

function isHighRisk(text) {
  if (!text) return false;
  const haystack = normalizeArabic(text);
  return HIGH_RISK_AR.some((kw) => haystack.includes(kw));
}

function isCrisis(text) {
  if (!text) return false;
  const haystack = normalizeArabic(text);
  return CRISIS_AR.some((kw) => haystack.includes(kw));
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
    if (used >= limit) return { used, limit, remaining: 0, blocked: true };
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

exports.interpretDream = functions.onCall(
  { maxInstances: 5 },
  async (request) => {
    const auth = request.auth;
    if (!auth) {
      throw new functions.HttpsError('unauthenticated', 'Sign in required.');
    }

    const data = request.data || {};
    const dreamText = String(data.dreamText || '').trim();

    if (!dreamText) {
      throw new functions.HttpsError('invalid-argument', 'Dream text is empty.');
    }
    if (dreamText.length > MAX_DREAM_LENGTH) {
      throw new functions.HttpsError(
        'invalid-argument',
        `Dream text is too long (max ${MAX_DREAM_LENGTH} chars).`,
      );
    }

    if (isCrisis(dreamText)) {
      throw new functions.HttpsError(
        'permission-denied',
        'crisis_detected: please use the support resources flow.',
      );
    }
    if (isHighRisk(dreamText)) {
      throw new functions.HttpsError(
        'permission-denied',
        'high_risk_topic: this dream contains content we will not interpret.',
      );
    }

    const limitState = await incrementDailyLimit(
      auth.uid,
      'dream',
      FREE_DAILY_LIMIT,
    );
    if (limitState.blocked) {
      throw new functions.HttpsError(
        'resource-exhausted',
        `Daily dream-interpretation limit reached (${limitState.limit}/day).`,
      );
    }

    const normalized = normalizeArabic(dreamText);

    const symbolsSnap = await admin
      .firestore()
      .collection('dream_symbols')
      .where('approved', '==', true)
      .limit(500)
      .get();

    const matched = [];
    symbolsSnap.forEach((doc) => {
      const sym = doc.data();
      const symbolKey = normalizeArabic(sym.symbol_ar || '');
      if (symbolKey && normalized.includes(symbolKey)) {
        matched.push({ id: doc.id, ...sym });
      }
    });

    if (matched.length > 0) {
      const general = matched
        .map((s) => s.meaning_general_ar)
        .filter(Boolean)
        .join(' ');
      const meanings = matched
        .map((s) => s.meaning_safe_ar)
        .filter(Boolean);

      const ref = await admin.firestore().collection('dream_interpretations').add({
        userId: auth.uid,
        dreamText,
        matchedSymbolIds: matched.map((s) => s.id),
        source: 'dream_symbols',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      return {
        source: 'dream_symbols',
        matchedSymbolIds: matched.map((s) => s.id),
        generalInterpretation: general,
        possibleMeanings: meanings,
        islamicAdvice:
          'استغفر الله، وأكثر من الصلاة على النبي ﷺ، وتصدّق بما يسره الله لك.',
        disclaimer: REQUIRED_DISCLAIMER_AR,
        interpretationId: ref.id,
      };
    }

    const apiKey = process.env.OPENAI_API_KEY || '';
    if (!apiKey) {
      throw new functions.HttpsError(
        'failed-precondition',
        'ai_not_configured: no DB match and OPENAI_API_KEY is not set.',
      );
    }
    throw new functions.HttpsError(
      'unimplemented',
      'ai_path_pending_implementation: see interpretDream.js header.',
    );
  },
);
