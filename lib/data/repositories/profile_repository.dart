import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/entities.dart';
import '../models/models.dart';
import 'irepositories.dart';

/// Profile repository implementation
class ProfileRepository implements IProfileRepository {
  final SupabaseClient _supabase;

  ProfileRepository({required SupabaseClient supabase})
      : _supabase = supabase;

  @override
  Future<Profile?> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .isFilter('deleted_at', null)
          .single();

      final model = ProfileModel.fromSupabase(response);
      return model.toEntity();
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') return null; // No rows found
      rethrow;
    }
  }

  @override
  Future<Profile?> getCurrentProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return getProfile(user.id);
  }

  @override
  Future<Profile> createProfile(Profile profile) async {
    final model = ProfileModel.fromEntity(profile);

    final response = await _supabase
        .from('profiles')
        .insert(model.toSupabase())
        .select()
        .single();

    return ProfileModel.fromSupabase(response).toEntity();
  }

  @override
  Future<Profile> updateProfile(Profile profile) async {
    final model = ProfileModel.fromEntity(profile);

    final response = await _supabase
        .from('profiles')
        .update(model.toSupabase())
        .eq('id', profile.id)
        .select()
        .single();

    return ProfileModel.fromSupabase(response).toEntity();
  }

  @override
  Future<void> deleteProfile(String userId) async {
    await _supabase
        .from('profiles')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', userId);
  }

  @override
  Future<bool> isUsernameAvailable(String username) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('id')
          .eq('username', username)
          .isFilter('deleted_at', null)
          .maybeSingle();

      return response == null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Profile> updateBalance(String userId, double newBalance) async {
    final response = await _supabase
        .from('profiles')
        .update({'balance': newBalance})
        .eq('id', userId)
        .select()
        .single();

    return ProfileModel.fromSupabase(response).toEntity();
  }

  @override
  Future<Profile> completeOnboarding({
    required String userId,
    required String username,
    required String avatarKey,
  }) async {
    final response = await _supabase
        .from('profiles')
        .update({
          'username': username,
          'avatar_key': avatarKey,
          'is_onboarding_complete': true,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId)
        .select()
        .single();

    return ProfileModel.fromSupabase(response).toEntity();
  }
}
