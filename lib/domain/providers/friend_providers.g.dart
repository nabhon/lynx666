// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$friendsListHash() => r'b7008b82014fd9f9df3759e23ee50a35d96562ce';

/// User's friends list provider
///
/// Copied from [FriendsList].
@ProviderFor(FriendsList)
final friendsListProvider =
    AutoDisposeAsyncNotifierProvider<FriendsList, List<Friend>>.internal(
  FriendsList.new,
  name: r'friendsListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$friendsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FriendsList = AutoDisposeAsyncNotifier<List<Friend>>;
String _$friendRequestsHash() => r'3cfc33ddfcd8a4b620dd6164729f842eb13dba73';

/// Friend requests provider
///
/// Copied from [FriendRequests].
@ProviderFor(FriendRequests)
final friendRequestsProvider = AutoDisposeAsyncNotifierProvider<FriendRequests,
    List<FriendRequest>>.internal(
  FriendRequests.new,
  name: r'friendRequestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$friendRequestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FriendRequests = AutoDisposeAsyncNotifier<List<FriendRequest>>;
String _$friendsLeaderboardHash() =>
    r'482a71426263c6d406a4282ae7977e2b53aed082';

/// Friends leaderboard provider
///
/// Copied from [FriendsLeaderboard].
@ProviderFor(FriendsLeaderboard)
final friendsLeaderboardProvider = AutoDisposeAsyncNotifierProvider<
    FriendsLeaderboard, List<LeaderboardEntry>>.internal(
  FriendsLeaderboard.new,
  name: r'friendsLeaderboardProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$friendsLeaderboardHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FriendsLeaderboard = AutoDisposeAsyncNotifier<List<LeaderboardEntry>>;
String _$areFriendsHash() => r'0cb752bb93b44eb4136ac297ef7d0be9083c6762';

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

abstract class _$AreFriends extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final String friendId;

  FutureOr<bool> build(
    String friendId,
  );
}

/// Check if two users are friends
///
/// Copied from [AreFriends].
@ProviderFor(AreFriends)
const areFriendsProvider = AreFriendsFamily();

/// Check if two users are friends
///
/// Copied from [AreFriends].
class AreFriendsFamily extends Family<AsyncValue<bool>> {
  /// Check if two users are friends
  ///
  /// Copied from [AreFriends].
  const AreFriendsFamily();

  /// Check if two users are friends
  ///
  /// Copied from [AreFriends].
  AreFriendsProvider call(
    String friendId,
  ) {
    return AreFriendsProvider(
      friendId,
    );
  }

  @override
  AreFriendsProvider getProviderOverride(
    covariant AreFriendsProvider provider,
  ) {
    return call(
      provider.friendId,
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
  String? get name => r'areFriendsProvider';
}

/// Check if two users are friends
///
/// Copied from [AreFriends].
class AreFriendsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<AreFriends, bool> {
  /// Check if two users are friends
  ///
  /// Copied from [AreFriends].
  AreFriendsProvider(
    String friendId,
  ) : this._internal(
          () => AreFriends()..friendId = friendId,
          from: areFriendsProvider,
          name: r'areFriendsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$areFriendsHash,
          dependencies: AreFriendsFamily._dependencies,
          allTransitiveDependencies:
              AreFriendsFamily._allTransitiveDependencies,
          friendId: friendId,
        );

  AreFriendsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.friendId,
  }) : super.internal();

  final String friendId;

  @override
  FutureOr<bool> runNotifierBuild(
    covariant AreFriends notifier,
  ) {
    return notifier.build(
      friendId,
    );
  }

  @override
  Override overrideWith(AreFriends Function() create) {
    return ProviderOverride(
      origin: this,
      override: AreFriendsProvider._internal(
        () => create()..friendId = friendId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        friendId: friendId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AreFriends, bool> createElement() {
    return _AreFriendsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AreFriendsProvider && other.friendId == friendId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, friendId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AreFriendsRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `friendId` of this provider.
  String get friendId;
}

class _AreFriendsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AreFriends, bool>
    with AreFriendsRef {
  _AreFriendsProviderElement(super.provider);

  @override
  String get friendId => (origin as AreFriendsProvider).friendId;
}

String _$friendActionsHash() => r'b499a8f9b865dc26ba60d0343622dd31dc9aaa48';

/// Friend actions provider
///
/// Copied from [FriendActions].
@ProviderFor(FriendActions)
final friendActionsProvider =
    AutoDisposeNotifierProvider<FriendActions, bool>.internal(
  FriendActions.new,
  name: r'friendActionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$friendActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FriendActions = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
