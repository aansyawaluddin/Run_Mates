import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/features/auth/login.dart';
import 'package:runmates/features/main/profile/badge.dart';
import 'package:runmates/features/main/profile/edit_profile.dart';
import 'package:runmates/providers/achievement_provider.dart';
import 'package:runmates/providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadUserProfile();
      context.read<AchievementProvider>().fetchProfileAchievements();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final achievementProvider = context.watch<AchievementProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.textSecondary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Profile",
                style: AppTextStyles.heading4(
                  weight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFE0E0E0),
              ),
              const SizedBox(height: 15),
              Text(
                user?.fullName ?? "",
                style: AppTextStyles.heading5(
                  weight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                user?.email ?? "",
                style: AppTextStyles.heading4Uppercase(
                  weight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 25),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(
                      user?.weightKg.toStringAsFixed(1) ?? "-",
                      "Berat (Kg)",
                    ),
                    _buildDivider(),
                    _buildStatItem(user?.age.toString() ?? "-", "Usia"),
                    _buildDivider(),
                    _buildStatItem(
                      user?.heightCm.toStringAsFixed(2) ?? "-",
                      "Tinggi (CM)",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Menu List
              _buildMenuItem(
                icon: Icons.person,
                text: "Profile",
                color: AppColors.primary,
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
                color: AppColors.primary,
                onTap: () {
                  // TODO: navigasi ke pengaturan notifikasi
                },
              ),
              _buildMenuItem(
                icon: Icons.logout,
                text: "Logout",
                color: AppColors.primary,
                isLogout: true,
                onTap: () {
                  _showLogoutConfirmation(context, AppColors.primary);
                },
              ),

              const SizedBox(height: 20),

              // Lencana
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Lencana",
                      style: AppTextStyles.heading4(
                        weight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BadgePage(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            "Lihat lainnya",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Badge
              if (achievementProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (achievementProvider.myAchievements.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Belum ada lencana yang didapatkan.\nAyo mulai lari!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              else
                SizedBox(
                  height: 120, 
                  child: Center(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      scrollDirection: Axis.horizontal,
                      itemCount: achievementProvider.myAchievements.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 20),
                      itemBuilder: (context, index) {
                        final item = achievementProvider.myAchievements[index];
                        return Column(
                          children: [
                            SizedBox(
                              height: 90,
                              width: 80,
                              child: Image.network(
                                item.achievement.imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.shield,
                                    size: 60,
                                    color: Colors.grey,
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      );
                                    },
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 80,
                              child: Text(
                                item.achievement.title,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Modal Logout
  void _showLogoutConfirmation(BuildContext parentContext, Color primaryColor) {
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
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
                      onPressed: () => Navigator.pop(modalContext),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
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
                      onPressed: () async {
                        Navigator.pop(modalContext);
                        await parentContext.read<AuthProvider>().logout();
                        if (parentContext.mounted) {
                          Navigator.pushAndRemoveUntil(
                            parentContext,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Yes, logout",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
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
}
