# Cloud Functions — Console paste-deploy variants (plain JavaScript)

This folder contains **self-contained plain-JavaScript** versions of the
three Cloud Functions, with all helpers inlined into a single file each.

These are an alternative to the TypeScript code in `../functions/`. Use
whichever fits your deploy workflow:

| | `../functions/` (TypeScript) | `./functions-console/` (plain JS) |
|---|---|---|
| Build step | `npm install && npm run build` | none — paste as-is |
| Type safety | full | none |
| Dependencies | `firebase-admin`, `firebase-functions`, optional `openai` | inlined |
| Module structure | shared `lib/` across files | each file is self-contained |
| Deploy command | `firebase deploy --only functions` from CLI | paste body into Cloud Functions / Cloud Run Console editor and click Deploy |
| Best for | Long-term maintenance, version control, CI | One-off Console deploys, no firebase-tools install |

## How to deploy these via Firebase / Cloud Functions Console

The Firebase Console doesn't have an inline editor for v2 Cloud
Functions. The Google Cloud Functions Console does:

1. Open https://console.cloud.google.com/functions/list?project=rahma-app-f7594
2. Click **Create Function**
3. Set:
   - Environment: 2nd gen
   - Function name: `askSheikhQuestion` (or `interpretDream` or `adminApproveAnswer`)
   - Region: pick the same as your Firestore (e.g. `us-central1`)
   - Authentication: **Allow unauthenticated** is required for Firebase
     callable, since the function itself enforces auth via the request token
   - Trigger type: HTTPS
4. Click **Next**
5. Runtime: Node.js 20
6. Source code: **Inline editor**
7. Replace `index.js` with the contents of the matching file in this
   folder (e.g. `askSheikhQuestion.js`).
8. Replace `package.json` with:
   ```json
   {
     "name": "rahma-functions-console",
     "engines": { "node": "20" },
     "main": "index.js",
     "dependencies": {
       "firebase-admin": "^12.6.0",
       "firebase-functions": "^6.0.1"
     }
   }
   ```
9. Set **Entry point** to the function name (e.g. `askSheikhQuestion`).
10. Click **Deploy**.

Repeat for the other two functions.

## Important constraints

- **Anonymous sign-in must be enabled** in Firebase Auth — see the
  Firebase Auth slice (commit `eea1fe4`).
- **Blaze plan required** to deploy any Cloud Function (v1 or v2).
- The OpenAI fallback path is left as `unimplemented` and returns a
  typed error. To enable it, add the `openai` npm package and complete
  the AI block in each function. Set `OPENAI_API_KEY` either as a
  Cloud Functions environment variable (Console UI) or via
  `firebase functions:secrets:set OPENAI_API_KEY` from the CLI.
- `firestore.rules` and `firestore.indexes.json` at the repo root must
  be deployed for the functions to work correctly. From the Console:
  Firebase Console → Firestore → Rules tab → paste, Indexes tab → paste.

## Religious-content gate

Same as the TS path: the function code is in place but **the
Firestore corpus** (`approved_answers`, `dream_symbols`) must be
reviewed by a qualified scholar before this is enabled in production.
See `ASK_SHEIKH_PLAN.md` and `DREAM_INTERPRETATION_PLAN.md` at the repo
root.
