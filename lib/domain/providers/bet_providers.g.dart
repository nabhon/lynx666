// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bet_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// User's bet history provider

@ProviderFor(UserBetHistory)
final userBetHistoryProvider = UserBetHistoryFamily._();

/// User's bet history provider
final class UserBetHistoryProvider
    extends $AsyncNotifierProvider<UserBetHistory, List<Bet>> {
  /// User's bet history provider
  UserBetHistoryProvider._({
    required UserBetHistoryFamily super.from,
    required BetStatus? super.argument,
  }) : super(
         retry: null,
         name: r'userBetHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userBetHistoryHash();

  @override
  String toString() {
    return r'userBetHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserBetHistory create() => UserBetHistory();

  @override
  bool operator ==(Object other) {
    return other is UserBetHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userBetHistoryHash() => r'5aea3af0eb28a62d632c8ed025ffcd2446b44d31';

/// User's bet history provider

final class UserBetHistoryFamily extends $Family
    with
        $ClassFamilyOverride<
          UserBetHistory,
          AsyncValue<List<Bet>>,
          List<Bet>,
          FutureOr<List<Bet>>,
          BetStatus?
        > {
  UserBetHistoryFamily._()
    : super(
        retry: null,
        name: r'userBetHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// User's bet history provider

  UserBetHistoryProvider call({BetStatus? filter}) =>
      UserBetHistoryProvider._(argument: filter, from: this);

  @override
  String toString() => r'userBetHistoryProvider';
}

/// User's bet history provider

abstract class _$UserBetHistory extends $AsyncNotifier<List<Bet>> {
  late final _$args = ref.$arg as BetStatus?;
  BetStatus? get filter => _$args;

  FutureOr<List<Bet>> build({BetStatus? filter});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Bet>>, List<Bet>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Bet>>, List<Bet>>,
              AsyncValue<List<Bet>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(filter: _$args));
  }
}

/// User's pending bets provider

@ProviderFor(UserPendingBets)
final userPendingBetsProvider = UserPendingBetsProvider._();

/// User's pending bets provider
final class UserPendingBetsProvider
    extends $AsyncNotifierProvider<UserPendingBets, List<Bet>> {
  /// User's pending bets provider
  UserPendingBetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userPendingBetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userPendingBetsHash();

  @$internal
  @override
  UserPendingBets create() => UserPendingBets();
}

String _$userPendingBetsHash() => r'68fb855852ed82714ddf85652ab050e7c8256e1f';

/// User's pending bets provider

abstract class _$UserPendingBets extends $AsyncNotifier<List<Bet>> {
  FutureOr<List<Bet>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Bet>>, List<Bet>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Bet>>, List<Bet>>,
              AsyncValue<List<Bet>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// User's won bets provider

@ProviderFor(UserWonBets)
final userWonBetsProvider = UserWonBetsProvider._();

/// User's won bets provider
final class UserWonBetsProvider
    extends $AsyncNotifierProvider<UserWonBets, List<Bet>> {
  /// User's won bets provider
  UserWonBetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userWonBetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userWonBetsHash();

  @$internal
  @override
  UserWonBets create() => UserWonBets();
}

String _$userWonBetsHash() => r'887d04f8fdf5f9071ca8d58e47ab9b2edb215fd0';

/// User's won bets provider

abstract class _$UserWonBets extends $AsyncNotifier<List<Bet>> {
  FutureOr<List<Bet>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Bet>>, List<Bet>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Bet>>, List<Bet>>,
              AsyncValue<List<Bet>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Single bet provider

@ProviderFor(BetById)
final betByIdProvider = BetByIdFamily._();

/// Single bet provider
final class BetByIdProvider extends $AsyncNotifierProvider<BetById, Bet?> {
  /// Single bet provider
  BetByIdProvider._({
    required BetByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'betByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$betByIdHash();

  @override
  String toString() {
    return r'betByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BetById create() => BetById();

  @override
  bool operator ==(Object other) {
    return other is BetByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$betByIdHash() => r'cd4df55f0095dd41c412ef4b675bcace570d45f2';

/// Single bet provider

final class BetByIdFamily extends $Family
    with
        $ClassFamilyOverride<
          BetById,
          AsyncValue<Bet?>,
          Bet?,
          FutureOr<Bet?>,
          String
        > {
  BetByIdFamily._()
    : super(
        retry: null,
        name: r'betByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Single bet provider

  BetByIdProvider call(String betId) =>
      BetByIdProvider._(argument: betId, from: this);

  @override
  String toString() => r'betByIdProvider';
}

/// Single bet provider

abstract class _$BetById extends $AsyncNotifier<Bet?> {
  late final _$args = ref.$arg as String;
  String get betId => _$args;

  FutureOr<Bet?> build(String betId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Bet?>, Bet?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Bet?>, Bet?>,
              AsyncValue<Bet?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// Place bet provider - handles placing a new bet

@ProviderFor(PlaceBet)
final placeBetProvider = PlaceBetProvider._();

/// Place bet provider - handles placing a new bet
final class PlaceBetProvider extends $AsyncNotifierProvider<PlaceBet, Bet?> {
  /// Place bet provider - handles placing a new bet
  PlaceBetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placeBetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placeBetHash();

  @$internal
  @override
  PlaceBet create() => PlaceBet();
}

String _$placeBetHash() => r'9fdf47a58fb048aec50fc426416c0f9ee6ddaf74';

/// Place bet provider - handles placing a new bet

abstract class _$PlaceBet extends $AsyncNotifier<Bet?> {
  FutureOr<Bet?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Bet?>, Bet?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Bet?>, Bet?>,
              AsyncValue<Bet?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Bet statistics provider

@ProviderFor(BetStats)
final betStatsProvider = BetStatsProvider._();

/// Bet statistics provider
final class BetStatsProvider
    extends $AsyncNotifierProvider<BetStats, Map<String, dynamic>> {
  /// Bet statistics provider
  BetStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'betStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$betStatsHash();

  @$internal
  @override
  BetStats create() => BetStats();
}

String _$betStatsHash() => r'66a454575a38afe9e6dfd40a13da833813e0e98b';

/// Bet statistics provider

abstract class _$BetStats extends $AsyncNotifier<Map<String, dynamic>> {
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
