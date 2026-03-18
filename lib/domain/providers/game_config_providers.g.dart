// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_config_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameConfigByKeyHash() => r'f7994bf6e2de6ed510e2bffcb9f50dd709f67d5d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$GameConfigByKey
    extends BuildlessAutoDisposeAsyncNotifier<GameConfig?> {
  late final String key;

  FutureOr<GameConfig?> build(
    String key,
  );
}

/// Game config by key provider
///
/// Copied from [GameConfigByKey].
@ProviderFor(GameConfigByKey)
const gameConfigByKeyProvider = GameConfigByKeyFamily();

/// Game config by key provider
///
/// Copied from [GameConfigByKey].
class GameConfigByKeyFamily extends Family<AsyncValue<GameConfig?>> {
  /// Game config by key provider
  ///
  /// Copied from [GameConfigByKey].
  const GameConfigByKeyFamily();

  /// Game config by key provider
  ///
  /// Copied from [GameConfigByKey].
  GameConfigByKeyProvider call(
    String key,
  ) {
    return GameConfigByKeyProvider(
      key,
    );
  }

  @override
  GameConfigByKeyProvider getProviderOverride(
    covariant GameConfigByKeyProvider provider,
  ) {
    return call(
      provider.key,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'gameConfigByKeyProvider';
}

/// Game config by key provider
///
/// Copied from [GameConfigByKey].
class GameConfigByKeyProvider
    extends AutoDisposeAsyncNotifierProviderImpl<GameConfigByKey, GameConfig?> {
  /// Game config by key provider
  ///
  /// Copied from [GameConfigByKey].
  GameConfigByKeyProvider(
    String key,
  ) : this._internal(
          () => GameConfigByKey()..key = key,
          from: gameConfigByKeyProvider,
          name: r'gameConfigByKeyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$gameConfigByKeyHash,
          dependencies: GameConfigByKeyFamily._dependencies,
          allTransitiveDependencies:
              GameConfigByKeyFamily._allTransitiveDependencies,
          key: key,
        );

  GameConfigByKeyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final String key;

  @override
  FutureOr<GameConfig?> runNotifierBuild(
    covariant GameConfigByKey notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(GameConfigByKey Function() create) {
    return ProviderOverride(
      origin: this,
      override: GameConfigByKeyProvider._internal(
        () => create()..key = key,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GameConfigByKey, GameConfig?>
      createElement() {
    return _GameConfigByKeyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GameConfigByKeyProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GameConfigByKeyRef on AutoDisposeAsyncNotifierProviderRef<GameConfig?> {
  /// The parameter `key` of this provider.
  String get key;
}

class _GameConfigByKeyProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<GameConfigByKey,
        GameConfig?> with GameConfigByKeyRef {
  _GameConfigByKeyProviderElement(super.provider);

  @override
  String get key => (origin as GameConfigByKeyProvider).key;
}

String _$drawIntervalHash() => r'21191886560f413dad579ee950a59f3a366398c6';

/// Draw interval provider
///
/// Copied from [DrawInterval].
@ProviderFor(DrawInterval)
final drawIntervalProvider =
    AutoDisposeAsyncNotifierProvider<DrawInterval, int>.internal(
  DrawInterval.new,
  name: r'drawIntervalProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$drawIntervalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DrawInterval = AutoDisposeAsyncNotifier<int>;
String _$prizeMultipliersHash() => r'a85557f894b7e1fcc1651f5aea6969b8dad7badb';

/// Prize multipliers provider
///
/// Copied from [PrizeMultipliers].
@ProviderFor(PrizeMultipliers)
final prizeMultipliersProvider = AutoDisposeAsyncNotifierProvider<
    PrizeMultipliers, Map<String, dynamic>>.internal(
  PrizeMultipliers.new,
  name: r'prizeMultipliersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$prizeMultipliersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PrizeMultipliers = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
String _$minBetAmountHash() => r'6d7fbdcc82b0f864a871b4100f552552abe972d8';

/// Minimum bet amount provider
///
/// Copied from [MinBetAmount].
@ProviderFor(MinBetAmount)
final minBetAmountProvider =
    AutoDisposeAsyncNotifierProvider<MinBetAmount, double>.internal(
  MinBetAmount.new,
  name: r'minBetAmountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$minBetAmountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MinBetAmount = AutoDisposeAsyncNotifier<double>;
String _$maxBetPercentageHash() => r'bb089d95e8b7d7359635fbd2953c05508c795aaf';

/// Maximum bet percentage provider
///
/// Copied from [MaxBetPercentage].
@ProviderFor(MaxBetPercentage)
final maxBetPercentageProvider =
    AutoDisposeAsyncNotifierProvider<MaxBetPercentage, double>.internal(
  MaxBetPercentage.new,
  name: r'maxBetPercentageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$maxBetPercentageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MaxBetPercentage = AutoDisposeAsyncNotifier<double>;
String _$potentialWinCalculatorHash() =>
    r'3e758a38560aaade8101c3715dee19b46226f909';

/// Calculate potential win amount
///
/// Copied from [PotentialWinCalculator].
@ProviderFor(PotentialWinCalculator)
final potentialWinCalculatorProvider =
    AutoDisposeNotifierProvider<PotentialWinCalculator, double>.internal(
  PotentialWinCalculator.new,
  name: r'potentialWinCalculatorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$potentialWinCalculatorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PotentialWinCalculator = AutoDisposeNotifier<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
