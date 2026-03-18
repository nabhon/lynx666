import '../../domain/entities/entities.dart';

/// Game configuration repository interface
abstract class IGameConfigRepository {
  /// Get game config by key
  Future<GameConfig?> getConfigByKey(String key);

  /// Get draw interval config
  Future<int> getDrawIntervalHours();

  /// Get prize multipliers
  Future<Map<String, dynamic>> getPrizeMultipliers();

  /// Get bet limits
  Future<Map<String, dynamic>> getBetLimits();

  /// Get minimum bet amount
  Future<double> getMinBetAmount();

  /// Get maximum bet percentage of balance
  Future<double> getMaxBetPercentage();

  /// Get all game configs
  Future<List<GameConfig>> getAllConfigs();
}
