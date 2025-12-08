import 'package:flutter/material.dart';

/// Provider untuk mengelola navigasi halaman utama
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  late PageController _pageController;

  int get currentIndex => _currentIndex;
  PageController get pageController => _pageController;

  NavigationProvider() {
    _pageController = PageController();
  }

  /// Mengubah halaman saat nav bar diklik
  void onTapNav(int index) {
    _currentIndex = index;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  /// Mengubah halaman saat PageView bergeser
  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
