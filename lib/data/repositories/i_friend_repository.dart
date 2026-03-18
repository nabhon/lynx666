import '../../domain/entities/entities.dart';

/// Friend repository interface
abstract class IFriendRepository {
  /// Send friend request
  Future<void> sendFriendRequest({
    required String userId,
    required String friendId,
  });

  /// Accept friend request
  Future<void> acceptFriendRequest({
    required String userId,
    required String friendId,
  });

  /// Reject friend request
  Future<void> rejectFriendRequest({
    required String userId,
    required String friendId,
  });

  /// Block/unblock friend
  Future<void> blockFriend({
    required String userId,
    required String friendId,
  });

  /// Remove friend
  Future<void> removeFriend({
    required String userId,
    required String friendId,
  });

  /// Get user's friends list
  Future<List<Friend>> getFriends(String userId);

  /// Get pending friend requests for user
  Future<List<FriendRequest>> getFriendRequests(String userId);

  /// Check if two users are friends
  Future<bool> areFriends(String userId, String friendId);

  /// Get friends leaderboard
  Future<List<LeaderboardEntry>> getFriendsLeaderboard(String userId);
}
