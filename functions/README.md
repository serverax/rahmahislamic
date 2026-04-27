# Rahma Cloud Functions

TypeScript Cloud Functions that back the Ask Sheikh, Dream Interpretation,
and admin-review surfaces in the mobile app.

## What's here

```
functions/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts                  // Function exports
│   ├── askSheikh.ts              // POST onCall: search approved_answers, AI fallback
│   ├── interpretDream.ts         // POST onCall: search dream_symbols, AI fallback
│   ├── adminApproveAnswer.ts     // POST onCall: admin approves a pending answer
│   └── lib/
│       ├── normalize.ts          // Arabic text normalisation (TS port of normalizer.py)
│       ├── safety.ts             // Blocked-keyword content filter, post-gen safety pass
│       ├── limits.ts             // Per-user daily limit (Firestore-backed)
│       └── types.ts              // Shared TypeScript types
└── README.md (this file)
```

## Status

**Scaffold — not yet deployed.** All three functions:
- Compile cleanly (run `npm install && npm run build` in this dir).
- Implement auth + daily-limit + blocked-content + Firestore search.
- Wire the OpenAI fallback path **structurally** but skip the actual API
  call. Without an OpenAI API key configured, the AI path returns a
  typed `failed-precondition` error so the mobile app surfaces it as
  "AI not configured yet — answers limited to local DB."

This means the functions are useful **immediately** with just the local
Firestore corpus (`approved_answers`, `dream_symbols`). The OpenAI
fallback flips on the moment you set the API key.

## Deployment prerequisites (user-side, NOT Claude Code)

1. **Firebase Blaze plan.** Cloud Functions require pay-as-you-go billing.
   Spark (free) blocks deployment. Upgrade in Firebase Console →
   Settings → Usage and Billing → Modify Plan → Blaze.

2. **Firebase CLI authenticated locally.**
   ```
   npm install -g firebase-tools
   firebase login
   ```
   This opens an OAuth browser flow on your machine. From a Claude
   Code shell I can't do this for you.

3. **Anonymous sign-in enabled** (already a prerequisite from the
   Firebase Auth slice). Authentication → Sign-in method → Anonymous
   → Enable.

4. **OpenAI API key (optional for MVP).** When you're ready to enable
   the AI fallback path, run:
   ```
   firebase functions:secrets:set OPENAI_API_KEY
   ```
   Until that's done, the AI path returns a clear "not configured"
   error and the local DB search continues to work.

5. **Seed data (optional but useful).** The Python scraper at
   `C:\Users\kalsh\rahma_scraper\` can populate `approved_answers` and
   `dream_symbols`. Both have admin-review gates per the security rules.

## How to deploy

Once the prerequisites above are met:

```
cd functions
npm install
cd ..
firebase deploy --only firestore:rules,firestore:indexes,functions
```

Order matters: rules + indexes deploy before function code, otherwise the
first function invocation may hit unindexed query errors.

To deploy just one function (faster iteration):
```
firebase deploy --only functions:askSheikhQuestion
```

## How to test locally (after `npm install`)

The Functions emulator runs the same code with no Firebase project costs:
```
cd functions
npm run serve
```
Then call the function from the Flutter app pointed at the emulator
endpoint, or via `curl` to the local emulator URL.

## Function contracts (matches the mobile-app side)

### `askSheikhQuestion(data: { question: string, language: 'ar'|'en', madhhab?: string })`
Returns:
```ts
{
  source: 'approved_answers' | 'ai',
  answer: { short: string, full: string, evidence: Array<{...}> },
  questionId: string,         // ref into user_questions
  questionsRemainingToday: number,
}
```
On failure: throws `HttpsError`:
- `unauthenticated` — no auth
- `resource-exhausted` — daily limit
- `invalid-argument` — empty / blocked content
- `not-found` — no DB match + AI path not configured
- `permission-denied` — high-risk topic that must route to scholar (not AI-answerable)

### `interpretDream(data: { dreamText: string, ... })`
Returns:
```ts
{
  source: 'dream_symbols' | 'ai',
  matchedSymbolIds: string[],
  generalInterpretation: string,
  possibleMeanings: string[],
  islamicAdvice: string,
  disclaimer: string,
  interpretationId: string,    // ref into dream_interpretations
}
```
Same error shape as askSheikhQuestion.

### `adminApproveAnswer(data: { reviewId: string, edits?: {...} })`
Admin-only (verified via `admin_users` collection). Promotes a row from
`pending_reviews` into `approved_answers` (or rejects + records reason).

## What's deliberately NOT done in this scaffold

- **No real OpenAI call.** Adds the `openai` SDK dep and an actual
  `chat.completions.create(...)` call when you set the API key. Until
  then the path returns a `failed-precondition` so the failure mode is
  loud, not silent.
- **No safety pass model** (e.g. a second LLM call to validate AI
  output). Local blocked-keyword check still runs; the LLM-based
  validator can be a follow-up.
- **No source-citation enforcement.** Per `ASK_SHEIKH_PLAN.md`: AI may
  only cite sources that exist in `evidence_sources` / `approved_answers`.
  That validator is a follow-up — current AI path is structurally
  scaffolded, not active.
- **No admin UI.** `adminApproveAnswer` is the backend; the UI lives in
  a separate small admin web app per `DREAM_INTERPRETATION_PLAN.md`.
- **No deployment.** I can't `firebase login` from this shell. You run
  the deploy step yourself once the prereqs are met.

## Religious-content gate

Per `ASK_SHEIKH_PLAN.md` and `DREAM_INTERPRETATION_PLAN.md`: the
function logic is in place but **the corpus** (the actual answers and
symbol meanings stored in Firestore) **must be reviewed by a qualified
scholar before this is enabled in a production app**. Hard rules
enforced in `safety.ts`:
- High-risk topics (divorce, takfir, violence, complex inheritance,
  abuse, self-harm, complex finance contracts) **never** receive an AI
  answer — they return `permission-denied` and route to a scholar.
- Crisis keywords (self-harm, suicide, abuse) trigger a typed error so
  the app surfaces a support-resources flow, not a religious ruling.
