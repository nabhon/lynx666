# 📘 How to Create a New Page - Simple Guide

This guide shows you how to add a new page/screen to the app. Follow these steps for every new feature.

---

## 📁 Folder Structure Overview

```
lib/
├── domain/
│   ├── entities/          # Data models (what data looks like)
│   └── providers/         # State management (Riverpod)
│
├── data/
│   └── repositories/      # Fetch data from Supabase
│
└── presentation/
    ├── screens/           # Page UI
    │   └── your_page/
    │       ├── your_page_screen.dart
    │       └── widgets/
    └── widgets/           # Reusable components
```

---

## 🎯 Example: Creating a "Profile Page"

We'll create a page that shows user profile information.

---

## Step 1: Create Entity (Data Model)

**File:** `lib/domain/entities/profile.dart`

```dart
class Profile {
  final String id;
  final String username;
  final String? avatarKey;
  final double balance;

  Profile({
    required this.id,
    required this.username,
    this.avatarKey,
    required this.balance,
  });

  // Convert database row to Dart object
  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as String,
      username: map['username'] as String,
      avatarKey: map['avatar_key'] as String?,
      balance: (map['balance'] as num).toDouble(),
    );
  }
}
```

**What is this?**
- A plain Dart class that describes your data
- No Flutter, no Supabase - just pure data
- `fromMap()` converts database rows to Dart objects

---

## Step 2: Create Repository (Fetch Data)

**File:** `lib/data/repositories/profile_repository.dart`

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/profile.dart';

class ProfileRepository {
  final SupabaseClient supabase;

  ProfileRepository(this.supabase);

  // Get user profile by ID
  Future<Profile> getProfile(String userId) async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    if (response.error != null) {
      throw Exception('Failed to load profile: ${response.error!.message}');
    }

    return Profile.fromMap(response.data as Map<String, dynamic>);
  }

  // Update user profile
  Future<void> updateProfile(String userId, {String? username}) async {
    final response = await supabase
        .from('profiles')
        .update({'username': username})
        .eq('id', userId);

    if (response.error != null) {
      throw Exception('Failed to update: ${response.error!.message}');
    }
  }
}
```

**What is this?**
- Fetches data from Supabase
- Handles errors
- Returns entities (not raw JSON)
- **One job:** Get data in, get data out

---

## Step 3: Create Provider (State Management)

**File:** `lib/domain/providers/profile_providers.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/profile_repository.dart';
import '../entities/profile.dart';

// 1. Provide the repository (so other providers can use it)
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(Supabase.instance.client);
});

// 2. Fetch profile data (auto-refreshes when user changes)
final profileProvider = FutureProvider<Profile>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  final user = Supabase.instance.client.currentUser;
  
  if (user == null) {
    throw Exception('User not logged in');
  }
  
  return repository.getProfile(user.id);
});

