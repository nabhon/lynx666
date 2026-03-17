import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';

class SupabaseService {
  static SupabaseService? _instance;
  late final SupabaseClient _supabase;

  SupabaseService._internal();

  factory SupabaseService() {
    _instance ??= SupabaseService._internal();
    return _instance!;
  }

  SupabaseClient get supabase => _supabase;

  Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
    _supabase = Supabase.instance.client;
  }

  /// Get the current user session
  Session? get currentSession => _supabase.auth.currentSession;

  /// Get the current user
  User? get currentUser => _supabase.auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign up with email and password
  Future<AuthResponse> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Upload avatar to storage
  Future<String> uploadAvatar({
    required String userId,
    required String filePath,
  }) async {
    await supabase.storage
        .from('avatars')
        .upload('$userId.jpg', File(filePath), fileOptions: const FileOptions(upsert: true));
    return '$userId.jpg';
  }

  /// Get avatar URL
  String getAvatarUrl(String avatarKey) {
    return supabase.storage.from('avatars').getPublicUrl(avatarKey);
  }
}
