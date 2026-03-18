import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/entities.dart';
import '../models/models.dart';
import 'irepositories.dart';

/// Friend repository implementation
class FriendRepository implements IFriendRepository {
  final SupabaseClient _supabase;

  FriendRepository({required SupabaseClient supabase})
      : _supabase = supabase;

  @override
  Future<void> sendFriendRequest({
    required String userId,
    required String friendId,
  }) async {
    await _supabase.from('friends').insert({
      'user_id': userId,
      'friend_id': friendId,
      'status': 'pending',
    });
  }

  @override
  Future<void> acceptFriendRequest({
    required String userId,
    required String friendId,
  }) async {
    await _supabase
        .from('friends')
        .update({'status': 'accepted'})
        .eq('user_id', friendId)
        .eq('friend_id', userId);
  }

  @override
  Future<void> rejectFriendRequest({
    required String userId,
    required String friendId,
  }) async {
    await _supabase
        .from('friends')
        .delete()
        .eq('user_id', friendId)
        .eq('friend_id', userId);
  }

  @override
  Future<void> blockFriend({
    required String userId,
    required String friendId,
  }) async {
    await _supabase
        .from('friends')
        .update({'status': 'blocked'})
        .or('user_id.eq.$userId,friend_id.eq.$userId')
        .or('user_id.eq.$friendId,friend_id.eq.$friendId');
  }

  @override
  Future<void> removeFriend({
    required String userId,
    required String friendId,
  }) async {
    await _supabase
        .from('friends')
        .delete()
        .or('user_id.eq.$userId,friend_id.eq.$userId')
        .or('user_id.eq.$friendId,friend_id.eq.$friendId');
  }

  @override
  Future<List<Friend>> getFriends(String userId) async {
    final response = await _supabase
        .from('friend_list_view')
        .select()
        .eq('user_id', userId)
        .order('friends_since', ascending: false);

    return (response as List)
        .map((e) => FriendModel.fromSupabase(e).toEntity())
        .toList();
  }

  @override
  Future<List<FriendRequest>> getFriendRequests(String userId) async {
    final response = await _supabase
        .from('friend_requests_view')
        .select()
        .eq('receiver_id', userId)
        .order('request_date', ascending: false);

    return (response as List)
        .map((e) => FriendRequestModel.fromSupabase(e).toEntity())
        .toList();
  }

  @override
  Future<bool> areFriends(String userId, String friendId) async {
    final response = await _supabase
        .from('friends')
        .select('id')
        .eq('user_id', userId)
        .eq('friend_id', friendId)
        .eq('status', 'accepted')
        .maybeSingle();

    return response != null;
  }

  @override
  Future<List<LeaderboardEntry>> getFriendsLeaderboard(String userId) async {
    final response = await _supabase
        .from('friends_leaderboard_view')
        .select()
        .eq('user_id', userId)
        .order('balance', ascending: false);

    return (response as List)
        .map((e) {
      // Convert friend leaderboard data to LeaderboardEntry
      return LeaderboardEntry(
        rank: e['friend_rank'] as int,
        id: e['friend_id'] as String,
        username: e['username'] as String,
        avatarKey: e['avatar_key'] as String?,
        balance: (e['balance'] as num).toDouble(),
        totalWins: e['total_wins'] as int? ?? 0,
        lifetimeWinnings: (e['lifetime_winnings'] as num?)?.toDouble() ?? 0.0,
      );
    }).toList();
  }
}
