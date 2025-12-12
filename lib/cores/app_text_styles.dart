import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String fontFamily = 'Swift';

  // Display
  static const TextStyle display1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 54,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Headings
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading4Uppercase = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.0, // Uppercase biasanya butuh sedikit spacing
    color: AppColors.textPrimary,
  );

  // Paragraph
  static const TextStyle paragraph1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal, // Regular
    color: AppColors.textPrimary,
    height: 1.5, // Good for readability
  );

  // Components
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white, // Asumsi teks tombol putih di atas primary red
  );

  static const TextStyle hyperlink = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textLink,
    decoration: TextDecoration.underline,
  );
}
