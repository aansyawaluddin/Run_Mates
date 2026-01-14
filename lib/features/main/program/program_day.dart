import 'package:flutter/material.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/features/main/program/detail_program.dart';

class ProgramDayPage extends StatelessWidget {
  final int weekNumber;
  final int totalWeeks;

  const ProgramDayPage({
    super.key,
    required this.weekNumber,
    required this.totalWeeks,
  });

  final List<Map<String, dynamic>> dailyWorkouts = const [
    {'day': 'Senin', 'title': 'Easy Run', 'isCompleted': true},
    {'day': 'Selasa', 'title': 'Short Train', 'isCompleted': false},
    {'day': 'Rabu', 'title': 'Tempo Run', 'isCompleted': false},
    {'day': 'Kamis', 'title': 'Interval Run', 'isCompleted': false},
    {'day': 'Jumat', 'title': 'Interval Run', 'isCompleted': false},
    {'day': 'Sabtu', 'title': 'Interval Run', 'isCompleted': false},
    {'day': 'Minggu', 'title': 'Interval Run', 'isCompleted': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 18.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
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

                  const SizedBox(width: 60),

                  Expanded(
                    child: Text(
                      'Pekan $weekNumber dari $totalWeeks',
                      style: AppTextStyles.heading4(
                        weight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // List latihan
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 8.0,
                ),
                itemCount: dailyWorkouts.length,
                itemBuilder: (context, index) {
                  final workout = dailyWorkouts[index];
                  return _buildWorkoutCard(
                    context: context,
                    day: workout['day'] as String,
                    title: workout['title'] as String,
                    isCompleted: workout['isCompleted'] as bool,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProgramDetailPage(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutCard({
    required BuildContext context,
    required String day,
    required String title,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    final Color cardColor = isCompleted ? AppColors.primary : Colors.white;
    final Color textColor = isCompleted ? Colors.white : AppColors.primary;
    final Border? border = isCompleted
        ? null
        : Border.all(color: AppColors.primary, width: 1.5);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: isCompleted ? null : onTap,
        child: Container(
          height: 115,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(15),
            border: border,
            boxShadow: [
              if (isCompleted)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: AppTextStyles.heading4(
                      weight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: AppTextStyles.heading3(
                      weight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              if (isCompleted)
                const Icon(Icons.check_circle, color: Colors.white, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
