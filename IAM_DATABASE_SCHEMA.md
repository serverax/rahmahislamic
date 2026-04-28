# RAHMAH IAM - DATABASE SCHEMA

## Collections (14 total)

### 1. users (Primary User Record)
```
userId (doc ID)
├── displayName: string
├── username: string
├── email: string
├── emailVerified: boolean
├── phone: string
├── profileImageUrl: string
├── publicProfileUrl: string
├── authProviders: array[string]
├── language: string (en/ar)
├── role: string (user/teacher/admin)
├── accountType: string (guest/user/child/parent/teacher/admin)
├── isBlocked: boolean
├── riskLevel: string (low/medium/high/blocked)
├── mfaEnabled: boolean
├── mfaRequired: boolean
├── mfaPromptAfterDays: number
├── lastMfaPromptAt: timestamp
├── createdAt: timestamp
├── lastLoginAt: timestamp
├── lastKnownIpHash: string
├── lastKnownDeviceHash: string
├── lastKnownCountry: string
```

### 2. auth_events (All Login/Signup Events)
```
docId (auto)
├── userId: string
├── eventType: string (login/signup/failed_login/logout/mfa_enrolled)
├── provider: string (google/facebook/apple/password/guest)
├── riskLevel: string
├── ipHash: string
├── deviceHash: string
├── country: string
├── appCheckVerified: boolean
├── recaptchaScore: number (0-1)
├── createdAt: timestamp
```

### 3. login_risk_events (Risk Scoring)
```
docId (auto)
├── userId: string
├── riskScore: number (0-100)
├── riskLevel: string
├── riskReasons: array[string]
├── actionTaken: string (allow/prompt_mfa/deny)
├── createdAt: timestamp
```

### 4. mfa_enrolments (MFA Setup)
```
userId_method (doc ID: "userId_totp")
├── userId: string
├── method: string (totp/sms)
├── status: string (active/inactive)
├── createdAt: timestamp
├── lastUsedAt: timestamp
```

### 5. ip_bans (IP Blacklist)
```
docId (auto)
├── ipHash: string
├── reason: string
├── duration: number (hours)
├── expiresAt: timestamp
├── createdBy: string (admin userId)
├── createdAt: timestamp
```

### 6. device_bans (Device Blacklist)
```
docId (auto)
├── deviceHash: string
├── reason: string
├── duration: number (hours)
├── expiresAt: timestamp
├── createdBy: string (admin userId)
├── createdAt: timestamp
```

### 7. prayer_settings (User Prayer Config)
```
userId (doc ID)
├── locationMode: string (auto/manual)
├── city: string
├── country: string
├── latitude: number
├── longitude: number
├── calculationMethod: string (ISNA/MWL/EGYPT/KARACHI/TEHRAN)
├── asrMethod: string (Shafi/Hanafi)
├── timeFormat: string (12h/24h)
├── fajrAdjustment: number (minutes)
├── dhuhrAdjustment: number (minutes)
├── asrAdjustment: number (minutes)
├── maghribAdjustment: number (minutes)
├── ishaAdjustment: number (minutes)
├── notificationsEnabled: boolean
├── updatedAt: timestamp
```

### 8. prayer_cache (Daily Prayer Times)
```
userId_date (doc ID: "userId_2026-04-28")
├── userId: string
├── date: string (YYYY-MM-DD)
├── fajr: string (HH:MM)
├── dhuhr: string (HH:MM)
├── asr: string (HH:MM)
├── maghrib: string (HH:MM)
├── isha: string (HH:MM)
├── lastPrayer: string (fajr/dhuhr/asr/maghrib/isha)
├── nextPrayer: string
├── nextPrayerTime: string (HH:MM)
├── updatedAt: timestamp
```

### 9. rate_limits (Signup/Login Rate Limiting)
```
ipHash_date (doc ID: "ipHash_2026-04-28")
├── ipHash: string
├── date: string (YYYY-MM-DD)
├── signups: number
├── loginAttempts: number
├── failedLogins: number
```

### 10. app_config (Global Settings)
Collection: app_config
Document: iam
```
├── googleLoginEnabled: boolean
├── facebookLoginEnabled: boolean
├── appleLoginEnabled: boolean
├── emailLoginEnabled: boolean
├── guestLoginEnabled: boolean
├── appCheckRequired: boolean
├── recaptchaEnterpriseEnabled: boolean
├── mfaPromptAfterDays: number
├── mfaRequiredForAdmins: boolean
├── mfaRequiredForTeachers: boolean
├── riskBasedMfaEnabled: boolean
├── maxAccountsPerIpPerDay: number
├── maxFailedLoginAttempts: number
```

### 11. admin_audit_logs (Admin Actions)
```
docId (auto)
├── adminId: string
├── action: string (ban_user/ban_ip/enable_mfa/change_role)
├── targetUserId: string
├── targetIp: string
├── details: object
├── createdAt: timestamp
```

### 12. guest_access_limits (Guest Session Tracking)
```
guestId_date (doc ID)
├── guestId: string
├── date: string
├── askSheikhQuestions: number
├── dreamInterpretations: number
├── aiTeacherSessions: number
├── sessionDuration: number
```

### 13. parent_controls (Child Account Management)
```
childId (doc ID)
├── childId: string
├── parentId: string
├── name: string
├── age: number
├── canRecord: boolean
├── parentConsent: boolean
├── restrictions: object
├── createdAt: timestamp
```

### 14. login_providers (OAuth Config)
```
provider (doc ID: "google", "facebook", "apple")
├── enabled: boolean
├── clientId: string (encrypted)
├── clientSecret: string (encrypted)
├── scopes: array[string]
├── redirectUrls: array[string]
└── updatedAt: timestamp
```

---

## Indexes

### Required Composite Indexes

1. users (email, lastLoginAt)
2. auth_events (userId, eventType, createdAt)
3. login_risk_events (userId, riskLevel, createdAt)
4. auth_events (ipHash, createdAt)
5. auth_events (deviceHash, createdAt)
6. ip_bans (ipHash, expiresAt)
7. device_bans (deviceHash, expiresAt)
8. rate_limits (ipHash, date)
9. guest_access_limits (guestId, date)
10. admin_audit_logs (adminId, createdAt)

---

## Security Rules

Default: DENY ALL

Allow:
- users/{userId}: User reads/writes own document
- prayer_settings/{userId}: User reads/writes own settings
- prayer_cache/{userId}/date: User reads own cache
- auth_events: Only admins read, Cloud Functions write
- login_risk_events: Only admins read, Cloud Functions write
- ip_bans: Only admins read, Cloud Functions write
- device_bans: Only admins read, Cloud Functions write
- admin_audit_logs: Only admins read, Cloud Functions write

