// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lottery_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$latestLotteryDrawHash() => r'6760e8f05ad319df414479ea38948dfb0489e296';

/// Latest completed lottery draw provider
///
/// Copied from [LatestLotteryDraw].
@ProviderFor(LatestLotteryDraw)
final latestLotteryDrawProvider =
    AutoDisposeAsyncNotifierProvider<LatestLotteryDraw, LotteryDraw?>.internal(
  LatestLotteryDraw.new,
  name: r'latestLotteryDrawProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$latestLotteryDrawHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LatestLotteryDraw = AutoDisposeAsyncNotifier<LotteryDraw?>;
String _$nextLotteryDrawHash() => r'49676c23c2f0b1796ae46883b46a32d0c6047074';

/// Next lottery draw provider
///
/// Copied from [NextLotteryDraw].
@ProviderFor(NextLotteryDraw)
final nextLotteryDrawProvider =
    AutoDisposeAsyncNotifierProvider<NextLotteryDraw, LotteryDraw?>.internal(
  NextLotteryDraw.new,
  name: r'nextLotteryDrawProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nextLotteryDrawHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NextLotteryDraw = AutoDisposeAsyncNotifier<LotteryDraw?>;
String _$lotteryCountdownHash() => r'23ae8b806233e8c20a8826e1a658778e5590c7b8';

/// Countdown timer provider - updates every second
///
/// Copied from [LotteryCountdown].
@ProviderFor(LotteryCountdown)
final lotteryCountdownProvider =
    AutoDisposeNotifierProvider<LotteryCountdown, Duration>.internal(
  LotteryCountdown.new,
  name: r'lotteryCountdownProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lotteryCountdownHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LotteryCountdown = AutoDisposeNotifier<Duration>;
String _$lotteryDrawsListHash() => r'19332587629df88c27e38f788639e680c3091b6d';

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

abstract class _$LotteryDrawsList
    extends BuildlessAutoDisposeAsyncNotifier<List<LotteryDraw>> {
  late final int page;
  late final int limit;
  late final DrawStatus? status;

  FutureOr<List<LotteryDraw>> build({
    int page = 1,
    int limit = 20,
    DrawStatus? status,
  });
}

/// Lottery draws list provider
///
/// Copied from [LotteryDrawsList].
@ProviderFor(LotteryDrawsList)
const lotteryDrawsListProvider = LotteryDrawsListFamily();

/// Lottery draws list provider
///
/// Copied from [LotteryDrawsList].
class LotteryDrawsListFamily extends Family<AsyncValue<List<LotteryDraw>>> {
  /// Lottery draws list provider
  ///
  /// Copied from [LotteryDrawsList].
  const LotteryDrawsListFamily();

  /// Lottery draws list provider
  ///
  /// Copied from [LotteryDrawsList].
  LotteryDrawsListProvider call({
    int page = 1,
    int limit = 20,
    DrawStatus? status,
  }) {
    return LotteryDrawsListProvider(
      page: page,
      limit: limit,
      status: status,
    );
  }

  @override
  LotteryDrawsListProvider getProviderOverride(
    covariant LotteryDrawsListProvider provider,
  ) {
    return call(
      page: provider.page,
      limit: provider.limit,
      status: provider.status,
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
  String? get name => r'lotteryDrawsListProvider';
}

/// Lottery draws list provider
///
/// Copied from [LotteryDrawsList].
class LotteryDrawsListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    LotteryDrawsList, List<LotteryDraw>> {
  /// Lottery draws list provider
  ///
  /// Copied from [LotteryDrawsList].
  LotteryDrawsListProvider({
    int page = 1,
    int limit = 20,
    DrawStatus? status,
  }) : this._internal(
          () => LotteryDrawsList()
            ..page = page
            ..limit = limit
            ..status = status,
          from: lotteryDrawsListProvider,
          name: r'lotteryDrawsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lotteryDrawsListHash,
          dependencies: LotteryDrawsListFamily._dependencies,
          allTransitiveDependencies:
              LotteryDrawsListFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
          status: status,
        );

  LotteryDrawsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
    required this.status,
  }) : super.internal();

  final int page;
  final int limit;
  final DrawStatus? status;

  @override
  FutureOr<List<LotteryDraw>> runNotifierBuild(
    covariant LotteryDrawsList notifier,
  ) {
    return notifier.build(
      page: page,
      limit: limit,
      status: status,
    );
  }

  @override
  Override overrideWith(LotteryDrawsList Function() create) {
    return ProviderOverride(
      origin: this,
      override: LotteryDrawsListProvider._internal(
        () => create()
          ..page = page
          ..limit = limit
          ..status = status,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<LotteryDrawsList, List<LotteryDraw>>
      createElement() {
    return _LotteryDrawsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LotteryDrawsListProvider &&
        other.page == page &&
        other.limit == limit &&
        other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LotteryDrawsListRef
    on AutoDisposeAsyncNotifierProviderRef<List<LotteryDraw>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `status` of this provider.
  DrawStatus? get status;
}

class _LotteryDrawsListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<LotteryDrawsList,
        List<LotteryDraw>> with LotteryDrawsListRef {
  _LotteryDrawsListProviderElement(super.provider);

  @override
  int get page => (origin as LotteryDrawsListProvider).page;
  @override
  int get limit => (origin as LotteryDrawsListProvider).limit;
  @override
  DrawStatus? get status => (origin as LotteryDrawsListProvider).status;
}

String _$lotteryDrawByIdHash() => r'60b0d8f9023c0821e1889e36911fbc894a7c4186';

abstract class _$LotteryDrawById
    extends BuildlessAutoDisposeAsyncNotifier<LotteryDraw?> {
  late final String drawId;

  FutureOr<LotteryDraw?> build(
    String drawId,
  );
}

/// Single lottery draw provider
///
/// Copied from [LotteryDrawById].
@ProviderFor(LotteryDrawById)
const lotteryDrawByIdProvider = LotteryDrawByIdFamily();

/// Single lottery draw provider
///
/// Copied from [LotteryDrawById].
class LotteryDrawByIdFamily extends Family<AsyncValue<LotteryDraw?>> {
  /// Single lottery draw provider
  ///
  /// Copied from [LotteryDrawById].
  const LotteryDrawByIdFamily();

  /// Single lottery draw provider
  ///
  /// Copied from [LotteryDrawById].
  LotteryDrawByIdProvider call(
    String drawId,
  ) {
    return LotteryDrawByIdProvider(
      drawId,
    );
  }

  @override
  LotteryDrawByIdProvider getProviderOverride(
    covariant LotteryDrawByIdProvider provider,
  ) {
    return call(
      provider.drawId,
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
  String? get name => r'lotteryDrawByIdProvider';
}

/// Single lottery draw provider
///
/// Copied from [LotteryDrawById].
class LotteryDrawByIdProvider extends AutoDisposeAsyncNotifierProviderImpl<
    LotteryDrawById, LotteryDraw?> {
  /// Single lottery draw provider
  ///
  /// Copied from [LotteryDrawById].
  LotteryDrawByIdProvider(
    String drawId,
  ) : this._internal(
          () => LotteryDrawById()..drawId = drawId,
          from: lotteryDrawByIdProvider,
          name: r'lotteryDrawByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lotteryDrawByIdHash,
          dependencies: LotteryDrawByIdFamily._dependencies,
          allTransitiveDependencies:
              LotteryDrawByIdFamily._allTransitiveDependencies,
          drawId: drawId,
        );

  LotteryDrawByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.drawId,
  }) : super.internal();

  final String drawId;

  @override
  FutureOr<LotteryDraw?> runNotifierBuild(
    covariant LotteryDrawById notifier,
  ) {
    return notifier.build(
      drawId,
    );
  }

  @override
  Override overrideWith(LotteryDrawById Function() create) {
    return ProviderOverride(
      origin: this,
      override: LotteryDrawByIdProvider._internal(
        () => create()..drawId = drawId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        drawId: drawId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<LotteryDrawById, LotteryDraw?>
      createElement() {
    return _LotteryDrawByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LotteryDrawByIdProvider && other.drawId == drawId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, drawId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LotteryDrawByIdRef on AutoDisposeAsyncNotifierProviderRef<LotteryDraw?> {
  /// The parameter `drawId` of this provider.
  String get drawId;
}

class _LotteryDrawByIdProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<LotteryDrawById,
        LotteryDraw?> with LotteryDrawByIdRef {
  _LotteryDrawByIdProviderElement(super.provider);

  @override
  String get drawId => (origin as LotteryDrawByIdProvider).drawId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
