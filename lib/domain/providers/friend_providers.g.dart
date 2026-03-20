// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// User's friends list provider

@ProviderFor(FriendsList)
final friendsListProvider = FriendsListProvider._();

/// User's friends list provider
final class FriendsListProvider
    extends $AsyncNotifierProvider<FriendsList, List<Friend>> {
  /// User's friends list provider
  FriendsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendsListHash();

  @$internal
  @override
  FriendsList create() => FriendsList();
}

String _$friendsListHash() => r'b7008b82014fd9f9df3759e23ee50a35d96562ce';

/// User's friends list provider

abstract class _$FriendsList extends $AsyncNotifier<List<Friend>> {
  FutureOr<List<Friend>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Friend>>, List<Friend>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Friend>>, List<Friend>>,
              AsyncValue<List<Friend>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Friend requests provider

@ProviderFor(FriendRequests)
final friendRequestsProvider = FriendRequestsProvider._();

/// Friend requests provider
final class FriendRequestsProvider
    extends $AsyncNotifierProvider<FriendRequests, List<FriendRequest>> {
  /// Friend requests provider
  FriendRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendRequestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendRequestsHash();

  @$internal
  @override
  FriendRequests create() => FriendRequests();
}

String _$friendRequestsHash() => r'3cfc33ddfcd8a4b620dd6164729f842eb13dba73';

/// Friend requests provider

abstract class _$FriendRequests extends $AsyncNotifier<List<FriendRequest>> {
  FutureOr<List<FriendRequest>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<FriendRequest>>, List<FriendRequest>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<FriendRequest>>, List<FriendRequest>>,
              AsyncValue<List<FriendRequest>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Friends leaderboard provider

@ProviderFor(FriendsLeaderboard)
final friendsLeaderboardProvider = FriendsLeaderboardProvider._();

/// Friends leaderboard provider
final class FriendsLeaderboardProvider
    extends $AsyncNotifierProvider<FriendsLeaderboard, List<LeaderboardEntry>> {
  /// Friends leaderboard provider
  FriendsLeaderboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendsLeaderboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendsLeaderboardHash();

  @$internal
  @override
  FriendsLeaderboard create() => FriendsLeaderboard();
}

String _$friendsLeaderboardHash() =>
    r'482a71426263c6d406a4282ae7977e2b53aed082';

/// Friends leaderboard provider

abstract class _$FriendsLeaderboard
    extends $AsyncNotifier<List<LeaderboardEntry>> {
  FutureOr<List<LeaderboardEntry>> build();
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
    element.handleCreate(ref, build);
  }
}

/// Check if two users are friends

@ProviderFor(AreFriends)
final areFriendsProvider = AreFriendsFamily._();

/// Check if two users are friends
final class AreFriendsProvider
    extends $AsyncNotifierProvider<AreFriends, bool> {
  /// Check if two users are friends
  AreFriendsProvider._({
    required AreFriendsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'areFriendsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$areFriendsHash();

  @override
  String toString() {
    return r'areFriendsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AreFriends create() => AreFriends();

  @override
  bool operator ==(Object other) {
    return other is AreFriendsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$areFriendsHash() => r'0cb752bb93b44eb4136ac297ef7d0be9083c6762';

/// Check if two users are friends

final class AreFriendsFamily extends $Family
    with
        $ClassFamilyOverride<
          AreFriends,
          AsyncValue<bool>,
          bool,
          FutureOr<bool>,
          String
        > {
  AreFriendsFamily._()
    : super(
        retry: null,
        name: r'areFriendsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Check if two users are friends

  AreFriendsProvider call(String friendId) =>
      AreFriendsProvider._(argument: friendId, from: this);

  @override
  String toString() => r'areFriendsProvider';
}

/// Check if two users are friends

abstract class _$AreFriends extends $AsyncNotifier<bool> {
  late final _$args = ref.$arg as String;
  String get friendId => _$args;

  FutureOr<bool> build(String friendId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// Friend actions provider

@ProviderFor(FriendActions)
final friendActionsProvider = FriendActionsProvider._();

/// Friend actions provider
final class FriendActionsProvider
    extends $NotifierProvider<FriendActions, bool> {
  /// Friend actions provider
  FriendActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendActionsHash();

  @$internal
  @override
  FriendActions create() => FriendActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$friendActionsHash() => r'b499a8f9b865dc26ba60d0343622dd31dc9aaa48';

/// Friend actions provider

abstract class _$FriendActions extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
