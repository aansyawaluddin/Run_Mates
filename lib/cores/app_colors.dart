import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFFFF5050);

  // Text Colors
  static const Color textPrimary = Color(0xFF160029);
  static const Color textSecondary = Color(0xFFFFFFFF); // Putih untuk dark bg
  static const Color textLink = Color(0xFF00C8C8); // Estimasi dari warna 'Hyperlink' cyan

  // Backgrounds
  static const Color bgLight = Color(0xFFFAFAFA); // Background Color (Light Mode)
  static const Color bgDark = Color(0xFF191919);  // Secondary Background Color (Dark mode)
  
  // Cards / Surfaces
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF212121);
  static const Color neutral = Color(0xFFC5C5C5);

  // Card Backgrounds with Opacity (Helpers)
  static Color elevatedCardBg = const Color(0xFFFFFFFF).withOpacity(0.20);
  static Color subtleCardBg = const Color(0xFFFFFFFF).withOpacity(0.05);
  static Color mutedCardBg = const Color(0xFFC2C2C2).withOpacity(0.20);
}