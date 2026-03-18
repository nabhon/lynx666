# Data Layer Integration Guide

This guide explains how to use the data layer (entities and models) with Riverpod providers and presentation layer views.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Using Entities](#using-entities)
3. [Creating Repositories](#creating-repositories)
4. [Creating Riverpod Providers](#creating-riverpod-providers)
5. [Using Data in Views](#using-data-in-views)
6. [Complete Example: User Profile Flow](#complete-example-user-profile-flow)

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Screens   │  │   Widgets   │  │    Providers (UI)   │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
└─────────┼────────────────┼────────────────────┼─────────────┘
          │                │                    │
          ▼                ▼                    ▼
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Entities   │  │  Providers  │  │   Repository Interfaces │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
└─────────┼────────────────┼────────────────────┼─────────────┘
          │                │                    │
          ▼                ▼                    ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Models    │  │ Repositories│  │   Data Sources      │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## Using Entities

Entities are pure Dart classes that represent your business objects. They have no framework dependencies.

### Example: Profile Entity

```dart
import 'package:lynx_lottery/domain/entities/entities.dart';

// Create an entity directly
final profile = Profile(
  id: 'user-123',
  email: 'user@example.com',
  username: 'JohnDoe',
  balance: 1000.0,
  createdAt: DateTime.now(),
);

// Access entity properties
print(profile.username);  // 'JohnDoe'
print(profile.isActive);  // true
```

---

## Creating Repositories

Repositories handle data operations and convert between models and entities.

### Example: Profile Repository

```dart
// lib/data/repositories/profile_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';
import '../../domain/entities/entities.dart';

abstract class IProfileRepository {
  Future<Profile?> getProfile(String userId);
  Future<Profile> createProfile(Profile profile);
  Future<Profile> updateProfile(Profile profile);
  Future<void> deleteProfile(String userId);
}

class ProfileRepository implements IProfileRepository {
  final SupabaseClient _supabase;

  ProfileRepository({required SupabaseClient supabase})
      : _supabase = supabase;

  @override
  Future<Profile?> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .is_('deleted_at', null)
          .single();

      if (response == null) return null;

      // Convert model to entity
      final model = ProfileModel.fromSupabase(response);
      return model.toEntity();
    } catch (e) {
      // Handle error
      return null;
    }
  }

  @override
  Future<Profile> createProfile(Profile profile) async {
    // Convert entity to model for database insertion
    final model = ProfileModel.fromEntity(profile);
    
    final response = await _supabase
        .from('profiles')
        .insert(model.toSupabase())
        .select()
        .single();

    return ProfileModel.fromSupabase(response).toEntity();
  }

  @override
  Future<Profile> updateProfile(Profile profile) async {
    final model = ProfileModel.fromEntity(profile);
    
    final response = await _supabase
        .from('profiles')
        .update(model.toSupabase())
        .eq('id', profile.id)
        .select()
        .single();

    return ProfileModel.fromSupabase(response).toEntity();
  }

  @override
  Future<void> deleteProfile(String userId) async {
    // Soft delete
    await _supabase
        .from('profiles')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', userId);
  }
}
```

---

## Creating Riverpod Providers

### Step 1: Create Repository Provider

```dart
// lib/domain/providers/profile_repository_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/profile_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ProfileRepository(supabase: supabase);
});
```

### Step 2: Create Async State Provider

```dart
// lib/domain/providers/profile_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/entities.dart';
import 'profile_repository_provider.dart';

part 'profile_provider.g.dart';

@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<Profile?> build() async {
    // Get current user ID from auth state
    final authState = ref.watch(authStateProvider);
    
    return authState.when(
      data: (user) {
        if (user == null) return Future.value(null);
        return ref.watch(profileRepositoryProvider).getProfile(user.id);
      },
      loading: () => Future.value(null),
      error: (_, __) => Future.value(null),
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> updateUsername(String newUsername) async {
    final profile = state.value;
    if (profile == null) return;

    final updatedProfile = profile.copyWith(username: newUsername);
    await ref.read(profileRepositoryProvider).updateProfile(updatedProfile);
    ref.invalidateSelf();
  }
}
```

### Step 3: Create Auth State Provider

```dart
// lib/domain/providers/auth_state_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_repository_provider.dart';

part 'auth_state_provider.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  Future<User?> build() async {
    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      ref.invalidateSelf();
    });

    return Supabase.instance.client.auth.currentUser;
  }

  Future<void> signIn(String email, String password) async {
    await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    ref.invalidateSelf();
  }

  Future<void> signUp(String email, String password) async {
    await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );
    ref.invalidateSelf();
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    ref.invalidateSelf();
  }
}
```

---

## Using Data in Views

### Example: Profile Screen

```dart
// lib/presentation/screens/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/providers/profile_provider.dart';
import '../../../domain/providers/auth_state_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state
    final authState = ref.watch(authStateProvider);
    
    // Watch profile data
    final profileState = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: profileState.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profile.avatarKey != null
                      ? NetworkImage(profile.avatarKey!)
                      : null,
                  child: profile.avatarKey == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(height: 16),
                
                // Username
                Text(
                  profile.username ?? 'No username',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                
                // Email
                Text(
                  profile.email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                
                // Balance
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.account_balance_wallet),
                    title: const Text('Balance'),
                    trailing: Text(
                      '\$${profile.balance.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Status
                Chip(
                  label: Text(profile.status.name.toUpperCase()),
                  backgroundColor: profile.isActive
                      ? Colors.green
                      : Colors.grey,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
```

### Example: Home Screen with Profile Header

```dart
// lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/providers/profile_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          // Profile Header Widget
          profile.when(
            data: (data) => ProfileHeaderWidget(profile: data),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: const Center(
        child: Text('Home Content'),
      ),
    );
  }
}

// Reusable Profile Header Widget
class ProfileHeaderWidget extends StatelessWidget {
  final Profile? profile;

  const ProfileHeaderWidget({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Balance
          Text(
            '\$${profile!.balance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 8),
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: profile!.avatarKey != null
                ? NetworkImage(profile!.avatarKey!)
                : null,
            child: profile!.avatarKey == null
                ? const Icon(Icons.person, size: 20)
                : null,
          ),
        ],
      ),
    );
  }
}
```

---

## Complete Example: User Profile Flow

### 1. Entity Usage in Business Logic

```dart
// lib/domain/usecases/update_profile_usecase.dart

import '../entities/entities.dart';
import '../providers/profile_repository_provider.dart';

class UpdateProfileUsecase {
  final IProfileRepository _repository;

  UpdateProfileUsecase(this._repository);

  Future<Profile> execute({
    required String userId,
    String? username,
    String? avatarKey,
  }) async {
    // Get current profile
    final currentProfile = await _repository.getProfile(userId);
    
    if (currentProfile == null) {
      throw Exception('Profile not found');
    }

    // Create updated profile (immutable)
    final updatedProfile = currentProfile.copyWith(
      username: username ?? currentProfile.username,
      avatarKey: avatarKey ?? currentProfile.avatarKey,
      updatedAt: DateTime.now(),
    );

    // Validate business rules
    if (updatedProfile.username != null &&
        updatedProfile.username!.length < 3) {
      throw Exception('Username must be at least 3 characters');
    }

    // Save updated profile
    return await _repository.updateProfile(updatedProfile);
  }
}
```

### 2. Provider with Use Case

```dart
// lib/domain/providers/onboarding_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:io';
import '../../domain/entities/entities.dart';
import 'profile_repository_provider.dart';
import 'auth_state_provider.dart';

part 'onboarding_provider.g.dart';

@riverpod
class OnboardingState extends _$OnboardingState {
  @override
  Future<bool> build() async {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return true;
    
    final profile = await ref
        .read(profileRepositoryProvider)
        .getProfile(user.id);
    
    return profile?.isOnboardingComplete ?? false;
  }

  Future<void> completeOnboarding({
    required String username,
    required String avatarKey,
  }) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) throw Exception('Not authenticated');

    final profile = await ref.read(profileRepositoryProvider).getProfile(user.id);
    if (profile == null) throw Exception('Profile not found');

    final updatedProfile = profile.copyWith(
      username: username,
      avatarKey: avatarKey,
      isOnboardingComplete: true,
      updatedAt: DateTime.now(),
    );

    await ref.read(profileRepositoryProvider).updateProfile(updatedProfile);
    
    // Refresh state
    ref.invalidateSelf();
  }
}
```

### 3. View Consuming Provider

```dart
// lib/presentation/screens/onboarding/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  String? _avatarKey;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(onboardingStateProvider.notifier).completeOnboarding(
        username: _usernameController.text,
        avatarKey: _avatarKey ?? '',
      );
      
      // Navigate to home
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: onboardingState.when(
        data: (_) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Avatar picker widget
                AvatarPickerWidget(
                  onAvatarSelected: (key) => setState(() => _avatarKey = key),
                ),
                const SizedBox(height: 24),
                
                // Username field
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                  ),
                  validator: (value) {
                    if (value == null || value.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Submit button
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Complete Setup'),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
```

---

## Quick Reference

### Entity → Model Conversion
```dart
final entity = Profile(id: '123', email: 'test@test.com', createdAt: DateTime.now());
final model = ProfileModel.fromEntity(entity);
final json = model.toJson();  // For API/Database
```

### Model → Entity Conversion
```dart
final jsonData = {'id': '123', 'email': 'test@test.com', ...};
final model = ProfileModel.fromJson(jsonData);
final entity = model.toEntity();  // For business logic
```

### Watch Provider in Widget
```dart
final profile = ref.watch(userProfileProvider);
```

### Listen to Provider Changes
```dart
ref.listen(userProfileProvider, (previous, next) {
  next.whenData((data) => print('Profile updated: $data'));
});
```

### Refresh Provider Data
```dart
await ref.read(userProfileProvider.notifier).refresh();
```

---

## Best Practices

1. **Keep entities pure** - No framework dependencies
2. **Use models for serialization** - Handle all JSON/DB mapping in models
3. **Repositories return entities** - Convert models to entities before returning
4. **Providers expose entities** - Presentation layer works with entities
5. **Use copyWith for updates** - Maintain immutability
6. **Handle loading/error states** - Always use `.when()` for async providers
