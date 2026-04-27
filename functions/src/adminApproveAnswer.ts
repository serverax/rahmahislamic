// adminApproveAnswer - admin-only function to approve a pending AI answer.
//
// Flow:
//   1. Auth check
//   2. Confirm caller is in admin_users collection
//   3. Read the pending row from pending_reviews
//   4. Apply optional edits (the admin UI lets reviewers tweak text)
//   5. Write into approved_answers
//   6. Mark the pending row as approved (or reject + reason)
//
// Deploy with `firebase deploy --only functions:adminApproveAnswer`.

import { onCall, HttpsError } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';

interface ApproveInput {
  reviewId: string;
  decision: 'approve' | 'reject';
  reason?: string;
  edits?: {
    answer_short?: string;
    answer_full?: string;
  };
}

export const adminApproveAnswer = onCall(async (request) => {
  const auth = request.auth;
  if (!auth) {
    throw new HttpsError('unauthenticated', 'Sign in required.');
  }

  const adminDoc = await admin
    .firestore()
    .collection('admin_users')
    .doc(auth.uid)
    .get();
  if (!adminDoc.exists) {
    throw new HttpsError('permission-denied', 'Admin role required.');
  }

  const data = request.data as ApproveInput | undefined;
  if (!data?.reviewId || !data?.decision) {
    throw new HttpsError('invalid-argument', 'reviewId and decision required.');
  }

  const pendingRef = admin
    .firestore()
    .collection('pending_reviews')
    .doc(data.reviewId);
  const pending = await pendingRef.get();
  if (!pending.exists) {
    throw new HttpsError('not-found', `pending_reviews/${data.reviewId} not found.`);
  }

  const pendingData = pending.data() ?? {};

  if (data.decision === 'reject') {
    await pendingRef.update({
      status: 'rejected',
      reason: data.reason ?? 'no reason provided',
      reviewedBy: auth.uid,
      reviewedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    return { ok: true, status: 'rejected' };
  }

  // approve: write to approved_answers, mark pending as approved
  const approvedRef = await admin
    .firestore()
    .collection('approved_answers')
    .add({
      ...pendingData,
      ...(data.edits ?? {}),
      approved: true,
      scholar_reviewed: true,
      approvedBy: auth.uid,
      approvedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

  await pendingRef.update({
    status: 'approved',
    approvedAnswerId: approvedRef.id,
    reviewedBy: auth.uid,
    reviewedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return { ok: true, status: 'approved', approvedAnswerId: approvedRef.id };
});
