// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$leaderboardHash() => r'8f3617f17cea0685d697355bf2d4aa6aa4f30cf1';

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

abstract class _$Leaderboard
    extends BuildlessAutoDisposeAsyncNotifier<List<LeaderboardEntry>> {
  late final int page;
  late final int limit;

  FutureOr<List<LeaderboardEntry>> build({
    int page = 1,
    int limit = 50,
  });
}

/// Leaderboard provider
///
/// Copied from [Leaderboard].
@ProviderFor(Leaderboard)
const leaderboardProvider = LeaderboardFamily();

/// Leaderboard provider
///
/// Copied from [Leaderboard].
class LeaderboardFamily extends Family<AsyncValue<List<LeaderboardEntry>>> {
  /// Leaderboard provider
  ///
  /// Copied from [Leaderboard].
  const LeaderboardFamily();

  /// Leaderboard provider
  ///
  /// Copied from [Leaderboard].
  LeaderboardProvider call({
    int page = 1,
    int limit = 50,
  }) {
    return LeaderboardProvider(
      page: page,
      limit: limit,
    );
  }

  @override
  LeaderboardProvider getProviderOverride(
    covariant LeaderboardProvider provider,
  ) {
    return call(
      page: provider.page,
      limit: provider.limit,
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
  String? get name => r'leaderboardProvider';
}

/// Leaderboard provider
///
/// Copied from [Leaderboard].
class LeaderboardProvider extends AutoDisposeAsyncNotifierProviderImpl<
    Leaderboard, List<LeaderboardEntry>> {
  /// Leaderboard provider
  ///
  /// Copied from [Leaderboard].
  LeaderboardProvider({
    int page = 1,
    int limit = 50,
  }) : this._internal(
          () => Leaderboard()
            ..page = page
            ..limit = limit,
          from: leaderboardProvider,
          name: r'leaderboardProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$leaderboardHash,
          dependencies: LeaderboardFamily._dependencies,
          allTransitiveDependencies:
              LeaderboardFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
        );

  LeaderboardProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
  }) : super.internal();

  final int page;
  final int limit;

  @override
  FutureOr<List<LeaderboardEntry>> runNotifierBuild(
    covariant Leaderboard notifier,
  ) {
    return notifier.build(
      page: page,
      limit: limit,
    );
  }

