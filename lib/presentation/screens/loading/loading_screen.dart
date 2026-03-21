import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/datasources/supabase_client.dart';

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
    // Small delay to ensure Supabase client is ready
    await Future.delayed(const Duration(milliseconds: 3000));

    // Check authentication status
    final isAuthenticated = SupabaseInit.client.auth.currentSession != null;

    if (mounted) {
      context.go(isAuthenticated ? '/' : '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
