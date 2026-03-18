import '../../domain/entities/entities.dart';

/// User repository interface (for user-related queries like leaderboard)
abstract class IUserRepository {
  /// Get leaderboard entries
  Future<List<LeaderboardEntry>> getLeaderboard({
    int page = 1,
    int limit = 50,
  });

  /// Get user statistics
  Future<UserStats?> getUserStats(String userId);

  /// Get user by ID
  Future<Profile?> getUserById(String userId);

  /// Get users by IDs (batch)
  Future<List<Profile>> getUsersByIds(List<String> userIds);

  /// Search users by username
  Future<List<Profile>> searchUsers(String query, {int limit = 20});

  /// Get top N users by balance
  Future<List<LeaderboardEntry>> getTopUsers(int limit);
}
