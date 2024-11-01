
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/auth/presentation/providers/auth_provider.dart';
import 'package:myapp/auth/presentation/screens/login_screen.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:myapp/everyday/presentation/screens/home_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
      home: ref.read(authProvider).isAuthenticated
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}
