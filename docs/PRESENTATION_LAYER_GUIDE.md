# Presentation Layer Guide

This guide explains how to consume Riverpod providers in your Flutter views (screens and widgets), with practical examples including placing bets, displaying user profiles, and more.

---

## Table of Contents

1. [Provider Basics](#provider-basics)
2. [Reading Provider Data](#reading-provider-data)
3. [Handling Async States](#handling-async-states)
4. [Calling Provider Methods](#calling-provider-methods)
5. [Complete Example: Place Bet Screen](#complete-example-place-bet-screen)
6. [Complete Example: Bet History Screen](#complete-example-bet-history-screen)
7. [Complete Example: Home Screen](#complete-example-home-screen)
8. [Best Practices](#best-practices)

---

## Provider Basics

### Types of Providers

```dart
// 1. Simple Provider (provides a value)
final counterProvider = Provider<int>((ref) => 0);

// 2. StateNotifierProvider (for complex state)
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// 3. Riverpod Generated Provider (@riverpod annotation)
@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<Profile?> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return null;
    
    final repository = ref.watch(profileRepositoryProvider);
    return await repository.getProfile(userId);
  }
}
```

---

## Reading Provider Data

### In ConsumerWidget

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/providers.dart';

class ProfileDisplayWidget extends ConsumerWidget {
  const ProfileDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch provider (rebuilds when data changes)
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return const Text('No profile');
        }
        return Text('Welcome, ${profile.username}!');
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### In ConsumerStatefulWidget

```dart
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profileAsync.when(
        data: (profile) => _buildProfileContent(profile),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildProfileContent(Profile? profile) {
    if (profile == null) return const SizedBox();
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Username: ${profile.username}'),
          Text('Email: ${profile.email}'),
          Text('Balance: \$${profile.balance}'),
        ],
      ),
    );
  }
}
```

### In Regular Widget (with ref parameter)

```dart
class BalanceWidget extends StatelessWidget {
  const BalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Use ref.read() for one-time read (no rebuild)
    // Use ref.watch() for reactive updates (rebuilds)
    return Consumer(
      builder: (context, ref, child) {
        final balance = ref.watch(profileBalanceProvider);
        return Text('\$${balance.toStringAsFixed(2)}');
      },
    );
  }
}
```

---

## Handling Async States

### Using .when() for AsyncValue

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final betsAsync = ref.watch(userBetHistoryProvider);

  return betsAsync.when(
    // Data is loaded successfully
    data: (bets) {
      if (bets.isEmpty) {
        return const Center(child: Text('No bets yet'));
      }
      return ListView.builder(
        itemCount: bets.length,
        itemBuilder: (context, index) => BetTile(bet: bets[index]),
      );
    },
    // Data is loading
    loading: () => const Center(child: CircularProgressIndicator()),
    // Error occurred
    error: (error, stack) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error, color: Colors.red),
          Text('Error: $error'),
          TextButton(
            onPressed: () => ref.invalidate(userBetHistoryProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    ),
  );
}
```

### Using .whenData() for transformations

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final username = ref
      .watch(userProfileProvider)
      .whenData((profile) => profile?.username ?? 'Guest')
      .value;

  return Text('Hello, $username!');
}
```

### Using .maybeWhen() for partial handling

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final profile = ref.watch(userProfileProvider);

  return profile.maybeWhen(
    data: (p) => Text(p?.username ?? 'Guest'),
    orElse: () => const Text('Loading...'),
  );
}
```

---

## Calling Provider Methods

### In Event Handlers

```dart
class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    try {
      // Call provider method
      await ref.read(authStateProvider.notifier).signInWithEmailPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Navigate on success
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (e) {
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state for loading indicator
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      body: authState.when(
        data: (_) => Column(
          children: [
            TextField(controller: _emailController),
            TextField(controller: _passwordController, obscureText: true),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Login'),
            ),
          ],
        ),
        loading: () => const CircularProgressIndicator(),
        error: (e, s) => Text('Error: $e'),
      ),
    );
  }
}
```

### With Loading State

```dart
class _PlaceBetState extends ConsumerState<PlaceBetScreen> {
  bool _isPlacingBet = false;

  Future<void> _placeBet() async {
    setState(() => _isPlacingBet = true);

    try {
      final bet = await ref.read(placeBetProvider.notifier).placeBet(
        lotteryDrawId: _selectedDrawId,
        selectedNumbers: _selectedNumbers,
        betAmount: _betAmount,
      );

      if (mounted && bet != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bet placed successfully!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place bet: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPlacingBet = false);
      }
    }
  }
}
```

---

## Complete Example: Place Bet Screen

This example shows how to create a screen for placing bets with number selection and bet amount input.

```dart
// lib/presentation/screens/bet/place_bet_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/providers/providers.dart';
import '../../../domain/entities/entities.dart';

class PlaceBetScreen extends ConsumerStatefulWidget {
  const PlaceBetScreen({super.key});

  @override
  ConsumerState<PlaceBetScreen> createState() => _PlaceBetScreenState();
}

class _PlaceBetScreenState extends ConsumerState<PlaceBetScreen> {
  final List<int> _selectedNumbers = [];
  final _betAmountController = TextEditingController();
  double? _maxBetAmount;
  double? _minBetAmount;

  @override
  void initState() {
    super.initState();
    _loadBetLimits();
  }

  Future<void> _loadBetLimits() async {
    final minBet = await ref.read(minBetAmountProvider.future);
    final maxPercentage = await ref.read(maxBetPercentageProvider.future);
    final balance = ref.read(profileBalanceProvider);

    setState(() {
      _minBetAmount = minBet;
      _maxBetAmount = balance * maxPercentage;
    });
  }

  void _toggleNumber(int number) {
    setState(() {
      if (_selectedNumbers.contains(number)) {
        _selectedNumbers.remove(number);
      } else if (_selectedNumbers.length < 6) {
        _selectedNumbers.add(number);
        _selectedNumbers.sort();
      }
    });
  }

  Future<void> _placeBet() async {
    // Validate numbers
    if (_selectedNumbers.length != 6) {
      _showError('Please select exactly 6 numbers');
      return;
    }

    // Validate bet amount
    final betAmount = double.tryParse(_betAmountController.text);
    if (betAmount == null || betAmount <= 0) {
      _showError('Please enter a valid bet amount');
      return;
    }

    if (_minBetAmount != null && betAmount < _minBetAmount!) {
      _showError('Minimum bet is \$$_minBetAmount');
      return;
    }

    if (_maxBetAmount != null && betAmount > _maxBetAmount!) {
      _showError('Maximum bet is \$${_maxBetAmount!.toStringAsFixed(2)}');
      return;
    }

    // Get next draw ID
    final nextDraw = await ref.read(nextLotteryDrawProvider.future);
    if (nextDraw == null) {
      _showError('No available draws');
      return;
    }

    try {
      // Place the bet
      final bet = await ref.read(placeBetProvider.notifier).placeBet(
        lotteryDrawId: nextDraw.id,
        selectedNumbers: _selectedNumbers,
        betAmount: betAmount,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bet placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(bet);
      }
    } catch (e) {
      _showError('Failed to place bet: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nextDrawAsync = ref.watch(nextLotteryDrawProvider);
    final balance = ref.watch(profileBalanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Bet'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Balance: \$${balance.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Next draw info
            nextDrawAsync.when(
              data: (draw) => _buildDrawInfo(draw),
              loading: () => const CircularProgressIndicator(),
              error: (e, s) => Text('Error loading draw: $e'),
            ),
            const SizedBox(height: 24),

            // Number selection
            Text(
              'Select 6 Numbers',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${_selectedNumbers.length}/6 selected',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            _buildNumberGrid(),
            const SizedBox(height: 24),

            // Selected numbers display
            _buildSelectedNumbersDisplay(),
            const SizedBox(height: 24),

            // Bet amount input
            TextField(
              controller: _betAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Bet Amount',
                prefixText: '\$ ',
                hintText: _minBetAmount?.toString() ?? '1.00',
                helperText: _maxBetAmount != null
                    ? 'Max: \$${_maxBetAmount!.toStringAsFixed(2)}'
                    : null,
              ),
            ),
            const SizedBox(height: 24),

            // Potential win display
            _buildPotentialWinDisplay(),
            const SizedBox(height: 24),

            // Place bet button
            ElevatedButton(
              onPressed: _selectedNumbers.length == 6 ? _placeBet : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Place Bet',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawInfo(LotteryDraw? draw) {
    if (draw == null) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Draw #${draw.drawNumber}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Scheduled: ${_formatDateTime(draw.scheduledTime)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 49,
      itemBuilder: (context, index) {
        final number = index + 1;
        final isSelected = _selectedNumbers.contains(number);

        return GestureDetector(
          onTap: () => _toggleNumber(number),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.amber : Colors.grey[200],
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.orange : Colors.grey,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : Colors.black54,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedNumbersDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 6; i++)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: i < _selectedNumbers.length
                  ? Colors.amber
                  : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: i < _selectedNumbers.length
                  ? Text(
                      _selectedNumbers[i].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  : null,
            ),
          ),
      ],
    );
  }

  Widget _buildPotentialWinDisplay() {
    final betAmount = double.tryParse(_betAmountController.text) ?? 0;
    final potentialWin = betAmount * 1000000; // MATCH_6 multiplier

    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Potential Win (Match 6)',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${potentialWin.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _betAmountController.dispose();
    super.dispose();
  }
}
```

---

## Complete Example: Bet History Screen

This example shows how to display bet history with filtering and pull-to-refresh.

```dart
// lib/presentation/screens/bet/bet_history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/providers/providers.dart';
import '../../../domain/entities/entities.dart';

class BetHistoryScreen extends ConsumerStatefulWidget {
  const BetHistoryScreen({super.key});

  @override
  ConsumerState<BetHistoryScreen> createState() => _BetHistoryScreenState();
}

class _BetHistoryScreenState extends ConsumerState<BetHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  BetStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _selectedFilter = _tabController.index == 0
          ? null
          : _tabController.index == 1
              ? BetStatus.pending
              : _tabController.index == 2
                  ? BetStatus.won
                  : BetStatus.lost;
    });
  }

  @override
  Widget build(BuildContext context) {
    final betsAsync = ref.watch(
      userBetHistoryProvider(filter: _selectedFilter),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bet History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Won'),
            Tab(text: 'Lost'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(
              userBetHistoryProvider(filter: _selectedFilter),
            ),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: betsAsync.when(
        data: (bets) => _buildBetList(bets),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorWidget(error, stack),
      ),
    );
  }

  Widget _buildBetList(List<Bet> bets) {
    if (bets.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No bets found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(userBetHistoryProvider(filter: _selectedFilter).notifier)
            .refresh();
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: bets.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) => BetHistoryTile(bet: bets[index]),
      ),
    );
  }

  Widget _buildErrorWidget(Object error, StackTrace stack) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading bets',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '$error',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.invalidate(
              userBetHistoryProvider(filter: _selectedFilter),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// Bet History Tile Widget
class BetHistoryTile extends StatelessWidget {
  final Bet bet;

  const BetHistoryTile({super.key, required this.bet});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => _showBetDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with draw number and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Draw #${_extractDrawNumber(bet)}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  _buildStatusChip(),
                ],
              ),
              const SizedBox(height: 12),

              // Numbers
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Numbers',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        _buildNumbersRow(bet.selectedNumbers),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (bet.actualWinAmount != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Winning Numbers',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'See details',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Footer with amount and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bet Amount',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '\$${bet.betAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  if (bet.isWon && bet.actualWinAmount != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Won',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '\$${bet.actualWinAmount!.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  if (bet.isLost)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Lost',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '-\$${bet.betAmount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Date
              Text(
                'Placed: ${_formatDateTime(bet.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (bet.status) {
      case BetStatus.pending:
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        label = 'Pending';
        break;
      case BetStatus.won:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        label = 'Won';
        break;
      case BetStatus.lost:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        label = 'Lost';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNumbersRow(List<int> numbers) {
    return Wrap(
      spacing: 4,
      children: numbers
          .map(
            (n) => Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  n.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  String _extractDrawNumber(Bet bet) {
    // In real app, you'd fetch this from the draw
    return '???';
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _showBetDetails(BuildContext context) {
    // Navigate to bet details screen
    showModalBottomSheet(
      context: context,
      builder: (context) => _BetDetailsSheet(bet: bet),
    );
  }
}

// Bet Details Bottom Sheet
class _BetDetailsSheet extends StatelessWidget {
  final Bet bet;

  const _BetDetailsSheet({required this.bet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bet Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text('Status: ${bet.status.name.toUpperCase()}'),
          Text('Bet Amount: \$${bet.betAmount}'),
          if (bet.actualWinAmount != null)
            Text('Won Amount: \$${bet.actualWinAmount}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
```

---

## Complete Example: Home Screen

This example shows how to combine multiple providers in a home screen.

```dart
// lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/providers/providers.dart';
import '../../../domain/entities/entities.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Timer _countdownTimer;

  @override
  void initState() {
    super.initState();
    // Update countdown every second
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        ref.read(lotteryCountdownProvider.notifier).tick();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final nextDrawAsync = ref.watch(nextLotteryDrawProvider);
    final countdown = ref.watch(lotteryCountdownProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lynx666'),
        actions: [
          // Profile header
          profileAsync.when(
            data: (profile) => ProfileHeaderWidget(profile: profile),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.refresh(userProfileProvider.future);
          await ref.refresh(nextLotteryDrawProvider.future);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Countdown card
              nextDrawAsync.when(
                data: (draw) => CountdownCard(
                  draw: draw,
                  countdown: countdown,
                ),
                loading: () => const CircularProgressIndicator(),
                error: (e, s) => Text('Error: $e'),
              ),
              const SizedBox(height: 24),

              // Quick actions
              _buildQuickActions(),
              const SizedBox(height: 24),

              // Recent wins
              const Text(
                'Recent Wins',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildRecentWins(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/place-bet'),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Place Bet'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/bet-history'),
            icon: const Icon(Icons.history),
            label: const Text('History'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentWins() {
    final wonBetsAsync = ref.watch(userWonBetsProvider);

    return wonBetsAsync.when(
      data: (bets) {
        final recentWins = bets.take(5).toList();
        if (recentWins.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'No wins yet. Place your first bet!',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentWins.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) => WinLogTile(bet: recentWins[index]),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
        NavigationDestination(icon: Icon(Icons.history), label: 'History'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onDestinationSelected: (index) {
        switch (index) {
          case 1:
            Navigator.pushNamed(context, '/leaderboard');
            break;
          case 2:
            Navigator.pushNamed(context, '/bet-history');
            break;
          case 3:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
      selectedIndex: 0,
    );
  }
}

// Profile Header Widget
class ProfileHeaderWidget extends StatelessWidget {
  final Profile? profile;

  const ProfileHeaderWidget({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    if (profile == null) return const SizedBox.shrink();

    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/profile'),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${profile!.balance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 20,
              backgroundImage: profile!.avatarKey != null
                  ? NetworkImage(profile!.avatarKey!)
                  : null,
              child: profile!.avatarKey == null
                  ? const Icon(Icons.person)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// Countdown Card Widget
class CountdownCard extends StatelessWidget {
  final LotteryDraw? draw;
  final Duration countdown;

  const CountdownCard({
    super.key,
    this.draw,
    required this.countdown,
  });

  @override
  Widget build(BuildContext context) {
    if (draw == null) return const SizedBox();

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Next Draw #${draw!.drawNumber}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              _formatCountdown(countdown),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Scheduled: ${_formatDateTime(draw!.scheduledTime)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _formatCountdown(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// Win Log Tile Widget
class WinLogTile extends StatelessWidget {
  final Bet bet;

  const WinLogTile({super.key, required this.bet});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: const Icon(Icons.emoji_events, color: Colors.white),
        ),
        title: Text('Won \$${bet.actualWinAmount?.toStringAsFixed(2) ?? '0.00'}'),
        subtitle: Text('Numbers: ${bet.selectedNumbers.join(', ')}'),
        trailing: Text(
          '${bet.createdAt.day}/${bet.createdAt.month}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
```

---

## Best Practices

### 1. Use Consumer Widgets Appropriately

```dart
// ✅ Good: Use ConsumerWidget when you need ref
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(myProvider);
    return Text(data);
  }
}

// ✅ Good: Use Consumer for small parts
Consumer(
  builder: (context, ref, _) {
    final data = ref.watch(myProvider);
    return Text(data);
  },
)

// ❌ Avoid: Using ref in non-Consumer widgets
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This won't work - no ref available
    // final data = ref.watch(myProvider);
    return const Text('Hello');
  }
}
```

### 2. Handle Loading and Error States

```dart
// ✅ Good: Handle all states
data.when(
  data: (d) => Content(data: d),
  loading: () => const CircularProgressIndicator(),
  error: (e, s) => ErrorWidget(message: e.toString()),
)

// ❌ Avoid: Only handling data
data.whenData((d) => Content(data: d)) // Missing loading/error
```

### 3. Invalidate Related Providers

```dart
// ✅ Good: Invalidate related providers after mutation
await ref.read(betRepositoryProvider).placeBet(...);
ref.invalidate(userBetHistoryProvider);
ref.invalidate(profileBalanceProvider);
ref.invalidate(betStatsProvider);

// ❌ Avoid: Not invalidating related data
await ref.read(betRepositoryProvider).placeBet(...);
// Old data still shown
```

### 4. Use Provider Family for Parameterized Data

```dart
// ✅ Good: Use family for parameterized providers
@riverpod
class BetById extends _$BetById {
  @override
  Future<Bet?> build(String betId) async { ... }
}

// Access with parameter
final bet = ref.watch(betByIdProvider(betId));

// ❌ Avoid: Creating separate providers for each case
final bet1Provider = ...
final bet2Provider = ...
```

### 5. Listen to Provider Changes

```dart
// ✅ Good: Listen to changes for side effects
ref.listen(authStateProvider, (previous, next) {
  next.whenData((user) {
    if (user == null) {
      // User logged out
      Navigator.pushNamed(context, '/login');
    }
  });
});
```

---

This guide covers the essential patterns for consuming providers in your Flutter views. Refer to the examples for practical implementations of placing bets, viewing history, and building complete screens.
