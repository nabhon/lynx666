import 'enums.dart';

/// Lottery draw entity representing a single lottery draw
class LotteryDraw {
  final String id;
  final int drawNumber;
  final List<int>? winningNumbers;
  final DateTime scheduledTime;
  final DateTime? drawTime;
  final DrawStatus status;
  final String? previousDrawId;
  final String? nextDrawId;
  final int totalBetsCount;
  final double totalPrizePool;
  final DateTime createdAt;
  final DateTime? completedAt;

  const LotteryDraw({
    required this.id,
    required this.drawNumber,
    this.winningNumbers,
    required this.scheduledTime,
    this.drawTime,
    this.status = DrawStatus.pending,
    this.previousDrawId,
    this.nextDrawId,
    this.totalBetsCount = 0,
    this.totalPrizePool = 0.0,
    required this.createdAt,
    this.completedAt,
  });

  /// Check if draw is completed
  bool get isCompleted => status == DrawStatus.completed;

  /// Check if draw is pending
  bool get isPending => status == DrawStatus.pending;

  /// Check if draw is cancelled
  bool get isCancelled => status == DrawStatus.cancelled;

  /// Get duration until scheduled time
  Duration get timeUntilDraw => scheduledTime.difference(DateTime.now());

  /// Check if draw has started
  bool get hasStarted => DateTime.now().isAfter(scheduledTime);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LotteryDraw &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'LotteryDraw(drawNumber: $drawNumber, status: $status, scheduledTime: $scheduledTime)';
}
