// Rahma Cloud Functions entry point.
// Each function is exported individually so `firebase deploy --only
// functions:<name>` works.

import * as admin from 'firebase-admin';

admin.initializeApp();

export { askSheikhQuestion } from './askSheikh';
export { interpretDream } from './interpretDream';
export { adminApproveAnswer } from './adminApproveAnswer';
