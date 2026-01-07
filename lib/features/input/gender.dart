import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/features/input/age.dart';

class GenderSelectionPage extends StatefulWidget {
  const GenderSelectionPage({super.key});

  @override
  State<GenderSelectionPage> createState() => _GenderSelectionPageState();
}

enum Gender { male, female }

class _GenderSelectionPageState extends State<GenderSelectionPage> {
  Gender? _selectedGender;

  bool _showErrorText = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.07;

    return Scaffold(
      backgroundColor: AppColors.textSecondary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 45.0),

              Text(
                'Yuk kenalan dulu, kamu cowok atau cewek?',
                style: AppTextStyles.heading3(
                  weight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12.0),

              Text(
                'Pria dan wanita butuh pendekatan latihan yang beda, kami sesuaikan buat kamu',
                textAlign: TextAlign.start,
                style: AppTextStyles.paragraph1(
                  weight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12.0),

              if (_showErrorText)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'Pilih salah satu ya untuk melanjutkan',
                    textAlign: TextAlign.start,
                    style: AppTextStyles.paragraph1(
                      weight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),

              const SizedBox(height: 40.0),

              // Card Laki-laki
              _buildGenderCard(
                title: 'Cowok',
                icon: FontAwesomeIcons.mars,
                imageAsset: 'assets/images/male.png',
                value: Gender.male,
              ),

              const SizedBox(height: 40.0),

              // Card Perempuan
              _buildGenderCard(
                title: 'Cewek',
                icon: FontAwesomeIcons.venus,
                imageAsset: 'assets/images/female.png',
                value: Gender.female,
              ),

              const Spacer(),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0, top: 20.0),
                  child: SizedBox(
                    width: screenWidth * 0.6,
                    height: 56,
                    child: TextButton(
                      onPressed: () {
                        if (_selectedGender == null) {
                          setState(() {
                            _showErrorText = true;
                          });
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AgePage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        'Lanjutkan',
                        style: AppTextStyles.button(
                          weight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Card Gender
  Widget _buildGenderCard({
    required String title,
    required IconData icon,
    required String imageAsset,
    required Gender value,
  }) {
    final bool isSelected = (_selectedGender == value);

    final Widget checkboxIcon = Icon(
      isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
      color: isSelected ? AppColors.primary : Colors.black,
      size: 28,
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
          _showErrorText = false;
        });
      },
      child: Container(
        height: 160,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0XFFF3F3F4),
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 3.0,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -20,
              right: -10,
              child: Image.asset(
                imageAsset,
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 160,
                  width: 150,
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Text(
                      'Image \nNot Found',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FaIcon(
                        icon,
                        color: isSelected ? AppColors.primary : Colors.black,
                        size: 26,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  checkboxIcon,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
