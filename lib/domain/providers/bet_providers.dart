import 'dart:developer' as dev;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/entities.dart';
import 'repository_providers.dart';
import 'auth_providers.dart';
import 'profile_providers.dart';

part 'bet_providers.g.dart';

/// User's bet history provider
@riverpod
class UserBetHistory extends _$UserBetHistory {
  @override
  Future<List<Bet>> build({BetStatus? filter}) async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return [];

    final repository = ref.watch(betRepositoryProvider);
    return await repository.getUserBets(
      userId: userId,
      status: filter,
      limit: 50,
    );
  }

  /// Refresh bet history
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Load more bets (pagination)
  Future<void> loadMore() async {
    final currentBets = state.value ?? [];
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final userId = ref.read(currentUserIdProvider);
      if (userId == null) return currentBets;

      final repository = ref.read(betRepositoryProvider);
      final newBets = await repository.getUserBets(
        userId: userId,
        status: filter,
        page: (currentBets.length ~/ 50) + 2,
        limit: 50,
      );
      return [...currentBets, ...newBets];
    });
  }
}

/// User's pending bets provider
@riverpod
class UserPendingBets extends _$UserPendingBets {
  @override
  Future<List<Bet>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return [];

    final repository = ref.watch(betRepositoryProvider);
    return await repository.getUserPendingBets(userId);
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// User's won bets provider
@riverpod
class UserWonBets extends _$UserWonBets {
  @override
  Future<List<Bet>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return [];

    final repository = ref.watch(betRepositoryProvider);
    return await repository.getUserWonBets(userId);
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Single bet provider
@riverpod
class BetById extends _$BetById {
  @override
  Future<Bet?> build(String betId) async {
    final repository = ref.watch(betRepositoryProvider);
    return await repository.getBetById(betId);
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Place bet provider - handles placing a new bet
@riverpod
class PlaceBet extends _$PlaceBet {
  @override
  Future<Bet?> build() => Future.value(null);

  /// Place a new bet
  Future<Bet?> placeBet({
    required String lotteryDrawId,
    required List<int> selectedNumbers,
    required double betAmount,
  }) async {
    // Track disposal BEFORE any async gap
    var isDisposed = false;
    ref.onDispose(() => isDisposed = true);

    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('Not authenticated');

    // Capture repository before async gap
    final repository = ref.read(betRepositoryProvider);

    state = const AsyncValue.loading();

    dev.log('[PlaceBet] calling repository.placeBet...');
    dev.log('[PlaceBet] userId=$userId, drawId=$lotteryDrawId, amount=$betAmount');

    final result = await AsyncValue.guard(() async {
      return await repository.placeBet(
        userId: userId,
        lotteryDrawId: lotteryDrawId,
        selectedNumbers: selectedNumbers,
        betAmount: betAmount,
      );
    });

    dev.log('[PlaceBet] result hasValue=${result.hasValue}, hasError=${result.hasError}');
    if (result.hasError) {
      dev.log('[PlaceBet] ERROR: ${result.error}');
    }
    dev.log('[PlaceBet] isDisposed=$isDisposed');

    // Provider was disposed during await — don't touch ref/state
    if (isDisposed) {
      dev.log('[PlaceBet] SKIPPED state/invalidate — provider disposed');
      return result.value;
    }

    state = AsyncValue.data(result.value);

    // Invalidate related providers
    ref.invalidate(userBetHistoryProvider);
    ref.invalidate(userPendingBetsProvider);
    ref.invalidate(profileBalanceProvider);
    dev.log('[PlaceBet] DONE — invalidated related providers');

    return result.value;
  }

  /// Reset state
  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// Bet statistics provider
@riverpod
class BetStats extends _$BetStats {
  @override
  Future<Map<String, dynamic>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) {
      return {
        'totalBets': 0,
        'wonBets': 0,
        'lostBets': 0,
        'totalSpent': 0.0,
        'totalWon': 0.0,
        'netProfit': 0.0,
      };
    }

    final repository = ref.watch(betRepositoryProvider);
    final bets = await repository.getUserBets(userId: userId, limit: 1000);

    final totalBets = bets.length;
    final wonBets = bets.where((b) => b.isWon).length;
    final lostBets = bets.where((b) => b.isLost).length;
    final totalSpent = bets.fold<double>(0, (sum, b) => sum + b.betAmount);
    final totalWon = bets.fold<double>(
      0,
      (sum, b) => sum + (b.actualWinAmount ?? 0.0),
    );

    return {
      'totalBets': totalBets,
      'wonBets': wonBets,
      'lostBets': lostBets,
      'totalSpent': totalSpent,
      'totalWon': totalWon,
      'netProfit': totalWon - totalSpent,
      'winRate': totalBets > 0 ? (wonBets / totalBets) * 100 : 0.0,
    };
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
