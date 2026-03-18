import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/entities.dart';
import 'repository_providers.dart';
import 'auth_providers.dart';

part 'user_providers.g.dart';

/// Leaderboard provider
@riverpod
class Leaderboard extends _$Leaderboard {
  @override
  Future<List<LeaderboardEntry>> build({
    int page = 1,
    int limit = 50,
  }) async {
    final repository = ref.watch(userRepositoryProvider);
    return await repository.getLeaderboard(
      page: page,
      limit: limit,
    );
  }

  /// Refresh leaderboard
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Load more entries (pagination)
  Future<void> loadMore() async {
    final currentEntries = state.value ?? [];
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(userRepositoryProvider);
      final newEntries = await repository.getLeaderboard(
        page: (currentEntries.length ~/ 50) + 2,
        limit: 50,
      );
      return [...currentEntries, ...newEntries];
    });
  }
}

/// Top users provider (limited)
@riverpod
class TopUsers extends _$TopUsers {
  @override
  Future<List<LeaderboardEntry>> build({int limit = 10}) async {
    final repository = ref.watch(userRepositoryProvider);
    return await repository.getTopUsers(limit);
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// User stats provider
@riverpod
class UserStatsProvider extends _$UserStatsProvider {
  @override
  Future<UserStats?> build(String userId) async {
    final repository = ref.watch(userRepositoryProvider);
    return await repository.getUserStats(userId);
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Current user's stats provider
final currentUserStatsProvider = Provider.family<UserStats?, String>((ref, userId) {
  return ref.watch(userStatsProviderProvider(userId)).value;
});

/// User by ID provider
@riverpod
class UserById extends _$UserById {
  @override
  Future<Profile?> build(String userId) async {
    final repository = ref.watch(userRepositoryProvider);
    return await repository.getUserById(userId);
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Search users provider
@riverpod
class SearchUsers extends _$SearchUsers {
  @override
  Future<List<Profile>> build(String query) async {
    if (query.isEmpty) return [];

    final repository = ref.watch(userRepositoryProvider);
    return await repository.searchUsers(query, limit: 20);
  }

  /// Search for users
  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (query.isEmpty) return [];
      final repository = ref.read(userRepositoryProvider);
      return await repository.searchUsers(query, limit: 20);
    });
  }

  /// Clear search results
  void clear() {
    state = const AsyncValue.data([]);
  }
}
