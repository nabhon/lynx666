import '../../domain/entities/bet.dart';
import '../../domain/entities/enums.dart';
import 'enum_extensions.dart';

/// Data model for Bet entity
class BetModel extends Bet {
  const BetModel({
    required super.id,
    required super.userId,
    required super.lotteryDrawId,
    required super.selectedNumbers,
    required super.betAmount,
    super.status,
    super.potentialWinAmount,
    super.actualWinAmount,
    super.winCriteria,
    required super.createdAt,
    super.settledAt,
  });

  /// Create a BetModel from a JSON map (Supabase response)
  factory BetModel.fromJson(Map<String, dynamic> json) {
    return BetModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      lotteryDrawId: json['lottery_draw_id'] as String,
      selectedNumbers: _parseNumberList(json['selected_numbers']),
      betAmount: _parseDouble(json['bet_amount']),
      status: json['status'] != null
          ? BetStatusX.fromValue(json['status'] as String)
          : BetStatus.pending,
      potentialWinAmount: _parseNullableDouble(json['potential_win_amount']),
      actualWinAmount: _parseNullableDouble(json['actual_win_amount']),
      winCriteria: json['win_criteria'] != null
          ? WinCriteriaX.fromValue(json['win_criteria'] as String)
          : null,
      createdAt: _parseDateTime(json['created_at']),
      settledAt: _parseNullableDateTime(json['settled_at']),
    );
  }

  /// Convert BetModel to JSON map for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'lottery_draw_id': lotteryDrawId,
      'selected_numbers': selectedNumbers,
      'bet_amount': betAmount,
      'status': status.value,
      'potential_win_amount': potentialWinAmount,
      'actual_win_amount': actualWinAmount,
      'win_criteria': winCriteria?.value,
      'created_at': createdAt.toIso8601String(),
      'settled_at': settledAt?.toIso8601String(),
    };
  }

  /// Create a BetModel from a Supabase map
  factory BetModel.fromSupabase(Map<String, dynamic> data) {
    return BetModel.fromJson(data);
  }

  /// Convert BetModel to Supabase insert/update map
  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'user_id': userId,
      'lottery_draw_id': lotteryDrawId,
      'selected_numbers': selectedNumbers,
      'bet_amount': betAmount,
      'status': status.value,
      'potential_win_amount': potentialWinAmount,
      'actual_win_amount': actualWinAmount,
      'win_criteria': winCriteria?.value,
      if (settledAt != null) 'settled_at': settledAt!.toIso8601String(),
    };
  }

  /// Create a copy of this BetModel with updated fields
  BetModel copyWith({
    String? id,
    String? userId,
    String? lotteryDrawId,
    List<int>? selectedNumbers,
    double? betAmount,
    BetStatus? status,
    double? potentialWinAmount,
    double? actualWinAmount,
    WinCriteria? winCriteria,
    DateTime? createdAt,
    DateTime? settledAt,
  }) {
    return BetModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      lotteryDrawId: lotteryDrawId ?? this.lotteryDrawId,
      selectedNumbers: selectedNumbers ?? this.selectedNumbers,
      betAmount: betAmount ?? this.betAmount,
      status: status ?? this.status,
      potentialWinAmount: potentialWinAmount ?? this.potentialWinAmount,
      actualWinAmount: actualWinAmount ?? this.actualWinAmount,
      winCriteria: winCriteria ?? this.winCriteria,
      createdAt: createdAt ?? this.createdAt,
      settledAt: settledAt ?? this.settledAt,
    );
  }

  /// Convert domain entity to model
  factory BetModel.fromEntity(Bet entity) {
    return BetModel(
      id: entity.id,
      userId: entity.userId,
      lotteryDrawId: entity.lotteryDrawId,
      selectedNumbers: entity.selectedNumbers,
      betAmount: entity.betAmount,
      status: entity.status,
      potentialWinAmount: entity.potentialWinAmount,
      actualWinAmount: entity.actualWinAmount,
      winCriteria: entity.winCriteria,
      createdAt: entity.createdAt,
      settledAt: entity.settledAt,
    );
  }

  /// Convert model to domain entity
  Bet toEntity() {
    return Bet(
      id: id,
      userId: userId,
      lotteryDrawId: lotteryDrawId,
      selectedNumbers: selectedNumbers,
      betAmount: betAmount,
      status: status,
      potentialWinAmount: potentialWinAmount,
      actualWinAmount: actualWinAmount,
      winCriteria: winCriteria,
      createdAt: createdAt,
      settledAt: settledAt,
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

  /// Helper: Parse nullable double value
  static double? _parseNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  @override
  String toString() => 'BetModel(id: $id, status: $status, amount: $betAmount)';
}
