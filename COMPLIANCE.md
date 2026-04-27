# Rahma — App Store Compliance Checklist

Tracks what's done vs what needs to be done before submitting to
Apple App Store and Google Play. Single source of truth so we don't
lose state across sessions.

## Done — committed to the repo

### iOS (`ios/Runner/Info.plist`)
- `CFBundleLocalizations` — declares `en` and `ar` so iOS shows the
  app in user's preferred language
- `NSLocationWhenInUseUsageDescription` — required by `geolocator`
  for prayer times and Qibla
- `NSLocationAlwaysAndWhenInUseUsageDescription` — same string,
  satisfies older API path
- `UISupportedInterfaceOrientations` (already present) — portrait +
  landscape for both iPhone and iPad

### Android (`android/app/src/main/AndroidManifest.xml`)
- `android.permission.INTERNET` — Aladhan, Quran.com, Supabase
- `android.permission.ACCESS_FINE_LOCATION`
- `android.permission.ACCESS_COARSE_LOCATION`

### Other (already done in earlier commits)
- `SECURITY.md` — full security architecture
- `firestore.rules` — deny-by-default rules
- `android/app/proguard-rules.pro` + `build.gradle.kts` — release minify
  + log stripping
- `.env` gitignored
- `AskSheikhTile` already shows the scholar disclaimer dialog when tapped
- `DREAM_INTERPRETATION_PLAN.md` documents the warning screen + safety
  rules for when that feature is implemented

## Not done — deliberately deferred

### Permission strings I did NOT add (and why)
- `NSCameraUsageDescription` — app does not use the camera
- `NSMicrophoneUsageDescription` — app does not use the microphone
- `NSUserTrackingUsageDescription` — app does not use ATT (no
  third-party tracking SDK installed)
- `POST_NOTIFICATIONS` (Android 13+) — notifications not yet
  implemented; will add when the FCM / local-notifications slice ships
- `FOREGROUND_SERVICE` — adhan audio playback not yet implemented

**Reason**: Adding permission strings for features the app doesn't
have invites App Store reviewer rejection ("why do you request X
without using it?"). Add each string in the same commit that ships
the feature that needs it.

### Dependencies between code and permissions

| Permission / string | Required by | Currently used? |
|---|---|---|
| Location strings (iOS + Android) | `geolocator` | ✅ Yes — Slice 2 prayer location |
| Camera | — | No |
| Microphone | — | No |
| ATT (iOS) | analytics SDKs that track | No |
| `POST_NOTIFICATIONS` | `flutter_local_notifications` | No (not added) |
| `FOREGROUND_SERVICE` | adhan audio playback | No (not added) |

### Disclaimers
- Ask Sheikh: scholar disclaimer dialog **already shipped** in
  `lib/presentation/screens/home/widgets/ask_sheikh_tile.dart`
  (EN + AR via ARB strings). Will be promoted to the actual screens
  when Slice 7 ships.
- Dream Interpretation: warning screen designed in
  `DREAM_INTERPRETATION_PLAN.md`; ships when feature ships.

## Pre-launch tasks (NOT this session)

- [ ] Privacy policy hosted at e.g. `https://rahmaapp.com/privacy`
- [ ] Terms of service hosted at e.g. `https://rahmaapp.com/terms`
- [ ] Support email or page configured
- [ ] App Store Connect listing: name, subtitle, keywords, description
      (EN + AR), screenshots, 1024×1024 icon
- [ ] Google Play Console: title, descriptions, screenshots, feature
      graphic, 512×512 icon, data safety form, IARC questionnaire
- [ ] Privacy nutrition labels (iOS) declared in App Store Connect
- [ ] `flutter build appbundle --release` — generate `.aab`
- [ ] `flutter build ipa --release` — generate `.ipa` (needs Apple
      Developer account + Mac)
- [ ] Apple Developer enrollment ($99/year)
- [ ] Google Play Developer enrollment ($25 one-time)
- [ ] Test on real devices (current testing has been Windows desktop only)
- [ ] Penetration test for Ask Sheikh AI surface (when that ships)

## SDK / deployment target notes

`compileSdk` and `targetSdk` for Android are managed by Flutter via
`flutter.compileSdkVersion` / `flutter.targetSdkVersion` (see
`android/app/build.gradle.kts`). They follow the Flutter version
in use (currently 3.41.7) and don't need manual override unless
Google Play raises the minimum target above what Flutter ships.

iOS deployment target is set in `ios/Podfile` (currently inherits
Flutter's default, typically 12.0+). Apple raises the minimum
periodically — verify before release.

## Content decisions already aligned

- ✅ App is religious / educational: not subject to medical, legal,
  or financial-advice rejection categories
- ✅ Quran content is religious text (allowed)
- ✅ All adhkar / duas have Sahih source attribution in the JSON
- ✅ Ask Sheikh and Dream Interpretation features include explicit
  "general guidance only — consult a qualified scholar" disclaimers
- ✅ No tracking SDKs that need ATT (yet)
