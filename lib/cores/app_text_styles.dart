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

  static TextStyle display1({Color color = AppColors.textPrimary}) =>
      _baseStyle(64, FontWeight.bold, color);

  // Headings
  static TextStyle heading1({Color color = AppColors.textPrimary}) =>
      _baseStyle(56, FontWeight.bold, color);

  static TextStyle heading2({Color color = AppColors.textPrimary}) =>
      _baseStyle(48, FontWeight.bold, color);

  static TextStyle heading3({Color color = AppColors.textPrimary}) =>
      _baseStyle(32, FontWeight.bold, color);

  static TextStyle heading4({Color color = AppColors.textPrimary}) =>
      _baseStyle(24, FontWeight.bold, color);

  static TextStyle heading4Uppercase({Color color = AppColors.textPrimary}) =>
      _baseStyle(14, FontWeight.bold, color, letterSpacing: 1.0);

  // Paragraph
  static TextStyle paragraph1({Color color = AppColors.textPrimary}) =>
      _baseStyle(15, FontWeight.normal, color, height: 1.5);

  // Components
  static TextStyle button({Color color = Colors.white}) =>
      _baseStyle(16, FontWeight.bold, color);

  static TextStyle hyperlink({Color color = AppColors.textLink}) => _baseStyle(
    16,
    FontWeight.w600,
    color,
    decoration: TextDecoration.underline,
  );
}
