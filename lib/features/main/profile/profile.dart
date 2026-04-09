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
  // State untuk status notifikasi (Default: Hidup)
  bool _isNotificationEnabled = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadUserProfile();
      context.read<AchievementProvider>().fetchProfileAchievements();

      // TODO: Di sini Anda bisa menambahkan logika untuk mengambil
      // status notifikasi terakhir dari SharedPreferences/Database
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

              // Foto Profil Placeholder
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFE0E0E0),
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 15),

              // Nama User
              Text(
                user?.fullName ?? "User",
                style: AppTextStyles.heading5(
                  weight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 5),

              // Email User
              Text(
                user?.email ?? "",
                style: AppTextStyles.heading4Uppercase(
                  weight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 25),

              // Statistik Fisik User
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
                      user?.heightCm.toStringAsFixed(0) ?? "-",
                      "Tinggi (CM)",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- MENU LIST ---

              // 1. Menu Edit Profile
              _buildMenuItem(
                icon: Icons.person,
                text: "Edit Profile",
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

              // 2. Menu Notification Setting (DENGAN SWITCH)
              _buildMenuItem(
                icon: Icons.notifications,
                text: "Notification Setting",
                color: AppColors.primary,
                // Menggunakan parameter trailing untuk Switch
                trailing: Switch(
                  value: _isNotificationEnabled,
                  activeColor: AppColors.primary,
                  inactiveTrackColor: Colors.grey[300],
                  onChanged: (bool value) {
                    setState(() {
                      _isNotificationEnabled = value;
                    });

                    // Feedback visual sederhana
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value
                              ? "Notifikasi Diaktifkan"
                              : "Notifikasi Dimatikan",
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: value ? Colors.green : Colors.grey,
                        duration: const Duration(seconds: 1),
                      ),
                    );

                    // TODO: Panggil fungsi untuk update preferensi ke Database/Local Storage
                  },
                ),
                // onTap bisa dikosongkan agar user fokus menekan switch,
                // atau diisi untuk toggle switch juga
                onTap: () {
                  setState(() {
                    _isNotificationEnabled = !_isNotificationEnabled;
                  });
                },
              ),

              // 3. Menu Logout
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

              // --- BAGIAN LENCANA (BADGES) ---
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

              // List Lencana
              if (achievementProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (achievementProvider.myAchievements.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Belum ada lencana.\nAyo selesaikan latihan!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  height: 130, // Tinggi container badge
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
                          Container(
                            height: 80,
                            width: 80,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Image.network(
                              item.achievement.imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.shield,
                                  size: 40,
                                  color: Colors.amber,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 80,
                            child: Text(
                              item.achievement.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  // 1. Info Statistik (Berat, Usia, Tinggi)
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

  // 2. Garis Pemisah Putih
  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withOpacity(0.5),
    );
  }

  // 3. Item Menu (Updated with Trailing Widget)
  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required Color color,
    bool isLogout = false,
    VoidCallback? onTap,
    Widget? trailing, // Parameter baru untuk Custom Widget di kanan
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
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
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ),

            // Logic Penentuan Widget Kanan
            if (trailing != null)
              trailing // Tampilkan Switch jika ada
            else if (!isLogout)
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ), // Default panah
          ],
        ),
      ),
    );
  }

  // 4. Modal Konfirmasi Logout
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
}
