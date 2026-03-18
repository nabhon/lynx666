import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/entities.dart';
import 'repository_providers.dart';
import 'auth_providers.dart';

part 'friend_providers.g.dart';

/// User's friends list provider
@riverpod
class FriendsList extends _$FriendsList {
  @override
  Future<List<Friend>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return [];

    final repository = ref.watch(friendRepositoryProvider);
    return await repository.getFriends(userId);
  }

  /// Refresh friends list
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Friend requests provider
@riverpod
class FriendRequests extends _$FriendRequests {
  @override
  Future<List<FriendRequest>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return [];

    final repository = ref.watch(friendRepositoryProvider);
    return await repository.getFriendRequests(userId);
  }

  /// Refresh friend requests
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Friends leaderboard provider
@riverpod
class FriendsLeaderboard extends _$FriendsLeaderboard {
  @override
  Future<List<LeaderboardEntry>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return [];

    final repository = ref.watch(friendRepositoryProvider);
    return await repository.getFriendsLeaderboard(userId);
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Check if two users are friends
@riverpod
class AreFriends extends _$AreFriends {
  @override
  Future<bool> build(String friendId) async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return false;

    final repository = ref.watch(friendRepositoryProvider);
    return await repository.areFriends(userId, friendId);
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Friend actions provider
@riverpod
class FriendActions extends _$FriendActions {
  @override
  bool build() => false;

  /// Send friend request
  Future<void> sendFriendRequest(String friendId) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('Not authenticated');

    await AsyncValue.guard(() async {
      final repository = ref.read(friendRepositoryProvider);
      await repository.sendFriendRequest(userId: userId, friendId: friendId);
    });

    ref.invalidate(friendRequestsProvider);
    ref.invalidate(areFriendsProvider(friendId));
  }

  /// Accept friend request
  Future<void> acceptFriendRequest(String friendId) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('Not authenticated');

    await AsyncValue.guard(() async {
      final repository = ref.read(friendRepositoryProvider);
      await repository.acceptFriendRequest(userId: userId, friendId: friendId);
    });

    ref.invalidate(friendRequestsProvider);
    ref.invalidate(friendsListProvider);
    ref.invalidate(areFriendsProvider(friendId));
  }

  /// Reject friend request
  Future<void> rejectFriendRequest(String friendId) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('Not authenticated');

    await AsyncValue.guard(() async {
      final repository = ref.read(friendRepositoryProvider);
      await repository.rejectFriendRequest(userId: userId, friendId: friendId);
    });

    ref.invalidate(friendRequestsProvider);
  }

  /// Remove friend
  Future<void> removeFriend(String friendId) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('Not authenticated');

    await AsyncValue.guard(() async {
      final repository = ref.read(friendRepositoryProvider);
      await repository.removeFriend(userId: userId, friendId: friendId);
    });

    ref.invalidate(friendsListProvider);
    ref.invalidate(areFriendsProvider(friendId));
  }

  /// Block friend
  Future<void> blockFriend(String friendId) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('Not authenticated');

    await AsyncValue.guard(() async {
      final repository = ref.read(friendRepositoryProvider);
      await repository.blockFriend(userId: userId, friendId: friendId);
    });

    ref.invalidate(friendsListProvider);
    ref.invalidate(friendRequestsProvider);
  }
}
