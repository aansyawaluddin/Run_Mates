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
      height: 66,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
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
          selectedFontSize: 0,
          unselectedFontSize: 0,
          selectedItemColor: selectedColor,
          unselectedItemColor: const Color(0XFF1A1A1A).withOpacity(0.5),
          onTap: onTap,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Icon(
                  Icons.home_outlined,
                  size: 30,
                  color: currentIndex == 0 ? selectedColor : null,
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Icon(Icons.home, size: 30, color: selectedColor),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Icon(
                  Icons.list_alt_rounded,
                  size: 30,
                  color: currentIndex == 1 ? selectedColor : null,
                ),
              ),
              label: 'Program',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 30,
                  color: currentIndex == 2 ? selectedColor : null,
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Icon(Icons.person, size: 30, color: selectedColor),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
