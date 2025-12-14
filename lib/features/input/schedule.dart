import 'package:flutter/material.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/permission/notifPermission.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final Set<String> _selectedDays = {};

  final List<String> _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  // tombol hari ditekan
  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final screenWidth = width;
    return Scaffold(
      backgroundColor: AppColors.textSecondary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 24.0, left: 24.0, top: 35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Text(
                  'Hari apa aja kamu ada waktu luang?',
                  style: AppTextStyles.heading3(
                    weight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Kami tau kamu sibuk, pilih hari yang realistis buat kamu latihan',
                  style: AppTextStyles.paragraph1(
                    weight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // Pilih hari
                Text(
                  'Pilih hari',
                  style: AppTextStyles.heading4(
                    weight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),

                Column(
                  children: _days.map((day) {
                    return _buildDayButton(day);
                  }).toList(),
                ),

                const SizedBox(height: 10),

                // Tombol Continue
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 24,
                    ),
                    child: SizedBox(
                      width: screenWidth * 0.6,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_selectedDays.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Pilih setidaknya satu hari.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationPermissionScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          elevation: 6,
                        ),
                        child: Text(
                          'Lanjutkan',
                          style: AppTextStyles.paragraph1(
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
      ),
    );
  }

  // Widget hari
  Widget _buildDayButton(String day) {
    final bool isSelected = _selectedDays.contains(day);

    final Color containerBgColor = isSelected
        ? AppColors.primary
        : AppColors.textSecondary;
    final Color textColor = isSelected
        ? AppColors.textSecondary
        : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => _toggleDay(day),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          decoration: BoxDecoration(
            color: containerBgColor,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: AppColors.primary, width: 2.5),
          ),
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: AppTextStyles.heading4(
              weight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
