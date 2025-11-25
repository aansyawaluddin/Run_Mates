import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color selectedColor;
  final Color backgroundColor;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.selectedColor = const Color(0xFFE53935),
    this.backgroundColor = const Color(0xFFFAFAFA),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Shadow lebih halus
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: backgroundColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: selectedColor,
          unselectedItemColor: const Color(0XFF1A1A1A).withOpacity(0.5),
          onTap: onTap,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 30,
                color: currentIndex == 0 ? selectedColor : null,
              ),
              activeIcon: Icon(Icons.home, size: 30, color: selectedColor),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list_alt_rounded,
                size: 30,
                color: currentIndex == 1 ? selectedColor : null,
              ),
              label: 'Program',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline_rounded,
                size: 30,
                color: currentIndex == 2 ? selectedColor : null,
              ),
              activeIcon: Icon(Icons.person, size: 30, color: selectedColor),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
