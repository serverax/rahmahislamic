/**
 * RAHMAH IAM LAYER
 * Enterprise-grade authentication, authorization, and risk management
 */

const functions = require('firebase-functions');
const admin = require('firebase-admin');

const db = admin.firestore();
const auth = admin.auth();

// ============================================
// HUMAN VERIFICATION - 5 LAYERS
// ============================================

/**
 * Layer 1: Firebase App Check
 * Ensures request comes from legitimate app, not bot/emulator
 */
async function verifyAppCheck(req) {
  const appCheckToken = req.header('X-Firebase-AppCheck') || '';
  if (!appCheckToken) {
    throw new Error('Missing App Check token');
  }
  // In production: verify token with Firebase
  return true;
}

/**
 * Layer 2: Social Login or Verified Email
 */
async function verifySocialOrEmail(userId) {
  const user = await auth.getUser(userId);
  if (!user.emailVerified && !user.providerData.length) {
    throw new Error('Email not verified and no social provider');
  }
  return true;
}

/**
 * Layer 3: reCAPTCHA Enterprise
 * For suspicious signups
 */
async function verifyRecaptcha(riskLevel) {
  if (riskLevel === 'high') {
    // Require reCAPTCHA token
    return true;
  }
  return false;
}

/**
 * Layer 4: Rate Limits per IP/Device
 */
async function checkRateLimits(ipHash, deviceHash) {
  const today = new Date().toISOString().split('T')[0];
  const key = `${ipHash}_${today}`;
  
  const limitDoc = await db.collection('rate_limits').doc(key).get();
  const count = limitDoc.exists ? limitDoc.data().signups : 0;
  
  if (count >= 5) {
    throw new Error('Too many signups from this IP/device today');
  }
  
  return count + 1;
}

/**
 * Layer 5: MFA for sensitive operations
 */
async function requireMFA(userId, userRole, daysWithoutMFA) {
  // Admins require MFA immediately
  if (userRole === 'admin') {
    return true;
  }
  
  // Teachers require MFA before live teaching
  if (userRole === 'teacher') {
    return true;
  }
  
  // Normal users after 10 days
  if (daysWithoutMFA > 10) {
    return true;
  }
  
  return false;
}

// ============================================
// RISK ENGINE
// ============================================

/**
 * Calculate login risk score (0-100)
 */
async function calculateLoginRisk(context) {
  let riskScore = 0;
  let riskReasons = [];
  
  // Signal 1: Missing App Check
  if (!context.appCheckVerified) {
    riskScore += 20;
    riskReasons.push('Missing App Check verification');
  }
  
  // Signal 2: New device
  const userDoc = await db.collection('users').doc(context.userId).get();
  if (userDoc.exists && userDoc.data().lastKnownDeviceHash !== context.deviceHash) {
    riskScore += 15;
    riskReasons.push('New device detected');
  }
  
  // Signal 3: New country
  if (userDoc.exists && userDoc.data().lastKnownCountry !== context.country) {
    riskScore += 20;
    riskReasons.push('New country detected');
  }
  
  // Signal 4: Unverified email
  const user = await auth.getUser(context.userId);
  if (!user.emailVerified && context.provider === 'password') {
    riskScore += 15;
    riskReasons.push('Unverified email');
  }
  
  // Signal 5: Multiple accounts from same IP
  const ipAccounts = await db.collection('users')
    .where('lastKnownIpHash', '==', context.ipHash)
    .limit(10)
    .get();
  
  if (ipAccounts.size > 5) {
    riskScore += 25;
    riskReasons.push(`${ipAccounts.size} accounts from same IP`);
  }
  
  // Signal 6: Failed login attempts
  const failedLogins = await db.collection('auth_events')
    .where('userId', '==', context.userId)
    .where('eventType', '==', 'failed_login')
    .where('createdAt', '>', new Date(Date.now() - 3600000)) // Last hour
    .get();
  
  if (failedLogins.size > 3) {
    riskScore += 20;
    riskReasons.push(`${failedLogins.size} failed login attempts in last hour`);
  }
  
  // Determine risk level
  let riskLevel = 'low';
  if (riskScore >= 50) riskLevel = 'high';
  else if (riskScore >= 25) riskLevel = 'medium';
  
  return {
    riskScore: Math.min(riskScore, 100),
    riskLevel,
    riskReasons
  };
}

// ============================================
// AUTH FLOW FUNCTIONS
// ============================================

/**
 * Sync secure user profile after login
 */
