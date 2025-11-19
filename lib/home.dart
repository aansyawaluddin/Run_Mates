import 'package:flutter/material.dart';
import 'package:runmates/component/navbar.dart';
import 'package:runmates/page/main/home.dart';
import 'package:runmates/page/main/program.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ProgramPage(),
    // ProfilePage(), // buat placeholder jika belum ada
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTapNav(int index) {
    // saat user tap bottom nav -> pindah page dengan animasi
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    // saat user swipe page -> update bottom nav
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // jika tiap page punya appbar sendiri, gunakan body full; atau gunakan appbar global
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        // Kalau mau non-aktifkan swipe dan hanya pakai bottom nav:
        // physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTapNav,
        // kamu bisa override warna kalau mau:
        // selectedColor: const Color(0xFFFF5050),
        // backgroundColor: Colors.white,
      ),
    );
  }
}