// 3. Notifier for actions (like refresh, update)
class ProfileNotifier extends AsyncNotifier<Profile> {
  @override
  Future<Profile> build() async {
    final repository = ref.read(profileRepositoryProvider);
    final user = Supabase.instance.client.currentUser!;
    return repository.getProfile(user.id);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  Future<void> updateUsername(String newUsername) async {
    final repository = ref.read(profileRepositoryProvider);
    final user = Supabase.instance.client.currentUser!;
    
    await repository.updateProfile(user.id, username: newUsername);
    await refresh();  // Reload data after update
  }
}

final profileNotifierProvider = AsyncNotifierProvider<ProfileNotifier, Profile>(() {
  return ProfileNotifier();
});
```

**What is this?**
- Manages **state** (loading, error, data)
- UI watches this, not the repository
- `FutureProvider` = auto-fetches data
- `AsyncNotifier` = for actions (refresh, update)

---

## Step 4: Create Screen (Page UI)

**File:** `lib/presentation/screens/profile/profile_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/providers/profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider - rebuilds when state changes
    final profileAsync = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(profileNotifierProvider.notifier).refresh(),
          ),
        ],
      ),
      
      // Handle 3 states: loading, error, data
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(profileNotifierProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        
        data: (profile) => RefreshIndicator(
          onRefresh: () => ref.read(profileNotifierProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Avatar
              CircleAvatar(
                radius: 50,
                child: Text(profile.username[0].toUpperCase()),
              ),
              const SizedBox(height: 16),
              
              // Username
              Text(
                profile.username,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              // Balance
              Text(
                '\$${profile.balance.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, color: Colors.green),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**What is this?**
- The actual page users see
- **Does NOT fetch data** - just watches provider
- `.when()` handles loading/error/data automatically
- Keep UI logic here, business logic in provider

---

## Step 5: Add Route (Navigation)

**File:** `lib/router.dart`

```dart
import 'package:go_router/go_router.dart';
import 'presentation/screens/profile/profile_screen.dart';

final router = GoRouter(
  routes: [
    // ... existing routes ...
    
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
```

**Navigate to page:**
```dart
context.goNamed('profile');  // Go to profile
// or
context.pushNamed('profile');  // Push onto stack
```

---

## 📋 Quick Checklist

For every new page, you need:

| File | Purpose | Required? |
|------|---------|-----------|
| `domain/entities/your_data.dart` | Data model | ✅ Yes |
| `data/repositories/your_repository.dart` | Fetch from Supabase | ✅ Yes |
| `domain/providers/your_providers.dart` | State management | ✅ Yes |
| `presentation/screens/your_page/your_page_screen.dart` | Page UI | ✅ Yes |
| `presentation/screens/your_page/widgets/` | Page components | Optional |
| Update `router.dart` | Add navigation | ✅ Yes |

---

## 🔑 Key Concepts

### 1. **Data Flow** (One Way)

```
Supabase → Repository → Provider → Screen → Widget
   ↓           ↓           ↓         ↓        ↓
  Raw JSON → Entity → State → UI → Display
```

### 2. **State States** (Always 3)

```dart
loading: () => CircularProgressIndicator()
error: (e, _) => Text('Error: $e')
data: (data) => YourContent(data)
```

### 3. **Watch vs Read**

```dart
// WATCH - rebuilds widget when state changes
final data = ref.watch(provider);

// READ - get value without rebuilding (for buttons/actions)
ref.read(provider.notifier).refresh();
```

### 4. **Provider Types**

| Type | Use When |
|------|----------|
| `Provider<T>` | Simple value (no async) |
| `FutureProvider<T>` | Auto-fetch async data |
| `StreamProvider<T>` | Listen to stream |
| `AsyncNotifierProvider` | Need actions (refresh, update) |

---

## 🎨 Simple Template

Copy this for your next page:

### Entity
```dart
class YourEntity {
  final String id;
  final String name;
  
  YourEntity({required this.id, required this.name});
  
  factory YourEntity.fromMap(Map<String, dynamic> map) {
    return YourEntity(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }
}
```

### Repository
```dart
class YourRepository {
  final SupabaseClient supabase;
  YourRepository(this.supabase);
  
  Future<List<YourEntity>> getAll() async {
    final response = await supabase.from('your_table').select();
    if (response.error != null) throw Exception(response.error!.message);
    return (response.data as List).map((e) => YourEntity.fromMap(e)).toList();
  }
}
```

### Provider
```dart
final yourRepositoryProvider = Provider((ref) => YourRepository(Supabase.instance.client));

final yourProvider = FutureProvider<List<YourEntity>>((ref) async {
  return ref.watch(yourRepositoryProvider).getAll();
});
```

### Screen
```dart
class YourScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(yourProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Your Page')),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Error: $e'),
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, i) => Text(data[i].name),
        ),
      ),
    );
  }
}
```

---

## ❓ Common Questions

**Q: Do I need a repository for simple queries?**  
A: Yes. It keeps your code organized. Even 1-line queries go in repository.

**Q: Can I skip the entity and use Map?**  
A: Don't. Entities give you type safety and autocomplete.

**Q: When do I use AsyncNotifier vs FutureProvider?**  
A: Use `FutureProvider` for simple fetch. Use `AsyncNotifier` if you need refresh/update actions.

**Q: Where do I put widgets used only on one screen?**  
A: Inside that screen's folder: `screens/your_page/widgets/`

**Q: Where do I put widgets used on multiple screens?**  
A: In `presentation/widgets/` at the root

---

## 🚀 Next Steps

1. Pick a page to build
2. Follow the 5 steps above
3. Run `flutter analyze` to check for errors
4. Test on device/emulator

**Need help?** Check existing pages (Leaderboard, Home) for reference!
