import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String fontFamily = 'Outfit';

  static TextStyle _baseStyle(
    double size,
    FontWeight weight,
    Color color, {
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  // Display
  static TextStyle display1({
    Color color = AppColors.textPrimary,
    FontWeight weight = FontWeight.bold,
  }) => _baseStyle(64, weight, color);

  // Headings
  static TextStyle heading1({
    Color color = AppColors.textPrimary,
    FontWeight weight = FontWeight.bold,
  }) => _baseStyle(56, weight, color);

  static TextStyle heading2({
    Color color = AppColors.textPrimary,
    FontWeight weight = FontWeight.bold,
  }) => _baseStyle(48, weight, color);

  static TextStyle heading3({
    Color color = AppColors.textPrimary,
    FontWeight weight = FontWeight.bold,
  }) => _baseStyle(32, weight, color);

  static TextStyle heading4({
    Color color = AppColors.textPrimary,
    FontWeight weight = FontWeight.bold,
  }) => _baseStyle(24, weight, color);

  static TextStyle heading4Uppercase({
    Color color = AppColors.textPrimary,
    FontWeight weight = FontWeight.bold,
  }) => _baseStyle(14, weight, color);

  // Paragraph
  static TextStyle paragraph1({
    Color color = AppColors.textPrimary,
    FontWeight weight = FontWeight.normal,
  }) => _baseStyle(17, weight, color, height: 1.5);

  // Components
  static TextStyle button({
    Color color = Colors.white,
    FontWeight weight = FontWeight.bold,
  }) => _baseStyle(20, weight, color);

  static TextStyle hyperlink({
    Color color = AppColors.textLink,
    FontWeight weight = FontWeight.w600, // SemiBold
  }) => _baseStyle(16, weight, color, decoration: TextDecoration.underline);
}
