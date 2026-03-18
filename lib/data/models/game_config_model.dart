import '../../domain/entities/game_config.dart';

/// Data model for GameConfig entity
class GameConfigModel extends GameConfig {
  const GameConfigModel({
    required super.id,
    required super.configKey,
    required super.configValue,
    super.description,
    required super.updatedAt,
  });

  /// Create a GameConfigModel from a JSON map (Supabase response)
  factory GameConfigModel.fromJson(Map<String, dynamic> json) {
    return GameConfigModel(
      id: json['id'] as String,
      configKey: json['config_key'] as String,
      configValue: _parseConfigValue(json['config_value']),
      description: json['description'] as String?,
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  /// Convert GameConfigModel to JSON map for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'config_key': configKey,
      'config_value': configValue,
      'description': description,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a GameConfigModel from a Supabase map
  factory GameConfigModel.fromSupabase(Map<String, dynamic> data) {
    return GameConfigModel.fromJson(data);
  }

  /// Convert GameConfigModel to Supabase insert/update map
  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'config_key': configKey,
      'config_value': configValue,
      'description': description,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of this GameConfigModel with updated fields
  GameConfigModel copyWith({
    String? id,
    String? configKey,
    Map<String, dynamic>? configValue,
    String? description,
    DateTime? updatedAt,
  }) {
    return GameConfigModel(
      id: id ?? this.id,
      configKey: configKey ?? this.configKey,
      configValue: configValue ?? this.configValue,
      description: description ?? this.description,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert domain entity to model
  factory GameConfigModel.fromEntity(GameConfig entity) {
    return GameConfigModel(
      id: entity.id,
      configKey: entity.configKey,
      configValue: entity.configValue,
      description: entity.description,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert model to domain entity
  GameConfig toEntity() {
    return GameConfig(
      id: id,
      configKey: configKey,
      configValue: configValue,
      description: description,
      updatedAt: updatedAt,
    );
  }

  /// Helper: Parse config value (JSONB) from various formats
  static Map<String, dynamic> _parseConfigValue(dynamic value) {
    if (value == null) return {};
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return {};
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

  @override
  String toString() => 'GameConfigModel(key: $configKey)';
}
