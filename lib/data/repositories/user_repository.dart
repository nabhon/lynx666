import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/entities.dart';
import '../models/models.dart';
import 'irepositories.dart';

/// User repository implementation
class UserRepository implements IUserRepository {
  final SupabaseClient _supabase;

  UserRepository({required SupabaseClient supabase})
      : _supabase = supabase;

  @override
  Future<List<LeaderboardEntry>> getLeaderboard({
    int page = 1,
    int limit = 50,
  }) async {
    final response = await _supabase
        .from('leaderboard_view')
        .select()
        .range((page - 1) * limit, page * limit - 1);

    return (response as List)
        .map((e) => LeaderboardEntryModel.fromSupabase(e).toEntity())
        .toList();
  }

  @override
  Future<UserStats?> getUserStats(String userId) async {
    try {
      final response = await _supabase
          .from('user_stats_view')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;

      final model = UserStatsModel.fromSupabase(response);
      return model.toEntity();
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') return null;
      rethrow;
    }
  }

  @override
  Future<Profile?> getUserById(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .isFilter('deleted_at', null)
          .maybeSingle();

      if (response == null) return null;

      final model = ProfileModel.fromSupabase(response);
      return model.toEntity();
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') return null;
      rethrow;
    }
  }

  @override
  Future<List<Profile>> getUsersByIds(List<String> userIds) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .inFilter('id', userIds)
        .isFilter('deleted_at', null);

    return (response as List)
        .map((e) => ProfileModel.fromSupabase(e).toEntity())
        .toList();
  }

  @override
  Future<List<Profile>> searchUsers(String query, {int limit = 20}) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .ilike('username', '%$query%')
        .isFilter('deleted_at', null)
        .eq('status', 'ACTIVE')
        .limit(limit);

    return (response as List)
        .map((e) => ProfileModel.fromSupabase(e).toEntity())
        .toList();
  }

  @override
  Future<List<LeaderboardEntry>> getTopUsers(int limit) async {
    final response = await _supabase
        .from('leaderboard_view')
        .select()
        .limit(limit);

    return (response as List)
        .map((e) => LeaderboardEntryModel.fromSupabase(e).toEntity())
        .toList();
  }
}
