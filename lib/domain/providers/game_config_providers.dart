import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/entities.dart';
import 'repository_providers.dart';

part 'game_config_providers.g.dart';

/// Game config by key provider
@riverpod
class GameConfigByKey extends _$GameConfigByKey {
  @override
  Future<GameConfig?> build(String key) async {
    final repository = ref.watch(gameConfigRepositoryProvider);
    return await repository.getConfigByKey(key);
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Draw interval provider
@riverpod
class DrawInterval extends _$DrawInterval {
  @override
  Future<int> build() async {
    final repository = ref.watch(gameConfigRepositoryProvider);
    return await repository.getDrawIntervalHours();
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Prize multipliers provider
@riverpod
class PrizeMultipliers extends _$PrizeMultipliers {
  @override
  Future<Map<String, dynamic>> build() async {
    final repository = ref.watch(gameConfigRepositoryProvider);
    return await repository.getPrizeMultipliers();
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Get multiplier for specific criteria
  double getMultiplier(String criteria) {
    final multipliers = state.value;
    if (multipliers == null) return 0.0;
    return (multipliers[criteria] as num?)?.toDouble() ?? 0.0;
  }
}

/// Minimum bet amount provider
@riverpod
class MinBetAmount extends _$MinBetAmount {
  @override
  Future<double> build() async {
    final repository = ref.watch(gameConfigRepositoryProvider);
    return await repository.getMinBetAmount();
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Maximum bet percentage provider
@riverpod
class MaxBetPercentage extends _$MaxBetPercentage {
  @override
  Future<double> build() async {
    final repository = ref.watch(gameConfigRepositoryProvider);
    return await repository.getMaxBetPercentage();
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Calculate potential win amount
@riverpod
class PotentialWinCalculator extends _$PotentialWinCalculator {
  @override
  double build() => 0.0;

  /// Calculate potential win for a bet amount and criteria
  Future<double> calculate({
    required double betAmount,
    required String criteria,
  }) async {
    final multipliers = await ref.read(prizeMultipliersProvider.future);
    final multiplier = (multipliers[criteria] as num?)?.toDouble() ?? 0.0;
    return betAmount * multiplier;
  }

  /// Calculate max potential win (MATCH_6)
  Future<double> calculateMaxWin(double betAmount) async {
    return calculate(betAmount: betAmount, criteria: 'MATCH_6');
  }
}
