import 'package:flutter/material.dart';
import 'package:runmates/cores/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color selectedColor;
  final Color backgroundColor;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.selectedColor = AppColors.primary,
    this.backgroundColor = AppColors.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            index: 0,
            label: "Home",
          ),
          _buildNavItem(
            icon: Icons.list_alt_rounded,
            activeIcon: Icons.list_alt_rounded,
            index: 1,
            label: "Program",
          ),
          _buildNavItem(
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person,
            index: 2,
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required int index,
    required String label,
    double yOffset = 0.0,
    double iconSize = 30.0,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 60,
        width: 60,
        alignment: Alignment.center,
        child: Transform.translate(
          offset: Offset(0, yOffset),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: iconSize,
                color: isSelected
                    ? selectedColor
                    : const Color(0XFF1A1A1A).withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
