import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stream of Firebase Auth state changes. Null when no auth instance is
/// available (e.g. Windows desktop, where Firebase init is skipped).
final authStateProvider = StreamProvider<fb.User?>((ref) {
  try {
    return fb.FirebaseAuth.instance.authStateChanges();
  } catch (_) {
    // No Firebase on this platform (Windows desktop). Always-null stream.
    return Stream<fb.User?>.value(null);
  }
});

class AuthController {
  AuthController._();

  static Future<fb.UserCredential?> signInAnonymously() async {
    try {
      return await fb.FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      throw AuthException(_describe(e));
    }
  }

  static Future<void> signOut() async {
    try {
      await fb.FirebaseAuth.instance.signOut();
    } catch (e) {
      throw AuthException(_describe(e));
    }
  }

  static String _describe(Object e) {
    if (e is fb.FirebaseAuthException) {
      return 'Auth error: ${e.code}${e.message != null ? ' — ${e.message}' : ''}';
    }
    return e.toString();
  }
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
  @override
  String toString() => 'AuthException: $message';
}