  @override
  Override overrideWith(Leaderboard Function() create) {
    return ProviderOverride(
      origin: this,
      override: LeaderboardProvider._internal(
        () => create()
          ..page = page
          ..limit = limit,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Leaderboard, List<LeaderboardEntry>>
      createElement() {
    return _LeaderboardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LeaderboardProvider &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LeaderboardRef
    on AutoDisposeAsyncNotifierProviderRef<List<LeaderboardEntry>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _LeaderboardProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Leaderboard,
        List<LeaderboardEntry>> with LeaderboardRef {
  _LeaderboardProviderElement(super.provider);

  @override
  int get page => (origin as LeaderboardProvider).page;
  @override
  int get limit => (origin as LeaderboardProvider).limit;
}

String _$topUsersHash() => r'b3e7f0cbda62bf954b1634deb60e5f00f2ea2cdf';

abstract class _$TopUsers
    extends BuildlessAutoDisposeAsyncNotifier<List<LeaderboardEntry>> {
  late final int limit;

  FutureOr<List<LeaderboardEntry>> build({
    int limit = 10,
  });
}

/// Top users provider (limited)
///
/// Copied from [TopUsers].
@ProviderFor(TopUsers)
const topUsersProvider = TopUsersFamily();

/// Top users provider (limited)
///
/// Copied from [TopUsers].
class TopUsersFamily extends Family<AsyncValue<List<LeaderboardEntry>>> {
  /// Top users provider (limited)
  ///
  /// Copied from [TopUsers].
  const TopUsersFamily();

  /// Top users provider (limited)
  ///
  /// Copied from [TopUsers].
  TopUsersProvider call({
    int limit = 10,
  }) {
    return TopUsersProvider(
      limit: limit,
    );
  }

  @override
  TopUsersProvider getProviderOverride(
    covariant TopUsersProvider provider,
  ) {
    return call(
      limit: provider.limit,
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
  String? get name => r'topUsersProvider';
}

/// Top users provider (limited)
///
/// Copied from [TopUsers].
class TopUsersProvider extends AutoDisposeAsyncNotifierProviderImpl<TopUsers,
    List<LeaderboardEntry>> {
  /// Top users provider (limited)
  ///
  /// Copied from [TopUsers].
  TopUsersProvider({
    int limit = 10,
  }) : this._internal(
          () => TopUsers()..limit = limit,
          from: topUsersProvider,
          name: r'topUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$topUsersHash,
          dependencies: TopUsersFamily._dependencies,
          allTransitiveDependencies: TopUsersFamily._allTransitiveDependencies,
          limit: limit,
        );

  TopUsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  FutureOr<List<LeaderboardEntry>> runNotifierBuild(
    covariant TopUsers notifier,
  ) {
    return notifier.build(
      limit: limit,
    );
  }

  @override
  Override overrideWith(TopUsers Function() create) {
    return ProviderOverride(
      origin: this,
      override: TopUsersProvider._internal(
        () => create()..limit = limit,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TopUsers, List<LeaderboardEntry>>
      createElement() {
    return _TopUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TopUsersProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TopUsersRef
    on AutoDisposeAsyncNotifierProviderRef<List<LeaderboardEntry>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _TopUsersProviderElement extends AutoDisposeAsyncNotifierProviderElement<
    TopUsers, List<LeaderboardEntry>> with TopUsersRef {
  _TopUsersProviderElement(super.provider);

  @override
  int get limit => (origin as TopUsersProvider).limit;
}

String _$userStatsProviderHash() => r'53c6abf6711e83349b026fc1a15bf9915e5fb41e';

abstract class _$UserStatsProvider
    extends BuildlessAutoDisposeAsyncNotifier<UserStats?> {
  late final String userId;

  FutureOr<UserStats?> build(
    String userId,
  );
}

/// User stats provider
///
/// Copied from [UserStatsProvider].
@ProviderFor(UserStatsProvider)
const userStatsProviderProvider = UserStatsProviderFamily();

/// User stats provider
///
/// Copied from [UserStatsProvider].
class UserStatsProviderFamily extends Family<AsyncValue<UserStats?>> {
  /// User stats provider
  ///
  /// Copied from [UserStatsProvider].
  const UserStatsProviderFamily();

  /// User stats provider
  ///
  /// Copied from [UserStatsProvider].
  UserStatsProviderProvider call(
    String userId,
  ) {
    return UserStatsProviderProvider(
      userId,
    );
  }

  @override
  UserStatsProviderProvider getProviderOverride(
    covariant UserStatsProviderProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userStatsProviderProvider';
}

/// User stats provider
///
/// Copied from [UserStatsProvider].
class UserStatsProviderProvider extends AutoDisposeAsyncNotifierProviderImpl<
    UserStatsProvider, UserStats?> {
  /// User stats provider
  ///
  /// Copied from [UserStatsProvider].
  UserStatsProviderProvider(
    String userId,
  ) : this._internal(
          () => UserStatsProvider()..userId = userId,
          from: userStatsProviderProvider,
          name: r'userStatsProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userStatsProviderHash,
          dependencies: UserStatsProviderFamily._dependencies,
          allTransitiveDependencies:
              UserStatsProviderFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserStatsProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FutureOr<UserStats?> runNotifierBuild(
    covariant UserStatsProvider notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(UserStatsProvider Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserStatsProviderProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserStatsProvider, UserStats?>
      createElement() {
    return _UserStatsProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserStatsProviderProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserStatsProviderRef on AutoDisposeAsyncNotifierProviderRef<UserStats?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserStatsProviderProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserStatsProvider,
        UserStats?> with UserStatsProviderRef {
  _UserStatsProviderProviderElement(super.provider);

  @override
  String get userId => (origin as UserStatsProviderProvider).userId;
}

String _$userByIdHash() => r'f025f53770c1516ae71b2e5d68ac8f295d46bf34';

abstract class _$UserById extends BuildlessAutoDisposeAsyncNotifier<Profile?> {
  late final String userId;

  FutureOr<Profile?> build(
    String userId,
  );
}

/// User by ID provider
///
/// Copied from [UserById].
@ProviderFor(UserById)
const userByIdProvider = UserByIdFamily();

/// User by ID provider
///
/// Copied from [UserById].
class UserByIdFamily extends Family<AsyncValue<Profile?>> {
  /// User by ID provider
  ///
  /// Copied from [UserById].
  const UserByIdFamily();

  /// User by ID provider
  ///
  /// Copied from [UserById].
  UserByIdProvider call(
    String userId,
  ) {
    return UserByIdProvider(
      userId,
    );
  }

  @override
  UserByIdProvider getProviderOverride(
    covariant UserByIdProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userByIdProvider';
}

/// User by ID provider
///
/// Copied from [UserById].
class UserByIdProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserById, Profile?> {
  /// User by ID provider
  ///
  /// Copied from [UserById].
  UserByIdProvider(
    String userId,
  ) : this._internal(
          () => UserById()..userId = userId,
          from: userByIdProvider,
          name: r'userByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userByIdHash,
          dependencies: UserByIdFamily._dependencies,
          allTransitiveDependencies: UserByIdFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FutureOr<Profile?> runNotifierBuild(
    covariant UserById notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(UserById Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserByIdProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserById, Profile?> createElement() {
    return _UserByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserByIdProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserByIdRef on AutoDisposeAsyncNotifierProviderRef<Profile?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserByIdProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserById, Profile?>
    with UserByIdRef {
  _UserByIdProviderElement(super.provider);

  @override
  String get userId => (origin as UserByIdProvider).userId;
}

String _$searchUsersHash() => r'2a32c539cde1bf27c9ae4538b785a61847a581d0';

abstract class _$SearchUsers
    extends BuildlessAutoDisposeAsyncNotifier<List<Profile>> {
  late final String query;

  FutureOr<List<Profile>> build(
    String query,
  );
}

/// Search users provider
///
/// Copied from [SearchUsers].
@ProviderFor(SearchUsers)
const searchUsersProvider = SearchUsersFamily();

/// Search users provider
///
/// Copied from [SearchUsers].
class SearchUsersFamily extends Family<AsyncValue<List<Profile>>> {
  /// Search users provider
  ///
  /// Copied from [SearchUsers].
  const SearchUsersFamily();

  /// Search users provider
  ///
  /// Copied from [SearchUsers].
  SearchUsersProvider call(
    String query,
  ) {
    return SearchUsersProvider(
      query,
    );
  }

  @override
  SearchUsersProvider getProviderOverride(
    covariant SearchUsersProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'searchUsersProvider';
}

/// Search users provider
///
/// Copied from [SearchUsers].
class SearchUsersProvider
    extends AutoDisposeAsyncNotifierProviderImpl<SearchUsers, List<Profile>> {
  /// Search users provider
  ///
  /// Copied from [SearchUsers].
  SearchUsersProvider(
    String query,
  ) : this._internal(
          () => SearchUsers()..query = query,
          from: searchUsersProvider,
          name: r'searchUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchUsersHash,
          dependencies: SearchUsersFamily._dependencies,
          allTransitiveDependencies:
              SearchUsersFamily._allTransitiveDependencies,
          query: query,
        );

  SearchUsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  FutureOr<List<Profile>> runNotifierBuild(
    covariant SearchUsers notifier,
  ) {
    return notifier.build(
      query,
    );
  }

  @override
  Override overrideWith(SearchUsers Function() create) {
    return ProviderOverride(
      origin: this,
      override: SearchUsersProvider._internal(
        () => create()..query = query,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SearchUsers, List<Profile>>
      createElement() {
    return _SearchUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchUsersProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchUsersRef on AutoDisposeAsyncNotifierProviderRef<List<Profile>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchUsersProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SearchUsers, List<Profile>>
    with SearchUsersRef {
  _SearchUsersProviderElement(super.provider);

  @override
  String get query => (origin as SearchUsersProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
