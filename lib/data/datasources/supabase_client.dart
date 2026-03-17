import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';

/// Initializes and provides access to the Supabase client.
/// 
/// After initialization, use [Supabase.instance.client] to access the client.
class SupabaseInit {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}

/// Extension methods for convenient access to common Supabase operations.
extension SupabaseAuthExtension on SupabaseClient {
  /// Get the current user session
  Session? get currentSession => auth.currentSession;

  /// Get the current user
  User? get currentUser => auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign up with email and password
  Future<AuthResponse> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await auth.signUp(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await auth.signOut();
  }
}

/// Extension methods for Supabase storage operations.
extension SupabaseStorageExtension on SupabaseClient {
  /// Upload avatar to storage
  Future<String> uploadAvatar({
    required String userId,
    required String filePath,
  }) async {
    await storage
        .from('avatars')
        .upload('$userId.jpg', File(filePath), fileOptions: const FileOptions(upsert: true));
    return '$userId.jpg';
  }

  /// Get avatar URL
  String getAvatarUrl(String avatarKey) {
    return storage.from('avatars').getPublicUrl(avatarKey);
  }
}
