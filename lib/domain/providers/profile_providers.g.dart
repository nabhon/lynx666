// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userProfileHash() => r'9aeb154ff20061b0d6b0c2ca31eaa753b40d51e7';

/// User profile provider - fetches current user's profile
///
/// Copied from [UserProfile].
@ProviderFor(UserProfile)
final userProfileProvider =
    AutoDisposeAsyncNotifierProvider<UserProfile, Profile?>.internal(
  UserProfile.new,
  name: r'userProfileProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserProfile = AutoDisposeAsyncNotifier<Profile?>;
String _$onboardingStatusHash() => r'b81ea42281643d442a42727d326c62606c7ccc56';

/// Onboarding status provider
///
/// Copied from [OnboardingStatus].
@ProviderFor(OnboardingStatus)
final onboardingStatusProvider =
    AutoDisposeAsyncNotifierProvider<OnboardingStatus, bool>.internal(
  OnboardingStatus.new,
  name: r'onboardingStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$onboardingStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OnboardingStatus = AutoDisposeAsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
