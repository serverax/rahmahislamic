# Firestore Collection Schemas

Firestore is **schemaless** — collections are created on first write. These files document the *expected* shape of each document so the Cloud Functions, mobile-app code, and admin panel agree.

The 8 collections below match the Cloud Function code in `functions/` (TypeScript) and `functions-console/` (plain JS).

| Collection | Doc id pattern | Owner | Read | Write |
|---|---|---|---|---|
| `users` | `${userId}` | user | self | self |
| `daily_limits` | `${userId}_${kind}_${YYYY-MM-DD}` | user | self | Cloud Function (Admin SDK) |
| `approved_answers` | auto | admin | any signed-in user | Cloud Function (Admin SDK), admin panel |
| `user_questions` | auto | user | self | Cloud Function only (`allow create: false`) |
| `dream_symbols` | auto | admin | any signed-in user (when `approved == true`) | Cloud Function only |
| `dream_interpretations` | auto | user | self | Cloud Function only |
| `daily_ayah` | `${YYYY-MM-DD}` | admin | public read | Cloud Function only |
| `pending_reviews` | auto | admin only | admin only | Cloud Function only |

See `firestore.rules` at the repo root for the canonical security rules.
See `firestore.indexes.json` for the composite indexes.
