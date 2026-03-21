import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/entities.dart';
import 'repository_providers.dart';

part 'lottery_providers.g.dart';

/// Latest completed lottery draw provider
@riverpod
class LatestLotteryDraw extends _$LatestLotteryDraw {
  @override
  Future<LotteryDraw?> build() async {
    final repository = ref.watch(lotteryRepositoryProvider);
    return await repository.getLatestCompletedDraw();
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Next lottery draw provider
@riverpod
class NextLotteryDraw extends _$NextLotteryDraw {
  @override
  Future<LotteryDraw?> build() async {
    final repository = ref.watch(lotteryRepositoryProvider);
    return await repository.getNextDraw();
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Get countdown duration to next draw
  Duration? get countdownDuration {
    final draw = state.value;
    if (draw == null) return null;
    return draw.scheduledTime.difference(DateTime.now());
  }

  /// Check if countdown has passed
  bool get hasDrawStarted {
    final draw = state.value;
    if (draw == null) return false;
    return DateTime.now().isAfter(draw.scheduledTime);
  }
}

/// Countdown timer provider - updates every second
@riverpod
class LotteryCountdown extends _$LotteryCountdown {
  @override
  Duration build() {
    final nextDraw = ref.watch(nextLotteryDrawProvider);
    final draw = nextDraw.value;
    if (draw == null) return Duration.zero;

    final duration = draw.scheduledTime.difference(DateTime.now());
    return duration.isNegative ? Duration.zero : duration;
  }

  /// Update countdown (call this every second from UI)
  void tick() {
    ref.invalidateSelf();
  }
}

/// Lottery draws list provider
@riverpod
class LotteryDrawsList extends _$LotteryDrawsList {
  @override
  Future<List<LotteryDraw>> build({
    int page = 1,
    int limit = 20,
    DrawStatus? status,
  }) async {
    final repository = ref.watch(lotteryRepositoryProvider);
    return await repository.getDraws(
      page: page,
      limit: limit,
      status: status,
    );
  }

  /// Load more draws (pagination)
  Future<void> loadMore() async {
    final currentDraws = state.value ?? [];
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(lotteryRepositoryProvider);
      final newDraws = await repository.getDraws(
        page: (currentDraws.length ~/ 20) + 2,
        limit: 20,
        status: status,
      );
      return [...currentDraws, ...newDraws];
    });
  }
}

/// Single lottery draw provider
@riverpod
class LotteryDrawById extends _$LotteryDrawById {
  @override
  Future<LotteryDraw?> build(String drawId) async {
    final repository = ref.watch(lotteryRepositoryProvider);
    return await repository.getDrawById(drawId);
  }

  /// Refresh data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
