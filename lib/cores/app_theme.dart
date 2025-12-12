import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // Tema Terang (Light Mode)
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgLight,
      fontFamily: 'Swift',

      // Mengatur Color Scheme modern
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        background: AppColors.bgLight,
        onBackground: AppColors.textPrimary,
        surface: AppColors.cardLight,
        onSurface: AppColors.textPrimary,
      ),

      // Mengatur Text Theme Global
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.display1,
        headlineLarge: AppTextStyles.heading1,
        headlineMedium: AppTextStyles.heading2,
        headlineSmall: AppTextStyles.heading3,
        titleMedium: AppTextStyles.heading4,
        bodyLarge: AppTextStyles.paragraph1,
      ),

      // Mengatur gaya Button default
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Asumsi radius
          ),
        ),
      ),
    );
  }

  // Tema Gelap (Dark Mode)
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgDark,
      fontFamily: 'Swift',

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        background: AppColors.bgDark,
        onBackground: AppColors.textSecondary,
        surface: AppColors.cardDark,
        onSurface: AppColors.textSecondary,
      ),

      // Sesuaikan warna teks menjadi putih untuk dark mode
      textTheme: const TextTheme(
        displayLarge: AppTextStyles
            .display1, // Perlu override warna ke putih manual jika mau
        bodyLarge: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
