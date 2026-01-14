import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // TEMA TERANG (LIGHT MODE)
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgLight,
      fontFamily: 'Outfit',
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        background: AppColors.bgLight,
        onBackground: AppColors.textPrimary,
        surface: AppColors.cardLight,
        onSurface: AppColors.textPrimary,
      ),

      textTheme: TextTheme(
        displayLarge: AppTextStyles.display1(),
        headlineLarge: AppTextStyles.heading1(),
        headlineMedium: AppTextStyles.heading2(),
        headlineSmall: AppTextStyles.heading3(),
        titleMedium: AppTextStyles.heading4(),
        titleSmall: AppTextStyles.heading4Uppercase(),
        bodyLarge: AppTextStyles.paragraph1(),
        labelLarge: AppTextStyles.button(),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.button(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // TEMA GELAP (DARK MODE)
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgDark,
      fontFamily: 'Outfit',

      // Color Scheme Dark
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        background: AppColors.bgDark,
        onBackground: AppColors.textSecondary,
        surface: AppColors.cardDark,
        onSurface: AppColors.textSecondary,
      ),

      textTheme: TextTheme(
        displayLarge: AppTextStyles.display1(color: AppColors.textSecondary),
        headlineLarge: AppTextStyles.heading1(color: AppColors.textSecondary),
        headlineMedium: AppTextStyles.heading2(color: AppColors.textSecondary),
        headlineSmall: AppTextStyles.heading3(color: AppColors.textSecondary),
        titleMedium: AppTextStyles.heading4(color: AppColors.textSecondary),
        titleSmall: AppTextStyles.heading4Uppercase(
          color: AppColors.textSecondary,
        ),
        bodyLarge: AppTextStyles.paragraph1(color: AppColors.textSecondary),
        labelLarge: AppTextStyles.button(color: Colors.white),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.button(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
