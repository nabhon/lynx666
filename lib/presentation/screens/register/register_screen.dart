import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/providers/auth_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _supabase = Supabase.instance.client;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar("กรุณากรอกข้อมูลให้ครบ");
      return;
    }

    if (!email.contains('@')) {
      _showSnackBar("อีเมลต้องมี @");
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar("รหัสผ่านไม่ตรงกัน");
      return;
    }

    try {
      await ref.read(authStateProvider.notifier).signUpWithEmailPassword(
        email: email,
        password: password,
      );

      // ถ้าสำเร็จ insert profile
      final user = _supabase.auth.currentUser;
      if (user != null) {
        await _supabase.from('profiles').insert({
          'id': user.id,
          'email': email,
          'is_onboarding_complete': false,
        });

        _showSnackBar("สมัครสมาชิกสำเร็จ กรุณาเข้าสู่ระบบ");
        if (mounted) {
          context.go('/login');
        }
      } else {
        _showSnackBar("สมัครสมาชิกไม่สำเร็จ กรุณาลองใหม่อีกครั้ง");
      }

    } catch (e) {
      _showSnackBar("อีเมลนี้ถูกใช้งานแล้วหรือข้อมูลไม่ถูกต้อง");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  const Text(
                    "สมัครสมาชิก Lynx666",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "สร้างบัญชีใหม่เพื่อเข้าถึงฟีเจอร์ทั้งหมดของแอป",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 40),

                  /// Email
                  const Text("อีเมล"),
                  const SizedBox(height: 8),

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 16),

                    decoration: InputDecoration(
                      hintText: "กรอกอีเมลของคุณ",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: Color(0xFFFF8400),
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Password
                  const Text("รหัสผ่าน"),
                  const SizedBox(height: 8),

                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(fontSize: 16),

                    decoration: InputDecoration(
                      hintText: "กรอกรหัสผ่านของคุณ",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: Color(0xFFFF8400),
                          width: 2,
                        ),
                      ),

                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Confirm Password
                  const Text("ยืนยันรหัสผ่าน"),
                  const SizedBox(height: 8),

                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: const TextStyle(fontSize: 16),

                    decoration: InputDecoration(
                      hintText: "กรอกรหัสผ่านอีกครั้ง",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: Color(0xFFFF8400),
                          width: 2,
                        ),
                      ),

                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "สมัครสมาชิก",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Login Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("มีบัญชีแล้ว? "),
                      GestureDetector(
                        onTap: () {
                          context.go('/login');
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.login,
                              size: 18,
                              color: Color(0xFFFF8400),
                            ),
                            SizedBox(width: 6),
                            Text(
                              "เข้าสู่ระบบ",
                              style: TextStyle(
                                color: Color(0xFFFF8400),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}