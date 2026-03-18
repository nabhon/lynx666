import '../../domain/entities/lottery_draw.dart';
import '../../domain/entities/enums.dart';
import 'enum_extensions.dart';

/// Data model for LotteryDraw entity
class LotteryDrawModel extends LotteryDraw {
  const LotteryDrawModel({
    required super.id,
    required super.drawNumber,
    super.winningNumbers,
    required super.scheduledTime,
    super.drawTime,
    super.status,
    super.previousDrawId,
    super.nextDrawId,
    super.totalBetsCount,
    super.totalPrizePool,
    required super.createdAt,
    super.completedAt,
  });

  /// Create a LotteryDrawModel from a JSON map (Supabase response)
  factory LotteryDrawModel.fromJson(Map<String, dynamic> json) {
    return LotteryDrawModel(
      id: json['id'] as String,
      drawNumber: json['draw_number'] as int,
      winningNumbers: _parseNumberList(json['winning_numbers']),
      scheduledTime: _parseDateTime(json['scheduled_time']),
      drawTime: _parseNullableDateTime(json['draw_time']),
      status: json['status'] != null
          ? DrawStatusX.fromValue(json['status'] as String)
          : DrawStatus.pending,
      previousDrawId: json['previous_draw_id'] as String?,
      nextDrawId: json['next_draw_id'] as String?,
      totalBetsCount: json['total_bets_count'] as int? ?? 0,
      totalPrizePool: _parseDouble(json['total_prize_pool']),
      createdAt: _parseDateTime(json['created_at']),
      completedAt: _parseNullableDateTime(json['completed_at']),
    );
  }

  /// Convert LotteryDrawModel to JSON map for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'draw_number': drawNumber,
      'winning_numbers': winningNumbers,
      'scheduled_time': scheduledTime.toIso8601String(),
      'draw_time': drawTime?.toIso8601String(),
      'status': status.value,
      'previous_draw_id': previousDrawId,
      'next_draw_id': nextDrawId,
      'total_bets_count': totalBetsCount,
      'total_prize_pool': totalPrizePool,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  /// Create a LotteryDrawModel from a Supabase map
  factory LotteryDrawModel.fromSupabase(Map<String, dynamic> data) {
    return LotteryDrawModel.fromJson(data);
  }

  /// Convert LotteryDrawModel to Supabase insert/update map
  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'draw_number': drawNumber,
      'winning_numbers': winningNumbers,
      'scheduled_time': scheduledTime.toIso8601String(),
      'draw_time': drawTime?.toIso8601String(),
      'status': status.value,
      'previous_draw_id': previousDrawId,
      'next_draw_id': nextDrawId,
      'total_bets_count': totalBetsCount,
      'total_prize_pool': totalPrizePool,
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
    };
  }

  /// Create a copy of this LotteryDrawModel with updated fields
  LotteryDrawModel copyWith({
    String? id,
    int? drawNumber,
    List<int>? winningNumbers,
    DateTime? scheduledTime,
    DateTime? drawTime,
    DrawStatus? status,
    String? previousDrawId,
    String? nextDrawId,
    int? totalBetsCount,
    double? totalPrizePool,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return LotteryDrawModel(
      id: id ?? this.id,
      drawNumber: drawNumber ?? this.drawNumber,
      winningNumbers: winningNumbers ?? this.winningNumbers,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      drawTime: drawTime ?? this.drawTime,
      status: status ?? this.status,
      previousDrawId: previousDrawId ?? this.previousDrawId,
      nextDrawId: nextDrawId ?? this.nextDrawId,
      totalBetsCount: totalBetsCount ?? this.totalBetsCount,
      totalPrizePool: totalPrizePool ?? this.totalPrizePool,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Convert domain entity to model
  factory LotteryDrawModel.fromEntity(LotteryDraw entity) {
    return LotteryDrawModel(
      id: entity.id,
      drawNumber: entity.drawNumber,
      winningNumbers: entity.winningNumbers,
      scheduledTime: entity.scheduledTime,
      drawTime: entity.drawTime,
      status: entity.status,
      previousDrawId: entity.previousDrawId,
      nextDrawId: entity.nextDrawId,
      totalBetsCount: entity.totalBetsCount,
      totalPrizePool: entity.totalPrizePool,
      createdAt: entity.createdAt,
      completedAt: entity.completedAt,
    );
  }

  /// Convert model to domain entity
  LotteryDraw toEntity() {
    return LotteryDraw(
      id: id,
      drawNumber: drawNumber,
      winningNumbers: winningNumbers,
      scheduledTime: scheduledTime,
      drawTime: drawTime,
      status: status,
      previousDrawId: previousDrawId,
      nextDrawId: nextDrawId,
      totalBetsCount: totalBetsCount,
      totalPrizePool: totalPrizePool,
      createdAt: createdAt,
      completedAt: completedAt,
    );
  }

  /// Helper: Parse list of integers from JSON array
  static List<int>? _parseNumberList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((e) => (e as num).toInt()).toList();
    }
    return null;
  }

  /// Helper: Parse DateTime from various formats
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) {
      throw FormatException('DateTime value cannot be null');
    }
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.parse(value);
    }
    throw FormatException('Invalid DateTime format: $value');
  }

  /// Helper: Parse nullable DateTime
  static DateTime? _parseNullableDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  /// Helper: Parse double value
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  String toString() =>
      'LotteryDrawModel(drawNumber: $drawNumber, status: $status)';
}
