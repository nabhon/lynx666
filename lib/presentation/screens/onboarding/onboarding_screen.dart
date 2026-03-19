import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/providers/profile_providers.dart';
import '../../../../domain/providers/auth_providers.dart';

// TODO: Add auth check here or in middleware when login page is complete
// User should be redirected to login if not authenticated before accessing this screen

class UsernameSetupScreen extends ConsumerStatefulWidget {
  const UsernameSetupScreen({super.key});

  @override
  ConsumerState<UsernameSetupScreen> createState() => _UsernameSetupScreenState();
}

class _UsernameSetupScreenState extends ConsumerState<UsernameSetupScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Validate username format
  bool _isValidUsername(String username) {
    // Only letters, numbers, and underscore, 3-20 characters
    final regex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
    return regex.hasMatch(username);
  }

  /// Handle username submission
  Future<void> _submitUsername() async {
    final username = _controller.text.trim();

    // Validate input
    if (username.isEmpty) {
      setState(() => _error = 'Username is required');
      return;
    }

    if (!_isValidUsername(username)) {
      setState(() => _error = 'Username must be 3-20 characters (letters, numbers, underscore only)');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Complete onboarding with username
      await ref.read(userProfileProvider.notifier).completeOnboarding(
        username: username,
        avatarKey: 'default_avatar', // TODO: Replace with actual avatar logic
      );

      // Navigate to home screen (replace with your actual route)
      if (mounted) {
        // TODO: Replace with your actual navigation logic
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// 🔤 Title
              const Text(
                "Set your username",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 40),

              /// 👤 Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFFF8400),
                        width: 4,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xFFEFEFEF),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  /// ✏️ Edit Icon
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF8400),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              /// ✍️ Input
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: _error != null ? Colors.red : const Color(0xFFFF8400),
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    prefixText: "@ ",
                    prefixStyle: TextStyle(
                      color: Color(0xFFFF8400),
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: "username",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  onChanged: (_) {
                    if (_error != null) setState(() => _error = null);
                  },
                ),
              ),

              const SizedBox(height: 10),

              /// ℹ️ Helper
              Text(
                "Only letters, numbers, and underscore",
                style: TextStyle(
                  fontSize: 12,
                  color: _error != null ? Colors.red : Colors.grey,
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],

              const Spacer(),

              /// 🚀 Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitUsername,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8400),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}