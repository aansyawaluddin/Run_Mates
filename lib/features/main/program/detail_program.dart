import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmates/component/popUp/bagde_achieve.dart';
import 'package:runmates/component/popUp/finish_confirmation.dart';
import 'package:runmates/component/popUp/finish_popup.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/models/daily_schedule_model.dart';
import 'package:runmates/providers/prgram_provider.dart';

class ProgramDetailPage extends StatefulWidget {
  final DailyScheduleModel schedule;
  const ProgramDetailPage({super.key, required this.schedule});

  @override
  State<ProgramDetailPage> createState() => _ProgramDetailPageState();
}

class _ProgramDetailPageState extends State<ProgramDetailPage> {
  bool _isFinished = false;
  bool _isToday = false;

  @override
  void initState() {
    super.initState();
    _isFinished = widget.schedule.isDone;
    final now = DateTime.now();
    final scheduleDate = widget.schedule.scheduledDate;

    _isToday =
        now.year == scheduleDate.year &&
        now.month == scheduleDate.month &&
        now.day == scheduleDate.day;
  }

  Future<void> _handleFinishWorkout(BuildContext context) async {
    final provider = Provider.of<ProgramProvider>(context, listen: false);

    final bool hasBadgeBefore = await provider.hasAchievement(1);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return FinishConfirmation(
          onConfirm: () async {
            try {
              await provider.markScheduleAsDone(widget.schedule.id);

              if (!mounted) return;

              setState(() {
                _isFinished = true;
              });

              await showFinishPopUp(context);

              if (!hasBadgeBefore) {
                await Future.delayed(const Duration(milliseconds: 500));

                if (!mounted) return;
                final bool hasBadgeAfter = await provider.hasAchievement(1);

                if (hasBadgeAfter) {
                  if (!mounted) return;
                  shoBagdeAchieve(context);
                }
              }
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> steps = widget.schedule.steps;
    final String? warmup = steps['warmup'];
    final String? main = steps['main'];
    final String? cooldown = steps['cooldown'];

    return Scaffold(
      backgroundColor: AppColors.textSecondary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
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
                ],
              ),
              const SizedBox(height: 20),

              Container(
                height: 164,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/detail.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: Colors.grey);
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.schedule.workoutTitle.toUpperCase(),
                              style: AppTextStyles.heading3(
                                weight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.schedule.workoutSubtitle,
                              style: AppTextStyles.heading4(
                                weight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Icon(
                      Icons.track_changes_outlined,
                      color: AppColors.primary,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tujuan Latihan',
                          style: AppTextStyles.heading5(
                            weight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.schedule.workoutObjective!,
                          style: AppTextStyles.paragraph2(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_toggle_off_outlined,
                      color: AppColors.primary,
                      size: 36,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Durasi',
                      style: AppTextStyles.heading5(
                        weight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(width: 82),

                    Text(
                      '${widget.schedule.durationMinutes} menit',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              if (steps.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.double_arrow_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Langkah-langkah',
                      style: AppTextStyles.heading5(
                        weight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                if (warmup != null && warmup.isNotEmpty)
                  _buildStepCard(
                    title: '1. Pemanasan',
                    duration: '(Awal)',
                    description: warmup,
                    iconPath: 'assets/icons/warmup_icon.png',
                    fallbackIcon: Icons.accessibility_new,
                  ),

                if (main != null && main.isNotEmpty)
                  _buildStepCard(
                    title: '2. Latihan Inti',
                    duration: '(${widget.schedule.durationMinutes} Menit)',
                    description: main,
                    iconPath: 'assets/icons/run_icon.png',
                    fallbackIcon: Icons.directions_run,
                  ),

                if (cooldown != null && cooldown.isNotEmpty)
                  _buildStepCard(
                    title: '3. Pendinginan',
                    duration: '(Akhir)',
                    description: cooldown,
                    iconPath: 'assets/icons/cooldown_icon.png',
                    fallbackIcon: Icons.self_improvement,
                  ),
              ],

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  // onPressed: (_isFinished || !_isToday)
                  //     ? null
                  //     : () => _handleFinishWorkout(context),
                  onPressed: _isFinished
                      ? null
                      : () => _handleFinishWorkout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                    disabledForegroundColor: Colors.white.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: _isFinished ? 0 : 5,
                    shadowColor: AppColors.primary.withOpacity(0.4),
                  ),
                  child: Text(
                    _isFinished
                        ? 'Sudah Selesai'
                        : (_isToday ? 'Selesai' : 'Belum Jadwalnya'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Card Langkah
  Widget _buildStepCard({
    required String title,
    required String duration,
    required String description,
    required String iconPath,
    required IconData fallbackIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: '$title ',
                    style: AppTextStyles.paragraph1(
                      weight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    children: [
                      TextSpan(
                        text: duration,
                        style: AppTextStyles.paragraph1(
                          weight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.paragraph2(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Image.asset(
            iconPath,
            width: 50,
            height: 50,
            color: Colors.black,
            errorBuilder: (context, error, stackTrace) {
              return Icon(fallbackIcon, color: Colors.black, size: 40);
            },
          ),
        ],
      ),
    );
  }
}
