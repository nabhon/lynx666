import 'package:supabase_flutter/supabase_flutter.dart';

/// Authentication repository interface
abstract class IAuthRepository {
  /// Get current authenticated user
  User? get currentUser;

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges;

  /// Sign in with email and password
  Future<User> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<User> signUpWithEmailPassword({
    required String email,
    required String password,
  });

  /// Sign out
  Future<void> signOut();

  /// Reset password
  Future<void> resetPassword({required String email});

  /// Update password
  Future<void> updatePassword({required String newPassword});

  /// Get current session
  Session? get currentSession;
}
