import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Small delay to show loading animation
    await Future.delayed(const Duration(milliseconds: 1000));

    // Use the middleware to check authentication and get redirect route
    final redirectRoute = checkAuthAndRedirect();

    if (mounted) {
      // Navigate to the appropriate route based on auth status
      context.go(redirectRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // ✅ ครอบทั้งหมด
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔥 รูป (จะอยู่กลางจริง)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/L.png',
                width: 140,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // 🔄 โหลด
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),

                // ✨ progressive dots
                LoadingAnimationWidget.progressiveDots(
                  color: Colors.black,
                  size: 50,
                ),

                const SizedBox(height: 12),

                const Text(
                  "กำลังโหลด...",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
