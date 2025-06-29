import 'package:flutter/material.dart';
import 'constants.dart';

/// アプリのテーマ設定
class AppTheme {
  // プライバシーコンストラクタ
  AppTheme._();

  /// ライトテーマ
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(AppConstants.kPrimary),
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: Typography.blackMountainView,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.kBorderRadius8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.kSpacing24,
            vertical: AppConstants.kSpacing12,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.kBorderRadius8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.kSpacing24,
            vertical: AppConstants.kSpacing12,
          ),
        ),
      ),
    );
  }

  /// ダークテーマ
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(AppConstants.kPrimary),
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: Typography.whiteMountainView,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.kBorderRadius8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.kSpacing24,
            vertical: AppConstants.kSpacing12,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.kBorderRadius8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.kSpacing24,
            vertical: AppConstants.kSpacing12,
          ),
        ),
      ),
    );
  }
}
