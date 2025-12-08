import 'package:flutter/material.dart';

/// Provider untuk state aplikasi umum
class AppProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _appLanguage = 'id'; // id untuk Bahasa Indonesia, en untuk English

  bool get isDarkMode => _isDarkMode;
  String get appLanguage => _appLanguage;

  /// Toggle dark mode
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  /// Set dark mode
  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  /// Set bahasa aplikasi
  void setLanguage(String language) {
    _appLanguage = language;
    notifyListeners();
  }
}
