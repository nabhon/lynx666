// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// User profile provider - fetches current user's profile

@ProviderFor(UserProfile)
final userProfileProvider = UserProfileProvider._();

/// User profile provider - fetches current user's profile
final class UserProfileProvider
    extends $AsyncNotifierProvider<UserProfile, Profile?> {
  /// User profile provider - fetches current user's profile
  UserProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileHash();

  @$internal
  @override
  UserProfile create() => UserProfile();
}

String _$userProfileHash() => r'c59414b321ec023095ef9b3c93e79d19afa922c8';

/// User profile provider - fetches current user's profile

abstract class _$UserProfile extends $AsyncNotifier<Profile?> {
  FutureOr<Profile?> build();
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
    element.handleCreate(ref, build);
  }
}

/// Onboarding status provider

@ProviderFor(OnboardingStatus)
final onboardingStatusProvider = OnboardingStatusProvider._();

/// Onboarding status provider
final class OnboardingStatusProvider
    extends $AsyncNotifierProvider<OnboardingStatus, bool> {
  /// Onboarding status provider
  OnboardingStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingStatusHash();

  @$internal
  @override
  OnboardingStatus create() => OnboardingStatus();
}

String _$onboardingStatusHash() => r'b81ea42281643d442a42727d326c62606c7ccc56';

/// Onboarding status provider

abstract class _$OnboardingStatus extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
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
    element.handleCreate(ref, build);
  }
}

/// Profile balance provider (derived from UserProfile)

@ProviderFor(ProfileBalance)
final profileBalanceProvider = ProfileBalanceProvider._();

/// Profile balance provider (derived from UserProfile)
final class ProfileBalanceProvider
    extends $NotifierProvider<ProfileBalance, double> {
  /// Profile balance provider (derived from UserProfile)
  ProfileBalanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileBalanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileBalanceHash();

  @$internal
  @override
  ProfileBalance create() => ProfileBalance();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$profileBalanceHash() => r'860ad3ee6260ef364042d1aaaeb8a4612552e140';

/// Profile balance provider (derived from UserProfile)

abstract class _$ProfileBalance extends $Notifier<double> {
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

/// Avatar URL provider - transforms avatarKey to public URL (cached)

@ProviderFor(AvatarUrl)
final avatarUrlProvider = AvatarUrlProvider._();

/// Avatar URL provider - transforms avatarKey to public URL (cached)
final class AvatarUrlProvider extends $NotifierProvider<AvatarUrl, String?> {
  /// Avatar URL provider - transforms avatarKey to public URL (cached)
  AvatarUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'avatarUrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$avatarUrlHash();

  @$internal
  @override
  AvatarUrl create() => AvatarUrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$avatarUrlHash() => r'1a22e09a78670250bfe30d3193b8dc85bba3e998';

/// Avatar URL provider - transforms avatarKey to public URL (cached)

abstract class _$AvatarUrl extends $Notifier<String?> {
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