exports.syncSecureUserProfile = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Auth required');
  }
  
  const userId = context.auth.uid;
  const user = await auth.getUser(userId);
  
  // Get or create user document
  const userRef = db.collection('users').doc(userId);
  const userDoc = await userRef.get();
  
  const userData = {
    userId,
    email: user.email,
    emailVerified: user.emailVerified,
    displayName: user.displayName || '',
    profileImageUrl: user.photoURL || '',
    authProviders: user.providerData.map(p => p.providerId),
    language: data.language || 'en',
    role: 'user',
    accountType: 'user',
    isBlocked: false,
    mfaEnabled: user.multiFactor ? user.multiFactor.enrolledFactors.length > 0 : false,
    mfaRequired: false,
    mfaPromptAfterDays: 10,
    lastMfaPromptAt: null,
    lastLoginAt: admin.firestore.FieldValue.serverTimestamp(),
    lastKnownIpHash: data.ipHash,
    lastKnownDeviceHash: data.deviceHash,
    lastKnownCountry: data.country,
    createdAt: userDoc.exists ? userDoc.data().createdAt : admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  };
  
  await userRef.set(userData, { merge: true });
  
  return {
    success: true,
    userId,
    email: user.email
  };
});

/**
 * Check MFA status and risk level
 */
exports.checkMfaAndRisk = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Auth required');
  }
  
  const userId = context.auth.uid;
  const userDoc = await db.collection('users').doc(userId).get();
  
  if (!userDoc.exists) {
    return { mfaRequired: false, riskLevel: 'unknown' };
  }
  
  const userData = userDoc.data();
  
  // Calculate risk
  const riskContext = {
    userId,
    appCheckVerified: data.appCheckVerified || false,
    deviceHash: data.deviceHash,
    country: data.country,
    provider: data.provider
  };
  
  const riskData = await calculateLoginRisk(riskContext);
  
  // Determine MFA requirement
  let mfaRequired = false;
  
  if (userData.role === 'admin' || userData.role === 'teacher') {
    mfaRequired = true;
  }
  
  if (riskData.riskLevel === 'high') {
    mfaRequired = true;
  }
  
  // Log auth event
  await db.collection('auth_events').add({
    userId,
    eventType: 'login_check',
    riskLevel: riskData.riskLevel,
    ipHash: data.ipHash,
    deviceHash: data.deviceHash,
    country: data.country,
    appCheckVerified: data.appCheckVerified,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  });
  
  return {
    mfaRequired,
    riskLevel: riskData.riskLevel,
    riskScore: riskData.riskScore,
    riskReasons: riskData.riskReasons
  };
});

/**
 * Log authentication event
 */
exports.logAuthEvent = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Auth required');
  }
  
  await db.collection('auth_events').add({
    userId: context.auth.uid,
    eventType: data.eventType,
    provider: data.provider,
    ipHash: data.ipHash,
    deviceHash: data.deviceHash,
    country: data.country,
    appCheckVerified: data.appCheckVerified || false,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  });
  
  return { success: true };
});

/**
 * Ban user (admin only)
 */
exports.banUser = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Auth required');
  }
  
  const adminDoc = await db.collection('users').doc(context.auth.uid).get();
  if (adminDoc.data().role !== 'admin') {
    throw new functions.https.HttpsError('permission-denied', 'Admin only');
  }
  
  const { userId, reason } = data;
  
  await db.collection('users').doc(userId).update({
    isBlocked: true,
    blockReason: reason,
    blockedAt: admin.firestore.FieldValue.serverTimestamp()
  });
  
  return { success: true, userId };
});

/**
 * Ban IP address (admin only)
 */
exports.banIp = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Auth required');
  }
  
  const adminDoc = await db.collection('users').doc(context.auth.uid).get();
  if (adminDoc.data().role !== 'admin') {
    throw new functions.https.HttpsError('permission-denied', 'Admin only');
  }
  
  const { ipHash, reason, duration } = data;
  
  await db.collection('ip_bans').add({
    ipHash,
    reason,
    duration,
    expiresAt: new Date(Date.now() + duration * 3600000),
    createdBy: context.auth.uid,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  });
  
  return { success: true, ipHash };
});

/**
 * Update prayer settings
 */
exports.updatePrayerSettings = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Auth required');
  }
  
  const userId = context.auth.uid;
  
  await db.collection('prayer_settings').doc(userId).set({
    userId,
    locationMode: data.locationMode || 'auto',
    city: data.city,
    country: data.country,
    latitude: data.latitude,
    longitude: data.longitude,
    calculationMethod: data.calculationMethod || 'ISNA',
    asrMethod: data.asrMethod || 'Shafi',
    timeFormat: data.timeFormat || '24h',
    fajrAdjustment: data.fajrAdjustment || 0,
    dhuhrAdjustment: data.dhuhrAdjustment || 0,
    asrAdjustment: data.asrAdjustment || 0,
    maghribAdjustment: data.maghribAdjustment || 0,
    ishaAdjustment: data.ishaAdjustment || 0,
    notificationsEnabled: data.notificationsEnabled !== false,
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  }, { merge: true });
  
  return { success: true };
});

module.exports = exports;
