import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/features/main/program/detail_program.dart';
import 'package:runmates/providers/prgram_provider.dart';

class ProgramDayPage extends StatefulWidget {
  final int weekNumber;
  final int totalWeeks;
  final int weekId;

  const ProgramDayPage({
    super.key,
    required this.weekNumber,
    required this.totalWeeks,
    required this.weekId,
  });

  @override
  State<ProgramDayPage> createState() => _ProgramDayPageState();
}

class _ProgramDayPageState extends State<ProgramDayPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProgramProvider>(context, listen: false)
          .fetchDailySchedules(widget.weekId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textSecondary,
      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 18.0),
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
                      'Pekan ${widget.weekNumber} dari ${widget.totalWeeks}',
                      style: AppTextStyles.heading4(
                        weight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Consumer<ProgramProvider>(
                builder: (context, provider, child) {
                  if (provider.isDayLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.dailySchedules.isEmpty) {
                    return const Center(child: Text("Tidak ada jadwal latihan."));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                    itemCount: provider.dailySchedules.length,
                    itemBuilder: (context, index) {
                      final schedule = provider.dailySchedules[index];
                      
                      return _buildWorkoutCard(
                        context: context,
                        day: schedule.dayName,
                        title: schedule.workoutTitle,
                        isCompleted: schedule.isDone,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProgramDetailPage(
                                schedule: schedule, 
                              ),
                            ),
                          );
                        },
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
    // ... (KODE _buildWorkoutCard SAMA SEPERTI SEBELUMNYA) ...
    // Copy-Paste kode UI card Anda di sini
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