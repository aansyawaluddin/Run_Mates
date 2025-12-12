import 'package:flutter/material.dart';

class AppShadows {
  // Drop Shadow: X:0, Y:4, Blur:20, Opacity: 20%
  static List<BoxShadow> dropShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.20),
      offset: const Offset(0, 4),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  // Card Shadow (Shadow 2): X:0, Y:4, Blur:4, Opacity: 25%
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      offset: const Offset(0, 4),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  // Shadow kecil (paling bawah di gambar): X:0, Y:2, Blur:4, Opacity: 10%
  static List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.10),
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
}
