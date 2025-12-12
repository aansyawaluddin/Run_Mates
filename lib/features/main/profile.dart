import 'package:flutter/material.dart';
import 'package:runmates/features/auth/login.dart';
import 'package:runmates/features/main/editProfile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0XFFFF5050);
    const Color textColor = Color(0xFF2D2D2D);

    return Scaffold(
      backgroundColor: const Color(0XFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "My Profile",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFE0E0E0),
              ),
              const SizedBox(height: 15),
              const Text(
                "Madison Smith",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "madisons@example.com",
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              const SizedBox(height: 25),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem("75", "Weight (Kg)"),
                    _buildDivider(),
                    _buildStatItem("28", "Years Old"),
                    _buildDivider(),
                    _buildStatItem("1.65", "Height(CM)"),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Menu List
              _buildMenuItem(
                icon: Icons.person,
                text: "Profile",
                color: primaryColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.notifications,
                text: "Notification Setting",
                color: primaryColor,
                onTap: () {
                  // TODO: navigasi ke pengaturan notifikasi
                },
              ),
              _buildMenuItem(
                icon: Icons.logout,
                text: "Logout",
                color: primaryColor,
                isLogout: true,
                onTap: () {
                  _showLogoutConfirmation(context, primaryColor);
                },
              ),

              const SizedBox(height: 20),

              // Lencana
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Lencana",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBadgePlaceholder("MILESTONE", "5K", primaryColor),
                  const SizedBox(width: 20),
                  _buildBadgePlaceholder("FINISH", "RUN", primaryColor),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Modal Logout
  void _showLogoutConfirmation(BuildContext context, Color primaryColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Are you sure you want to\nlog out?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFFFF5050),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(color: primaryColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Yes, logout",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Widget Informasi
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
      ],
    );
  }

  // Garis
  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withOpacity(0.5),
    );
  }

  // Widget Menu
  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required Color color,
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isLogout ? Colors.transparent : color,
                shape: BoxShape.circle,
                border: isLogout ? Border.all(color: color, width: 2) : null,
              ),
              child: Icon(
                icon,
                color: isLogout ? color : Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const Spacer(),
            if (!isLogout) const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Widget Badge
  Widget _buildBadgePlaceholder(String topText, String mainText, Color color) {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              topText,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            mainText,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
