# Rahma — Security Architecture

This document is the canonical security spec for the project. Every slice
that touches auth, AI, user-generated content, or sensitive religious
guidance must comply with it. Update this file when the architecture
changes; don't keep evolving rules only in chat history.

## Core architecture rule

The mobile app is **untrusted**. It can be reverse-engineered, intercepted,
and modified. Treat it accordingly.

**Forbidden patterns:**
- Mobile app calling OpenAI / any LLM directly
- Mobile app holding the Firebase Admin SDK or any service-role key
- Hard-coded API keys, secrets, or credentials in app source
- Direct database writes from the app without server-side validation

**Required patterns:**
- Mobile app → Firebase Auth token → Cloud Function → upstream service
- Secrets live in Google Secret Manager (production) or `.env` (dev only,
  never committed)
- Firebase App Check on every backend call (Play Integrity / App Attest)
- Firestore security rules deny by default; per-collection allow

## Stack (target — implemented in later slices)

| Layer | Tool | Notes |
|---|---|---|
| Auth | Firebase Authentication | Google + Facebook + Guest. No password storage. |
| Database | Firestore | Strict rules — see `firestore.rules` |
| Backend | Firebase Cloud Functions (TypeScript) | All AI calls; rate limiting; audit log |
| App protection | Firebase App Check | Play Integrity (Android), App Attest (iOS) |
| Local secure storage | `flutter_secure_storage` | Auth tokens only — added when auth lands |
| Monitoring | Firebase Crashlytics or Sentry | No PII or religious content in payloads |
| Release hardening | ProGuard / R8 | `android/app/proguard-rules.pro` (live in repo) |

## Logging policy

**Never log:**
- Ask Sheikh question text, AI prompts, AI responses
- Auth tokens, refresh tokens
- Email addresses, phone numbers, names
- Exact GPS coordinates (round to city or larger)
- Private religious content (bookmarks, saved duas, etc.)

**Safe to log:**
- Error codes, HTTP status codes
- Anonymous user IDs (Firebase UID is fine)
- Screen names, feature usage
- Timestamps

All logs in dev should be wrapped in `kDebugMode` so they're stripped from
release builds. The ProGuard config in `proguard-rules.pro` also strips
`android.util.Log` calls in release.

## Ask Sheikh — extra requirements

When Slice 7 lands:

- **No direct AI access from app.** All requests go through a Cloud
  Function endpoint that validates input, looks up evidence from the
  approved sources collection, classifies risk, and runs a final safety
  pass on the answer.
- **High-risk topics route to scholar.** Divorce, takfir, violence,
  inheritance disputes, abuse, self-harm — no AI answer is ever returned.
- **Crisis detection.** Self-harm/suicide/abuse mentions trigger a
  support-resources flow, not a religious ruling.
- **Source validation.** AI may only cite Quran/Hadith/tafsir/fiqh
  references that exist in the `evidence_sources` Firestore collection.
  Inventing references is forbidden — backend rejects answers that cite
  unknown references.
- **Privacy.** Questions are private to the asking user. A user can delete
  their question history. Questions must never be used for AI training.
- **Safety validator.** A final post-generation check blocks answers
  containing forbidden phrases (e.g. "your divorce happened",
  "this person is a kafir").

## Database collections — security tier

**Owner-scoped (auth required, `userId` must match `auth.uid`):**
`users`, `profiles`, `user_settings`, `quran_bookmarks`, `saved_duas`,
`book_progress`, `adhkar_progress`, `tasbih_sessions`, `sheikh_questions`,
`sheikh_answers`

**Public read, admin write only:**
`evidence_sources`, `books`

**Backend / admin only — no client access:**
`scholar_reviews`, `reports` (clients create only), `admin_users`,
`audit_logs`

See `firestore.rules` for the canonical rule definitions.

## Mobile app checklist

### Now (development)
- [x] HTTPS only (Quran.com, Aladhan)
- [x] `.env` in `.gitignore`
- [x] No secrets in source code
- [x] All `debugPrint` calls wrapped in `kDebugMode`
- [x] Input validation at API boundary (HTTP timeouts, status checks)
- [x] `proguard-rules.pro` checked into repo (activated by build.gradle)

### Before production release
- [ ] Firebase project created; `google-services.json` and
      `GoogleService-Info.plist` placed (currently blocked — files
      not on disk)
- [ ] `firebase deploy --only firestore:rules` run from a machine with
      `firebase login` completed
- [ ] `flutter_secure_storage` added and used for auth tokens
- [ ] Firebase App Check enabled
- [ ] Play Integrity (Android) + App Attest (iOS) configured
- [ ] Cloud Functions deployed for any AI surface (Ask Sheikh)
- [ ] Crashlytics or Sentry wired
- [ ] Privacy policy live; "delete account" flow shipped
- [ ] All `debugPrint` calls audited; release strips them via ProGuard
- [ ] Pen-test pass (or external review) for Ask Sheikh AI surface

## Git hygiene

- `.env` is gitignored. The example template `.env.example` is committed
  with placeholder values.
- Firebase config files (`google-services.json`,
  `GoogleService-Info.plist`) are NOT yet in the repo; when added, audit
  whether they belong in version control or in CI secret storage. They
  contain project IDs and API keys but are commonly committed (the keys
  they hold are scoped by Firebase rules, not secret).
- Consider enabling GitHub secret scanning + Dependabot on the repo
  before going public or accepting external contributions.

## Principle

> Build as if the device is untrusted, the app will be reverse-engineered,
> APIs will be attacked, AI will be manipulated, and religious data is
> highly sensitive. Security is built from day one, not added before
> launch.
