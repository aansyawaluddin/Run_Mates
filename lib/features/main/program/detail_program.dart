import 'package:flutter/material.dart';
import 'package:runmates/component/bagde.dart';
import 'package:runmates/component/popUp/bagde_achieve.dart';
import 'package:runmates/component/popUp/finish_confirmation.dart';
import 'package:runmates/component/popUp/finish_popup.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';

class ProgramDetailPage extends StatefulWidget {
  const ProgramDetailPage({super.key});

  @override
  State<ProgramDetailPage> createState() => _ProgramDetailPageState();
}

class _ProgramDetailPageState extends State<ProgramDetailPage> {
  bool _isFinished = false;

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
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
                              'EASY RUN',
                              style: AppTextStyles.heading1(
                                weight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              'Daya Tahan Dasar',
                              style: AppTextStyles.heading4(
                                weight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Deskripsi Utama
              Text(
                'Easy run adalah Lorem ipsum dolor sit amet, consectetur adipiscing elit. In fermentum dignissim diam at elementum. Ut pharetra orci vitae massa mattis ornare. Vivamus nec pulvinar magna.',
                style: AppTextStyles.paragraph2(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 25),

              // Tujuan Latihan
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
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In fermentum dignissim diam at elementum.',
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

              // Durasi
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
                      '40 menit',
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

              // Langkah-langkah Header
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

              // List Langkah-langkah
              _buildStepCard(
                title: '1. Pemanasan',
                duration: '(5 Menit)',
                description:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In fermentum dignissim diam at elementum.',
                iconPath: 'assets/icons/warmup_icon.png',
                fallbackIcon: Icons.accessibility_new,
              ),
              _buildStepCard(
                title: '2. Lari',
                duration: '(10 Menit)',
                description:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In fermentum dignissim diam at elementum.',
                iconPath: 'assets/icons/run_icon.png',
                fallbackIcon: Icons.directions_run,
              ),
              _buildStepCard(
                title: '3. Pendinginan',
                duration: '(10 Menit)',
                description:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In fermentum dignissim diam at elementum.',
                iconPath: 'assets/icons/cooldown_icon.png',
                fallbackIcon: Icons.self_improvement,
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isFinished
                      ? null
                      : () {
                          showDialog(
                            context: parentContext,
                            builder: (dialogContext) {
                              return FinishConfirmation(
                                onConfirm: () async {
                                  if (!mounted) return;

                                  setState(() {
                                    _isFinished = true;
                                  });

                                  if (!mounted) return;
                                  await showFinishPopUp(parentContext);

                                  if (!mounted) return;
                                  shoBagdeAchieve(parentContext);
                                },
                              );
                            },
                          );
                        },
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
                    _isFinished ? 'Sudah Selesai' : 'Selesai',
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
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
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
