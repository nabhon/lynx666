import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/supabase_client.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use bundled fonts instead of downloading at runtime
  GoogleFonts.config.allowRuntimeFetching = false;

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Supabase
  await SupabaseInit.initialize();

  runApp(const ProviderScope(child: LynxLotteryApp()));
}

class LynxLotteryApp extends StatelessWidget {
  const LynxLotteryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lynx666',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
