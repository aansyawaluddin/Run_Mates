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
  static const Color _successColor = Color(0xFF22C55E);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProgramProvider>(
        context,
        listen: false,
      ).fetchDailySchedules(widget.weekId);
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
                    return const Center(
                      child: Text("Tidak ada jadwal latihan."),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 8.0,
                    ),
                    itemCount: provider.dailySchedules.length,
                    itemBuilder: (context, index) {
                      final schedule = provider.dailySchedules[index];

                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      final scheduleDate = DateTime(
                        schedule.scheduledDate.year,
                        schedule.scheduledDate.month,
                        schedule.scheduledDate.day,
                      );

                      final String title = schedule.workoutTitle;
                      final bool isRest = title.toLowerCase().contains('rest');
                      final bool isPast = scheduleDate.isBefore(today);

                      final bool isCompleted =
                          schedule.isDone || (isRest && isPast);

                      final bool isMissed =
                          !schedule.isDone && !isRest && isPast;

                      return _buildWorkoutCard(
                        context: context,
                        day: schedule.dayName,
                        title: title,
                        isCompleted: isCompleted,
                        isMissed: isMissed,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProgramDetailPage(schedule: schedule),
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
    required bool isMissed,
    required VoidCallback onTap,
  }) {
    late Color cardColor;
    late Color textColor;
    Border? border;
    Widget? trailingIcon;
    List<BoxShadow> shadows = [];

    if (isCompleted) {
      cardColor = _successColor;
      textColor = Colors.white;
      border = null;
      trailingIcon = const Icon(
        Icons.check_circle,
        color: Colors.white,
        size: 30,
      );
      shadows = [
        BoxShadow(
          color: _successColor.withOpacity(0.4),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ];
    } else if (isMissed) {
      cardColor = AppColors.primary;
      textColor = Colors.white;
      border = null;
      trailingIcon = const Icon(Icons.cancel, color: Colors.white, size: 30);
      shadows = [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.4),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ];
    } else {
      cardColor = Colors.white;
      textColor = AppColors.primary;
      border = Border.all(color: AppColors.primary, width: 1.5);
      trailingIcon = null;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: isCompleted ? null : onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 115),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(15),
            border: border,
            boxShadow: shadows,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      day,
                      style: AppTextStyles.heading4(
                        weight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: AppTextStyles.heading4(
                        weight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 12),
                trailingIcon,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
