// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Auth state notifier provider

@ProviderFor(AuthState)
final authStateProvider = AuthStateProvider._();

/// Auth state notifier provider
final class AuthStateProvider extends $AsyncNotifierProvider<AuthState, User?> {
  /// Auth state notifier provider
  AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  AuthState create() => AuthState();
}

String _$authStateHash() => r'33e4c275b999c9fd41ebc210679e93c0a72c5d93';

/// Auth state notifier provider

abstract class _$AuthState extends $AsyncNotifier<User?> {
  FutureOr<User?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<User?>, User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User?>, User?>,
              AsyncValue<User?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider to check if user is authenticated (sync)

@ProviderFor(IsAuthenticated)
final isAuthenticatedProvider = IsAuthenticatedProvider._();

/// Provider to check if user is authenticated (sync)
final class IsAuthenticatedProvider
    extends $NotifierProvider<IsAuthenticated, bool> {
  /// Provider to check if user is authenticated (sync)
  IsAuthenticatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isAuthenticatedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isAuthenticatedHash();

  @$internal
  @override
  IsAuthenticated create() => IsAuthenticated();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isAuthenticatedHash() => r'bf3fcd5b5c948f3b1c384766d362c58ab2aa2d12';

/// Provider to check if user is authenticated (sync)

abstract class _$IsAuthenticated extends $Notifier<bool> {
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

/// Provider to get current user ID

@ProviderFor(CurrentUserId)
final currentUserIdProvider = CurrentUserIdProvider._();

/// Provider to get current user ID
final class CurrentUserIdProvider
    extends $NotifierProvider<CurrentUserId, String?> {
  /// Provider to get current user ID
  CurrentUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserIdHash();

  @$internal
  @override
  CurrentUserId create() => CurrentUserId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentUserIdHash() => r'd9ad1d33d53debd7e89211902db1d6af74abf833';

/// Provider to get current user ID

abstract class _$CurrentUserId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
