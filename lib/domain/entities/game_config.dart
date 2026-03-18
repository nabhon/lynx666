/// Game configuration entity
class GameConfig {
  final String id;
  final String configKey;
  final Map<String, dynamic> configValue;
  final String? description;
  final DateTime updatedAt;

  const GameConfig({
    required this.id,
    required this.configKey,
    required this.configValue,
    this.description,
    required this.updatedAt,
  });

  /// Get draw interval in hours
  int get drawIntervalHours => configValue['hours'] as int? ?? 2;

  /// Get prize multipliers map
  Map<String, dynamic> get prizeMultipliers =>
      configValue['prize_multipliers'] as Map<String, dynamic>? ?? {};

  /// Get bet limits map
  Map<String, dynamic> get betLimits =>
      configValue['bet_limits'] as Map<String, dynamic>? ?? {};

  /// Get minimum bet amount
  double get minBetAmount =>
      (betLimits['min'] as num?)?.toDouble() ?? 1.0;

  /// Get maximum bet percentage of balance
  double get maxBetPercentage =>
      (betLimits['max_percentage'] as num?)?.toDouble() ?? 0.5;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameConfig &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'GameConfig(key: $configKey, value: $configValue)';
}
