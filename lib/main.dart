import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MathHeroApp());
}

/// マスヒーローアプリのメインクラス
class MathHeroApp extends StatelessWidget {
  const MathHeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'マスヒーロー',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
