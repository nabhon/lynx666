// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bet_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userBetHistoryHash() => r'5aea3af0eb28a62d632c8ed025ffcd2446b44d31';

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

abstract class _$UserBetHistory
    extends BuildlessAutoDisposeAsyncNotifier<List<Bet>> {
  late final BetStatus? filter;

  FutureOr<List<Bet>> build({
    BetStatus? filter,
  });
}

/// User's bet history provider
///
/// Copied from [UserBetHistory].
@ProviderFor(UserBetHistory)
const userBetHistoryProvider = UserBetHistoryFamily();

/// User's bet history provider
///
/// Copied from [UserBetHistory].
class UserBetHistoryFamily extends Family<AsyncValue<List<Bet>>> {
  /// User's bet history provider
  ///
  /// Copied from [UserBetHistory].
  const UserBetHistoryFamily();

  /// User's bet history provider
  ///
  /// Copied from [UserBetHistory].
  UserBetHistoryProvider call({
    BetStatus? filter,
  }) {
    return UserBetHistoryProvider(
      filter: filter,
    );
  }

  @override
  UserBetHistoryProvider getProviderOverride(
    covariant UserBetHistoryProvider provider,
  ) {
    return call(
      filter: provider.filter,
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
  String? get name => r'userBetHistoryProvider';
}

/// User's bet history provider
///
/// Copied from [UserBetHistory].
class UserBetHistoryProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserBetHistory, List<Bet>> {
  /// User's bet history provider
  ///
  /// Copied from [UserBetHistory].
  UserBetHistoryProvider({
    BetStatus? filter,
  }) : this._internal(
          () => UserBetHistory()..filter = filter,
          from: userBetHistoryProvider,
          name: r'userBetHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userBetHistoryHash,
          dependencies: UserBetHistoryFamily._dependencies,
          allTransitiveDependencies:
              UserBetHistoryFamily._allTransitiveDependencies,
          filter: filter,
        );

  UserBetHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filter,
  }) : super.internal();

  final BetStatus? filter;

  @override
  FutureOr<List<Bet>> runNotifierBuild(
    covariant UserBetHistory notifier,
  ) {
    return notifier.build(
      filter: filter,
    );
  }

  @override
  Override overrideWith(UserBetHistory Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserBetHistoryProvider._internal(
        () => create()..filter = filter,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filter: filter,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserBetHistory, List<Bet>>
      createElement() {
    return _UserBetHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserBetHistoryProvider && other.filter == filter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserBetHistoryRef on AutoDisposeAsyncNotifierProviderRef<List<Bet>> {
  /// The parameter `filter` of this provider.
  BetStatus? get filter;
}

class _UserBetHistoryProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserBetHistory, List<Bet>>
    with UserBetHistoryRef {
  _UserBetHistoryProviderElement(super.provider);

  @override
  BetStatus? get filter => (origin as UserBetHistoryProvider).filter;
}

String _$userPendingBetsHash() => r'68fb855852ed82714ddf85652ab050e7c8256e1f';

/// User's pending bets provider
///
/// Copied from [UserPendingBets].
@ProviderFor(UserPendingBets)
final userPendingBetsProvider =
    AutoDisposeAsyncNotifierProvider<UserPendingBets, List<Bet>>.internal(
  UserPendingBets.new,
  name: r'userPendingBetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userPendingBetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserPendingBets = AutoDisposeAsyncNotifier<List<Bet>>;
String _$userWonBetsHash() => r'887d04f8fdf5f9071ca8d58e47ab9b2edb215fd0';

/// User's won bets provider
///
/// Copied from [UserWonBets].
@ProviderFor(UserWonBets)
final userWonBetsProvider =
    AutoDisposeAsyncNotifierProvider<UserWonBets, List<Bet>>.internal(
  UserWonBets.new,
  name: r'userWonBetsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userWonBetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserWonBets = AutoDisposeAsyncNotifier<List<Bet>>;
String _$betByIdHash() => r'cd4df55f0095dd41c412ef4b675bcace570d45f2';

abstract class _$BetById extends BuildlessAutoDisposeAsyncNotifier<Bet?> {
  late final String betId;

  FutureOr<Bet?> build(
    String betId,
  );
}

/// Single bet provider
///
/// Copied from [BetById].
@ProviderFor(BetById)
const betByIdProvider = BetByIdFamily();

/// Single bet provider
///
/// Copied from [BetById].
class BetByIdFamily extends Family<AsyncValue<Bet?>> {
  /// Single bet provider
  ///
  /// Copied from [BetById].
  const BetByIdFamily();

  /// Single bet provider
  ///
  /// Copied from [BetById].
  BetByIdProvider call(
    String betId,
  ) {
    return BetByIdProvider(
      betId,
    );
  }

  @override
  BetByIdProvider getProviderOverride(
    covariant BetByIdProvider provider,
  ) {
    return call(
      provider.betId,
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
  String? get name => r'betByIdProvider';
}

/// Single bet provider
///
/// Copied from [BetById].
class BetByIdProvider
    extends AutoDisposeAsyncNotifierProviderImpl<BetById, Bet?> {
  /// Single bet provider
  ///
  /// Copied from [BetById].
  BetByIdProvider(
    String betId,
  ) : this._internal(
          () => BetById()..betId = betId,
          from: betByIdProvider,
          name: r'betByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$betByIdHash,
          dependencies: BetByIdFamily._dependencies,
          allTransitiveDependencies: BetByIdFamily._allTransitiveDependencies,
          betId: betId,
        );

  BetByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.betId,
  }) : super.internal();

  final String betId;

  @override
  FutureOr<Bet?> runNotifierBuild(
    covariant BetById notifier,
  ) {
    return notifier.build(
      betId,
    );
  }

  @override
  Override overrideWith(BetById Function() create) {
    return ProviderOverride(
      origin: this,
      override: BetByIdProvider._internal(
        () => create()..betId = betId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        betId: betId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BetById, Bet?> createElement() {
    return _BetByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BetByIdProvider && other.betId == betId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, betId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BetByIdRef on AutoDisposeAsyncNotifierProviderRef<Bet?> {
  /// The parameter `betId` of this provider.
  String get betId;
}

class _BetByIdProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<BetById, Bet?>
    with BetByIdRef {
  _BetByIdProviderElement(super.provider);

  @override
  String get betId => (origin as BetByIdProvider).betId;
}

String _$placeBetHash() => r'27ffa041e128d05d2d72cbb9929415b108e05b9d';

/// Place bet provider - handles placing a new bet
///
/// Copied from [PlaceBet].
@ProviderFor(PlaceBet)
final placeBetProvider =
    AutoDisposeAsyncNotifierProvider<PlaceBet, Bet?>.internal(
  PlaceBet.new,
  name: r'placeBetProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$placeBetHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PlaceBet = AutoDisposeAsyncNotifier<Bet?>;
String _$betStatsHash() => r'66a454575a38afe9e6dfd40a13da833813e0e98b';

/// Bet statistics provider
///
/// Copied from [BetStats].
@ProviderFor(BetStats)
final betStatsProvider =
    AutoDisposeAsyncNotifierProvider<BetStats, Map<String, dynamic>>.internal(
  BetStats.new,
  name: r'betStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$betStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BetStats = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
