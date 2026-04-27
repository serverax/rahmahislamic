// adminApproveAnswer - Cloud Function (Console paste-deploy variant).
// Plain JavaScript, self-contained.
//
// Promotes a row from pending_reviews into approved_answers. Admin-only,
// gated by the admin_users collection.

const functions = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

if (!admin.apps.length) admin.initializeApp();

exports.adminApproveAnswer = functions.onCall(async (request) => {
  const auth = request.auth;
  if (!auth) {
    throw new functions.HttpsError('unauthenticated', 'Sign in required.');
  }

  // Admin gate: must exist in admin_users collection.
  const adminDoc = await admin
    .firestore()
    .collection('admin_users')
    .doc(auth.uid)
    .get();
  if (!adminDoc.exists) {
    throw new functions.HttpsError('permission-denied', 'Admin role required.');
  }

  const data = request.data || {};
  const reviewId = data.reviewId;
  const decision = data.decision;

  if (!reviewId || !decision) {
    throw new functions.HttpsError(
      'invalid-argument',
      'reviewId and decision required.',
    );
  }
  if (decision !== 'approve' && decision !== 'reject') {
    throw new functions.HttpsError(
      'invalid-argument',
      "decision must be 'approve' or 'reject'.",
    );
  }

  const pendingRef = admin
    .firestore()
    .collection('pending_reviews')
    .doc(reviewId);
  const pending = await pendingRef.get();
  if (!pending.exists) {
    throw new functions.HttpsError(
      'not-found',
      `pending_reviews/${reviewId} not found.`,
    );
  }

  if (decision === 'reject') {
    await pendingRef.update({
      status: 'rejected',
      reason: data.reason || 'no reason provided',
      reviewedBy: auth.uid,
      reviewedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    return { ok: true, status: 'rejected' };
  }

  // approve: write to approved_answers, mark pending as approved
  const pendingData = pending.data() || {};
  const edits = data.edits || {};
  const approvedRef = await admin.firestore().collection('approved_answers').add({
    ...pendingData,
    ...edits,
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
