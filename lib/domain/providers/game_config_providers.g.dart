// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_config_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Game config by key provider

@ProviderFor(GameConfigByKey)
final gameConfigByKeyProvider = GameConfigByKeyFamily._();

/// Game config by key provider
final class GameConfigByKeyProvider
    extends $AsyncNotifierProvider<GameConfigByKey, GameConfig?> {
  /// Game config by key provider
  GameConfigByKeyProvider._({
    required GameConfigByKeyFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'gameConfigByKeyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameConfigByKeyHash();

  @override
  String toString() {
    return r'gameConfigByKeyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GameConfigByKey create() => GameConfigByKey();

  @override
  bool operator ==(Object other) {
    return other is GameConfigByKeyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameConfigByKeyHash() => r'f7994bf6e2de6ed510e2bffcb9f50dd709f67d5d';

/// Game config by key provider

final class GameConfigByKeyFamily extends $Family
    with
        $ClassFamilyOverride<
          GameConfigByKey,
          AsyncValue<GameConfig?>,
          GameConfig?,
          FutureOr<GameConfig?>,
          String
        > {
  GameConfigByKeyFamily._()
    : super(
        retry: null,
        name: r'gameConfigByKeyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Game config by key provider

  GameConfigByKeyProvider call(String key) =>
      GameConfigByKeyProvider._(argument: key, from: this);

  @override
  String toString() => r'gameConfigByKeyProvider';
}

/// Game config by key provider

abstract class _$GameConfigByKey extends $AsyncNotifier<GameConfig?> {
  late final _$args = ref.$arg as String;
  String get key => _$args;

  FutureOr<GameConfig?> build(String key);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<GameConfig?>, GameConfig?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<GameConfig?>, GameConfig?>,
              AsyncValue<GameConfig?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// Draw interval provider

@ProviderFor(DrawInterval)
final drawIntervalProvider = DrawIntervalProvider._();

/// Draw interval provider
final class DrawIntervalProvider
    extends $AsyncNotifierProvider<DrawInterval, int> {
  /// Draw interval provider
  DrawIntervalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'drawIntervalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$drawIntervalHash();

  @$internal
  @override
  DrawInterval create() => DrawInterval();
}

String _$drawIntervalHash() => r'21191886560f413dad579ee950a59f3a366398c6';

/// Draw interval provider

abstract class _$DrawInterval extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Prize multipliers provider

@ProviderFor(PrizeMultipliers)
final prizeMultipliersProvider = PrizeMultipliersProvider._();

/// Prize multipliers provider
final class PrizeMultipliersProvider
    extends $AsyncNotifierProvider<PrizeMultipliers, Map<String, dynamic>> {
  /// Prize multipliers provider
  PrizeMultipliersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prizeMultipliersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prizeMultipliersHash();

  @$internal
  @override
  PrizeMultipliers create() => PrizeMultipliers();
}

String _$prizeMultipliersHash() => r'a85557f894b7e1fcc1651f5aea6969b8dad7badb';

/// Prize multipliers provider

abstract class _$PrizeMultipliers extends $AsyncNotifier<Map<String, dynamic>> {
  FutureOr<Map<String, dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<String, dynamic>>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, dynamic>>,
                Map<String, dynamic>
              >,
              AsyncValue<Map<String, dynamic>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Minimum bet amount provider

@ProviderFor(MinBetAmount)
final minBetAmountProvider = MinBetAmountProvider._();

/// Minimum bet amount provider
final class MinBetAmountProvider
    extends $AsyncNotifierProvider<MinBetAmount, double> {
  /// Minimum bet amount provider
  MinBetAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'minBetAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$minBetAmountHash();

  @$internal
  @override
  MinBetAmount create() => MinBetAmount();
}

String _$minBetAmountHash() => r'6d7fbdcc82b0f864a871b4100f552552abe972d8';

/// Minimum bet amount provider

abstract class _$MinBetAmount extends $AsyncNotifier<double> {
  FutureOr<double> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<double>, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<double>, double>,
              AsyncValue<double>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Maximum bet percentage provider

@ProviderFor(MaxBetPercentage)
final maxBetPercentageProvider = MaxBetPercentageProvider._();

/// Maximum bet percentage provider
final class MaxBetPercentageProvider
    extends $AsyncNotifierProvider<MaxBetPercentage, double> {
  /// Maximum bet percentage provider
  MaxBetPercentageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maxBetPercentageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maxBetPercentageHash();

  @$internal
  @override
  MaxBetPercentage create() => MaxBetPercentage();
}

String _$maxBetPercentageHash() => r'bb089d95e8b7d7359635fbd2953c05508c795aaf';

/// Maximum bet percentage provider

abstract class _$MaxBetPercentage extends $AsyncNotifier<double> {
  FutureOr<double> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<double>, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<double>, double>,
              AsyncValue<double>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Calculate potential win amount

@ProviderFor(PotentialWinCalculator)
final potentialWinCalculatorProvider = PotentialWinCalculatorProvider._();

/// Calculate potential win amount
final class PotentialWinCalculatorProvider
    extends $NotifierProvider<PotentialWinCalculator, double> {
  /// Calculate potential win amount
  PotentialWinCalculatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'potentialWinCalculatorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$potentialWinCalculatorHash();

  @$internal
  @override
  PotentialWinCalculator create() => PotentialWinCalculator();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$potentialWinCalculatorHash() =>
    r'3e758a38560aaade8101c3715dee19b46226f909';

/// Calculate potential win amount

abstract class _$PotentialWinCalculator extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
