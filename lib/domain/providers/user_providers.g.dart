// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Leaderboard provider

@ProviderFor(Leaderboard)
final leaderboardProvider = LeaderboardFamily._();

/// Leaderboard provider
final class LeaderboardProvider
    extends $AsyncNotifierProvider<Leaderboard, List<LeaderboardEntry>> {
  /// Leaderboard provider
  LeaderboardProvider._({
    required LeaderboardFamily super.from,
    required ({int page, int limit}) super.argument,
  }) : super(
         retry: null,
         name: r'leaderboardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$leaderboardHash();

  @override
  String toString() {
    return r'leaderboardProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  Leaderboard create() => Leaderboard();

  @override
  bool operator ==(Object other) {
    return other is LeaderboardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$leaderboardHash() => r'8f3617f17cea0685d697355bf2d4aa6aa4f30cf1';

/// Leaderboard provider

final class LeaderboardFamily extends $Family
    with
        $ClassFamilyOverride<
          Leaderboard,
          AsyncValue<List<LeaderboardEntry>>,
          List<LeaderboardEntry>,
          FutureOr<List<LeaderboardEntry>>,
          ({int page, int limit})
        > {
  LeaderboardFamily._()
    : super(
        retry: null,
        name: r'leaderboardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Leaderboard provider

  LeaderboardProvider call({int page = 1, int limit = 50}) =>
      LeaderboardProvider._(argument: (page: page, limit: limit), from: this);

  @override
  String toString() => r'leaderboardProvider';
}

/// Leaderboard provider

abstract class _$Leaderboard extends $AsyncNotifier<List<LeaderboardEntry>> {
  late final _$args = ref.$arg as ({int page, int limit});
  int get page => _$args.page;
  int get limit => _$args.limit;

  FutureOr<List<LeaderboardEntry>> build({int page = 1, int limit = 50});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<LeaderboardEntry>>, List<LeaderboardEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<LeaderboardEntry>>,
                List<LeaderboardEntry>
              >,
              AsyncValue<List<LeaderboardEntry>>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(page: _$args.page, limit: _$args.limit),
    );
  }
}

/// Top users provider (limited)

@ProviderFor(TopUsers)
final topUsersProvider = TopUsersFamily._();

/// Top users provider (limited)
final class TopUsersProvider
    extends $AsyncNotifierProvider<TopUsers, List<LeaderboardEntry>> {
  /// Top users provider (limited)
  TopUsersProvider._({
    required TopUsersFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'topUsersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$topUsersHash();

  @override
  String toString() {
    return r'topUsersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TopUsers create() => TopUsers();

  @override
  bool operator ==(Object other) {
    return other is TopUsersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$topUsersHash() => r'b3e7f0cbda62bf954b1634deb60e5f00f2ea2cdf';

/// Top users provider (limited)

final class TopUsersFamily extends $Family
    with
        $ClassFamilyOverride<
          TopUsers,
          AsyncValue<List<LeaderboardEntry>>,
          List<LeaderboardEntry>,
          FutureOr<List<LeaderboardEntry>>,
          int
        > {
  TopUsersFamily._()
    : super(
        retry: null,
        name: r'topUsersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Top users provider (limited)

  TopUsersProvider call({int limit = 10}) =>
      TopUsersProvider._(argument: limit, from: this);

  @override
  String toString() => r'topUsersProvider';
}

/// Top users provider (limited)

abstract class _$TopUsers extends $AsyncNotifier<List<LeaderboardEntry>> {
  late final _$args = ref.$arg as int;
  int get limit => _$args;

  FutureOr<List<LeaderboardEntry>> build({int limit = 10});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<LeaderboardEntry>>, List<LeaderboardEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<LeaderboardEntry>>,
                List<LeaderboardEntry>
              >,
              AsyncValue<List<LeaderboardEntry>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(limit: _$args));
  }
}

/// User stats provider

@ProviderFor(UserStatsProvider)
final userStatsProviderProvider = UserStatsProviderFamily._();

/// User stats provider
final class UserStatsProviderProvider
    extends $AsyncNotifierProvider<UserStatsProvider, UserStats?> {
  /// User stats provider
  UserStatsProviderProvider._({
    required UserStatsProviderFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userStatsProviderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userStatsProviderHash();

  @override
  String toString() {
    return r'userStatsProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserStatsProvider create() => UserStatsProvider();

  @override
  bool operator ==(Object other) {
    return other is UserStatsProviderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userStatsProviderHash() => r'53c6abf6711e83349b026fc1a15bf9915e5fb41e';

/// User stats provider

final class UserStatsProviderFamily extends $Family
    with
        $ClassFamilyOverride<
          UserStatsProvider,
          AsyncValue<UserStats?>,
          UserStats?,
          FutureOr<UserStats?>,
          String
        > {
  UserStatsProviderFamily._()
    : super(
        retry: null,
        name: r'userStatsProviderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// User stats provider

  UserStatsProviderProvider call(String userId) =>
      UserStatsProviderProvider._(argument: userId, from: this);

  @override
  String toString() => r'userStatsProviderProvider';
}

/// User stats provider

abstract class _$UserStatsProvider extends $AsyncNotifier<UserStats?> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<UserStats?> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserStats?>, UserStats?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserStats?>, UserStats?>,
              AsyncValue<UserStats?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// Current user's stats provider

@ProviderFor(CurrentUserStatsProvider)
final currentUserStatsProviderProvider = CurrentUserStatsProviderFamily._();

/// Current user's stats provider
final class CurrentUserStatsProviderProvider
    extends $NotifierProvider<CurrentUserStatsProvider, UserStats?> {
  /// Current user's stats provider
  CurrentUserStatsProviderProvider._({
    required CurrentUserStatsProviderFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'currentUserStatsProviderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$currentUserStatsProviderHash();

  @override
  String toString() {
    return r'currentUserStatsProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CurrentUserStatsProvider create() => CurrentUserStatsProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserStats? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserStats?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentUserStatsProviderProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currentUserStatsProviderHash() =>
    r'5b048a72cb36dc3996dfbce92edac61b37fd0df0';

/// Current user's stats provider

final class CurrentUserStatsProviderFamily extends $Family
    with
        $ClassFamilyOverride<
          CurrentUserStatsProvider,
          UserStats?,
          UserStats?,
          UserStats?,
          String
        > {
  CurrentUserStatsProviderFamily._()
    : super(
        retry: null,
        name: r'currentUserStatsProviderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Current user's stats provider

  CurrentUserStatsProviderProvider call(String userId) =>
      CurrentUserStatsProviderProvider._(argument: userId, from: this);

  @override
  String toString() => r'currentUserStatsProviderProvider';
}

/// Current user's stats provider

abstract class _$CurrentUserStatsProvider extends $Notifier<UserStats?> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  UserStats? build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UserStats?, UserStats?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserStats?, UserStats?>,
              UserStats?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// User by ID provider

@ProviderFor(UserById)
final userByIdProvider = UserByIdFamily._();

/// User by ID provider
final class UserByIdProvider
    extends $AsyncNotifierProvider<UserById, Profile?> {
  /// User by ID provider
  UserByIdProvider._({
    required UserByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userByIdHash();

  @override
  String toString() {
    return r'userByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserById create() => UserById();

  @override
  bool operator ==(Object other) {
    return other is UserByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userByIdHash() => r'f025f53770c1516ae71b2e5d68ac8f295d46bf34';

/// User by ID provider

final class UserByIdFamily extends $Family
    with
        $ClassFamilyOverride<
          UserById,
          AsyncValue<Profile?>,
          Profile?,
          FutureOr<Profile?>,
          String
        > {
  UserByIdFamily._()
    : super(
        retry: null,
        name: r'userByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// User by ID provider

  UserByIdProvider call(String userId) =>
      UserByIdProvider._(argument: userId, from: this);

  @override
  String toString() => r'userByIdProvider';
}

/// User by ID provider

abstract class _$UserById extends $AsyncNotifier<Profile?> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<Profile?> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Profile?>, Profile?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Profile?>, Profile?>,
              AsyncValue<Profile?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// Search users provider

@ProviderFor(SearchUsers)
final searchUsersProvider = SearchUsersFamily._();

/// Search users provider
final class SearchUsersProvider
    extends $AsyncNotifierProvider<SearchUsers, List<Profile>> {
  /// Search users provider
  SearchUsersProvider._({
    required SearchUsersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'searchUsersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchUsersHash();

  @override
  String toString() {
    return r'searchUsersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SearchUsers create() => SearchUsers();

  @override
  bool operator ==(Object other) {
    return other is SearchUsersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchUsersHash() => r'2a32c539cde1bf27c9ae4538b785a61847a581d0';

/// Search users provider

final class SearchUsersFamily extends $Family
    with
        $ClassFamilyOverride<
          SearchUsers,
          AsyncValue<List<Profile>>,
          List<Profile>,
          FutureOr<List<Profile>>,
          String
        > {
  SearchUsersFamily._()
    : super(
        retry: null,
        name: r'searchUsersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Search users provider

  SearchUsersProvider call(String query) =>
      SearchUsersProvider._(argument: query, from: this);

  @override
  String toString() => r'searchUsersProvider';
}

/// Search users provider

abstract class _$SearchUsers extends $AsyncNotifier<List<Profile>> {
  late final _$args = ref.$arg as String;
  String get query => _$args;

  FutureOr<List<Profile>> build(String query);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Profile>>, List<Profile>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Profile>>, List<Profile>>,
              AsyncValue<List<Profile>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
