import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:myapp/auth/presentation/screens/login_screen.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await Supabase.initialize(
    url: 'https://umtylbrsztdpaeatxpku.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVtdHlsYnJzenRkcGFlYXR4cGt1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzAzODQyOTgsImV4cCI6MjA0NTk2MDI5OH0.RCkG0YKtKW7OTaOJc0MNgFTjud99EriqsOuAHYiH0os',
  );
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Everyday',
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.neonGreen,
          brightness: Brightness.dark,
        ),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.neonGreen,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const LoginScreen(),
    );
  }
}
