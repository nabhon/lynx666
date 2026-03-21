// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lottery_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Latest completed lottery draw provider

@ProviderFor(LatestLotteryDraw)
final latestLotteryDrawProvider = LatestLotteryDrawProvider._();

/// Latest completed lottery draw provider
final class LatestLotteryDrawProvider
    extends $AsyncNotifierProvider<LatestLotteryDraw, LotteryDraw?> {
  /// Latest completed lottery draw provider
  LatestLotteryDrawProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestLotteryDrawProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestLotteryDrawHash();

  @$internal
  @override
  LatestLotteryDraw create() => LatestLotteryDraw();
}

String _$latestLotteryDrawHash() => r'6760e8f05ad319df414479ea38948dfb0489e296';

/// Latest completed lottery draw provider

abstract class _$LatestLotteryDraw extends $AsyncNotifier<LotteryDraw?> {
  FutureOr<LotteryDraw?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LotteryDraw?>, LotteryDraw?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LotteryDraw?>, LotteryDraw?>,
              AsyncValue<LotteryDraw?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Next lottery draw provider

@ProviderFor(NextLotteryDraw)
final nextLotteryDrawProvider = NextLotteryDrawProvider._();

/// Next lottery draw provider
final class NextLotteryDrawProvider
    extends $AsyncNotifierProvider<NextLotteryDraw, LotteryDraw?> {
  /// Next lottery draw provider
  NextLotteryDrawProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nextLotteryDrawProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nextLotteryDrawHash();

  @$internal
  @override
  NextLotteryDraw create() => NextLotteryDraw();
}

String _$nextLotteryDrawHash() => r'49676c23c2f0b1796ae46883b46a32d0c6047074';

/// Next lottery draw provider

abstract class _$NextLotteryDraw extends $AsyncNotifier<LotteryDraw?> {
  FutureOr<LotteryDraw?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LotteryDraw?>, LotteryDraw?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LotteryDraw?>, LotteryDraw?>,
              AsyncValue<LotteryDraw?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Countdown timer provider - updates every second

@ProviderFor(LotteryCountdown)
final lotteryCountdownProvider = LotteryCountdownProvider._();

/// Countdown timer provider - updates every second
final class LotteryCountdownProvider
    extends $NotifierProvider<LotteryCountdown, Duration> {
  /// Countdown timer provider - updates every second
  LotteryCountdownProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lotteryCountdownProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lotteryCountdownHash();

  @$internal
  @override
  LotteryCountdown create() => LotteryCountdown();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$lotteryCountdownHash() => r'8ebb4b69253d8fe6db2a1b07e69766b580e76dd2';

/// Countdown timer provider - updates every second

abstract class _$LotteryCountdown extends $Notifier<Duration> {
  Duration build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Duration, Duration>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Duration, Duration>,
              Duration,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Lottery draws list provider

@ProviderFor(LotteryDrawsList)
final lotteryDrawsListProvider = LotteryDrawsListFamily._();

/// Lottery draws list provider
final class LotteryDrawsListProvider
    extends $AsyncNotifierProvider<LotteryDrawsList, List<LotteryDraw>> {
  /// Lottery draws list provider
  LotteryDrawsListProvider._({
    required LotteryDrawsListFamily super.from,
    required ({int page, int limit, DrawStatus? status}) super.argument,
  }) : super(
         retry: null,
         name: r'lotteryDrawsListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lotteryDrawsListHash();

  @override
  String toString() {
    return r'lotteryDrawsListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LotteryDrawsList create() => LotteryDrawsList();

  @override
  bool operator ==(Object other) {
    return other is LotteryDrawsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lotteryDrawsListHash() => r'19332587629df88c27e38f788639e680c3091b6d';

/// Lottery draws list provider

final class LotteryDrawsListFamily extends $Family
    with
        $ClassFamilyOverride<
          LotteryDrawsList,
          AsyncValue<List<LotteryDraw>>,
          List<LotteryDraw>,
          FutureOr<List<LotteryDraw>>,
          ({int page, int limit, DrawStatus? status})
        > {
  LotteryDrawsListFamily._()
    : super(
        retry: null,
        name: r'lotteryDrawsListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Lottery draws list provider

  LotteryDrawsListProvider call({
    int page = 1,
    int limit = 20,
    DrawStatus? status,
  }) => LotteryDrawsListProvider._(
    argument: (page: page, limit: limit, status: status),
    from: this,
  );

  @override
  String toString() => r'lotteryDrawsListProvider';
}

/// Lottery draws list provider

abstract class _$LotteryDrawsList extends $AsyncNotifier<List<LotteryDraw>> {
  late final _$args = ref.$arg as ({int page, int limit, DrawStatus? status});
  int get page => _$args.page;
  int get limit => _$args.limit;
  DrawStatus? get status => _$args.status;

  FutureOr<List<LotteryDraw>> build({
    int page = 1,
    int limit = 20,
    DrawStatus? status,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<LotteryDraw>>, List<LotteryDraw>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<LotteryDraw>>, List<LotteryDraw>>,
              AsyncValue<List<LotteryDraw>>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () =>
          build(page: _$args.page, limit: _$args.limit, status: _$args.status),
    );
  }
}

/// Single lottery draw provider

@ProviderFor(LotteryDrawById)
final lotteryDrawByIdProvider = LotteryDrawByIdFamily._();

/// Single lottery draw provider
final class LotteryDrawByIdProvider
    extends $AsyncNotifierProvider<LotteryDrawById, LotteryDraw?> {
  /// Single lottery draw provider
  LotteryDrawByIdProvider._({
    required LotteryDrawByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lotteryDrawByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lotteryDrawByIdHash();

  @override
  String toString() {
    return r'lotteryDrawByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LotteryDrawById create() => LotteryDrawById();

  @override
  bool operator ==(Object other) {
    return other is LotteryDrawByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lotteryDrawByIdHash() => r'60b0d8f9023c0821e1889e36911fbc894a7c4186';

/// Single lottery draw provider

final class LotteryDrawByIdFamily extends $Family
    with
        $ClassFamilyOverride<
          LotteryDrawById,
          AsyncValue<LotteryDraw?>,
          LotteryDraw?,
          FutureOr<LotteryDraw?>,
          String
        > {
  LotteryDrawByIdFamily._()
    : super(
        retry: null,
        name: r'lotteryDrawByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Single lottery draw provider

  LotteryDrawByIdProvider call(String drawId) =>
      LotteryDrawByIdProvider._(argument: drawId, from: this);

  @override
  String toString() => r'lotteryDrawByIdProvider';
}

/// Single lottery draw provider

abstract class _$LotteryDrawById extends $AsyncNotifier<LotteryDraw?> {
  late final _$args = ref.$arg as String;
  String get drawId => _$args;

  FutureOr<LotteryDraw?> build(String drawId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LotteryDraw?>, LotteryDraw?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LotteryDraw?>, LotteryDraw?>,
              AsyncValue<LotteryDraw?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
