import 'package:flutter/material.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:myapp/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Everyday',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.neonGreen),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
