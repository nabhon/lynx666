import '../../domain/entities/prize_distribution.dart';
import '../../domain/entities/enums.dart';
import 'enum_extensions.dart';

/// Data model for PrizeDistribution entity
class PrizeDistributionModel extends PrizeDistribution {
  const PrizeDistributionModel({
    required super.id,
    required super.lotteryDrawId,
    required super.betId,
    required super.userId,
    required super.winCriteria,
    required super.matchedNumbers,
    required super.prizeAmount,
    required super.createdAt,
  });

  /// Create a PrizeDistributionModel from a JSON map (Supabase response)
  factory PrizeDistributionModel.fromJson(Map<String, dynamic> json) {
    return PrizeDistributionModel(
      id: json['id'] as String,
      lotteryDrawId: json['lottery_draw_id'] as String,
      betId: json['bet_id'] as String,
      userId: json['user_id'] as String,
      winCriteria: WinCriteriaX.fromValue(json['win_criteria'] as String),
      matchedNumbers: _parseNumberList(json['matched_numbers']),
      prizeAmount: _parseDouble(json['prize_amount']),
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  /// Convert PrizeDistributionModel to JSON map for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lottery_draw_id': lotteryDrawId,
      'bet_id': betId,
      'user_id': userId,
      'win_criteria': winCriteria.value,
      'matched_numbers': matchedNumbers,
      'prize_amount': prizeAmount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create a PrizeDistributionModel from a Supabase map
  factory PrizeDistributionModel.fromSupabase(Map<String, dynamic> data) {
    return PrizeDistributionModel.fromJson(data);
  }

  /// Convert PrizeDistributionModel to Supabase insert/update map
  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'lottery_draw_id': lotteryDrawId,
      'bet_id': betId,
      'user_id': userId,
      'win_criteria': winCriteria.value,
      'matched_numbers': matchedNumbers,
      'prize_amount': prizeAmount,
    };
  }

  /// Create a copy of this PrizeDistributionModel with updated fields
  PrizeDistributionModel copyWith({
    String? id,
    String? lotteryDrawId,
    String? betId,
    String? userId,
    WinCriteria? winCriteria,
    List<int>? matchedNumbers,
    double? prizeAmount,
    DateTime? createdAt,
  }) {
    return PrizeDistributionModel(
      id: id ?? this.id,
      lotteryDrawId: lotteryDrawId ?? this.lotteryDrawId,
      betId: betId ?? this.betId,
      userId: userId ?? this.userId,
      winCriteria: winCriteria ?? this.winCriteria,
      matchedNumbers: matchedNumbers ?? this.matchedNumbers,
      prizeAmount: prizeAmount ?? this.prizeAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert domain entity to model
  factory PrizeDistributionModel.fromEntity(PrizeDistribution entity) {
    return PrizeDistributionModel(
      id: entity.id,
      lotteryDrawId: entity.lotteryDrawId,
      betId: entity.betId,
      userId: entity.userId,
      winCriteria: entity.winCriteria,
      matchedNumbers: entity.matchedNumbers,
      prizeAmount: entity.prizeAmount,
      createdAt: entity.createdAt,
    );
  }

  /// Convert model to domain entity
  PrizeDistribution toEntity() {
    return PrizeDistribution(
      id: id,
      lotteryDrawId: lotteryDrawId,
      betId: betId,
      userId: userId,
      winCriteria: winCriteria,
      matchedNumbers: matchedNumbers,
      prizeAmount: prizeAmount,
      createdAt: createdAt,
    );
  }

  /// Helper: Parse list of integers from JSON array
  static List<int> _parseNumberList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => (e as num).toInt()).toList();
    }
    return [];
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
      'PrizeDistributionModel(id: $id, userId: $userId, prize: $prizeAmount)';
}
