import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase options for the rahma-app-f7594 project.
///
/// Source: extracted manually from
///   android/app/google-services.json
///   ios/Runner/GoogleService-Info.plist
///
/// Web/macOS/Linux/Windows are not configured for this project.
/// Firebase.initializeApp() throws UnsupportedError on those platforms;
/// main.dart wraps the call in try/catch so the app still boots there
/// (Windows desktop is the dev target).
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Firebase web is not configured for rahma-app. '
        'If web is needed, run `flutterfire configure` to add a web app.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Firebase desktop platform '
          '${defaultTargetPlatform.name} is not configured.',
        );
      default:
        throw UnsupportedError(
          'Unknown target platform $defaultTargetPlatform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDBzXhWMTBH-q4Nrb_9ut5kBZxDdb0QjvM',
    appId: '1:726689849775:android:e204a9133784f900f10f5a',
    messagingSenderId: '726689849775',
    projectId: 'rahma-app-f7594',
    storageBucket: 'rahma-app-f7594.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB9F67cdB1VzwZEtI-0vE3IEJIQjj6pRf4',
    appId: '1:726689849775:ios:f91cff7079768431f10f5a',
    messagingSenderId: '726689849775',
    projectId: 'rahma-app-f7594',
    storageBucket: 'rahma-app-f7594.firebasestorage.app',
    iosBundleId: 'com.rahma.rahmaApp',
  );
}
