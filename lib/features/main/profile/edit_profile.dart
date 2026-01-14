import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/providers/auth_provider.dart';
import 'package:runmates/providers/profile_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();

    final user = context.read<AuthProvider>().currentUser;

    _nameController = TextEditingController(text: user?.fullName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _ageController = TextEditingController(text: user?.age.toString() ?? '');
    _weightController = TextEditingController(
      text: user?.weightKg.toString() ?? '',
    );
    _heightController = TextEditingController(
      text: user?.heightCm.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateProfile(ProfileProvider profileProvider) async {
    if (_nameController.text.trim().isEmpty) return;

    final int age = int.tryParse(_ageController.text) ?? 0;
    final double weight = double.tryParse(_weightController.text) ?? 0.0;
    final double height = double.tryParse(_heightController.text) ?? 0.0;

    final String? error = await profileProvider.updateProfile(
      fullName: _nameController.text.trim(),
      age: age,
      weight: weight,
      height: height,
    );

    if (!mounted) return;

    if (error == null) {
      await context.read<AuthProvider>().loadUserProfile();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Berhasil Update!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.textSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            title: Text(
              'Gagal Update',
              style: AppTextStyles.heading4(
                weight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            content: Text(
              error,
              style: AppTextStyles.heading4Uppercase(
                weight: FontWeight.normal,
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Coba Lagi',
                    style: AppTextStyles.button(
                      weight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final user = context.watch<AuthProvider>().currentUser;
        return Scaffold(
          backgroundColor: AppColors.textSecondary,
          appBar: AppBar(
            title: Text(
              "Profile",
              style: AppTextStyles.heading4(
                weight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.textSecondary,
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.only(left: 18),
                padding: const EdgeInsets.all(3.0),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: const EdgeInsets.all(1.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(color: AppColors.textSecondary),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            user?.fullName ?? "",
                            style: AppTextStyles.heading5(
                              weight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            user?.email ?? "",
                            style: AppTextStyles.heading4Uppercase(
                              weight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 2. Statistik Card (Merah)
                    Container(
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
                    const SizedBox(height: 25),

                    // Input
                    _buildInputLabel("Nama"),
                    _buildTextField(_nameController),

                    _buildInputLabel("Email"),
                    _buildTextField(_emailController, isReadOnly: true),

                    _buildInputLabel("Usia"),
                    _buildTextField(_ageController, isNumber: true),

                    _buildInputLabel("Berat (Kg)"),
                    _buildTextField(_weightController, isNumber: true),

                    _buildInputLabel("Tinggi (CM)"),
                    _buildTextField(_heightController, isNumber: true),

                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 24,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: profileProvider.isLoading
                              ? null
                              : () {
                                  _handleUpdateProfile(profileProvider);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            shadowColor: AppColors.primary.withOpacity(0.5),
                          ),
                          child: const Text(
                            "Perbaharui Profile",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (profileProvider.isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.textPrimary,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // widget nama input
  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Widget Edit Teks
  Widget _buildTextField(
    TextEditingController controller, {
    bool isNumber = false,
    bool isReadOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isReadOnly ? Colors.grey.shade200 : AppColors.textSecondary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          if (!isReadOnly)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        readOnly: isReadOnly,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          isDense: true,
        ),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isReadOnly ? Colors.grey : AppColors.textPrimary,
        ),
      ),
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
}
