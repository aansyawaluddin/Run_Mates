import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/features/main/home/notification.dart';
import 'package:runmates/features/main/home/tips_detail.dart';
import 'package:runmates/providers/auth_provider.dart';
import 'package:runmates/providers/prgram_provider.dart';
import 'package:runmates/providers/tips_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadUserProfile();
      context.read<TipsProvider>().fetchTips();
      context.read<ProgramProvider>().fetchProgramProgress();
      context.read<ProgramProvider>().fetchTodaySchedule();
      context.read<ProgramProvider>().fetchWeeklyProgress();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomSpacing = MediaQuery.of(context).padding.bottom;

    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final tipsProvider = context.watch<TipsProvider>();

    return Scaffold(
      backgroundColor: AppColors.textSecondary,
      appBar: AppBar(
        title: Text(
          'Halo, ${user?.fullName ?? "User"}!',
          style: AppTextStyles.heading4(
            weight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              },
              child: const Icon(
                Icons.notifications_none_outlined,
                size: 28,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: AppColors.textSecondary),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, bottomSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10),
              if (tipsProvider.isLoading)
                const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (tipsProvider.errorMessage != null)
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Text(tipsProvider.errorMessage!),
                )
              else if (tipsProvider.tips.isEmpty)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(child: Text('Belum ada tips saat ini')),
                )
              else
                Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: tipsProvider.tips.length,
                        itemBuilder: (context, index) {
                          final tip = tipsProvider.tips[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TipsDetail(tip: tip),
                                ),
                              );
                            },
                            child: tipsCardPage(
                              imageUrl: tip.imageUrl,
                              title: tip.title,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPageIndicator(tipsProvider.tips.length),
                  ],
                ),
              const SizedBox(height: 24),

              // card latihan hari ini
              _buildTodayActivityCard(context),
              const SizedBox(height: 20),

              // card program lari
              _buildProgramCard(context),
              const SizedBox(height: 20),

              // card progress minggu ini
              _buildWeeklyProgressCard(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // card tips
  Widget tipsCardPage({required String imageUrl, required String title}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey,
                child: const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'TIPS!',
                    style: AppTextStyles.heading4(
                      weight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: AppTextStyles.paragraph1(
                            weight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.textSecondary,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int numPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(numPages, (index) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? AppColors.primary
                : Colors.grey.shade700,
          ),
        );
      }),
    );
  }

  // card latihan hari ini
  Widget _buildTodayActivityCard(BuildContext context) {
    final programProvider = context.watch<ProgramProvider>();
    final schedule = programProvider.todaySchedule;
    final isLoading = programProvider.isTodayLoading;

    final now = DateTime.now();
    final List<String> days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    final dayName = days[now.weekday - 1];
    final dateString = "$dayName, ${now.day}/${now.month}";

    if (isLoading) {
      return Container(
        height: 120,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.textSecondary),
        ),
      );
    }

    if (schedule == null) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hari ini • $dateString',
              style: AppTextStyles.heading4Uppercase(
                weight: FontWeight.normal,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.nightlight_round,
                  color: Colors.yellow,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REST DAY',
                      style: AppTextStyles.heading4(
                        weight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Istirahatkan tubuhmu hari ini.',
                      style: AppTextStyles.heading4Uppercase(
                        weight: FontWeight.normal,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latihan hari ini • $dateString',
                style: AppTextStyles.heading4Uppercase(
                  weight: FontWeight.normal,
                  color: AppColors.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Navigasi ke halaman detail latihan
                  // Navigator.push(context, MaterialPageRoute(builder: (c) => WorkoutDetailPage(schedule: schedule)));
                },
                child: Row(
                  children: [
                    Text(
                      'Lihat detail',
                      style: AppTextStyles.heading4Uppercase(
                        weight: FontWeight.normal,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            schedule.workoutTitle.toUpperCase(),
            style: AppTextStyles.heading4(
              weight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          Text(
            schedule.workoutSubtitle.toLowerCase(),
            style: AppTextStyles.heading4Uppercase(
              weight: FontWeight.normal,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          if (schedule.isDone)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "SELESAI ✅",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // card program lari
  Widget _buildProgramCard(BuildContext context) {
    final programProvider = context.watch<ProgramProvider>();
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    String formatDuration(int minutes) {
      if (minutes < 60) return '$minutes Menit';
      final hours = minutes / 60;
      return '${hours.toStringAsFixed(1).replaceAll('.0', '')} Jam';
    }

    final targetDistance = user?.targetDistanceKm ?? 0;
    final targetTime = user?.targetTimeMinutes ?? 0;

    final totalWeeks = programProvider.totalWeeks;
    final progressPercent = programProvider.progressPercentage;
    final progressLabel = (progressPercent * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.mutedCardBg,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Program lari ${targetDistance}K',
            style: AppTextStyles.heading4(
              weight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),

          programProvider.isProgressLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              : Text(
                  '$totalWeeks Minggu • Target : ${targetDistance}K dalam ${formatDuration(targetTime)}',
                  style: AppTextStyles.heading4Uppercase(
                    weight: FontWeight.normal,
                    color: AppColors.textPrimary,
                  ),
                ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress program',
                style: AppTextStyles.heading4Uppercase(
                  weight: FontWeight.normal,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$progressLabel%',
                style: AppTextStyles.heading4Uppercase(
                  weight: FontWeight.normal,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressPercent,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  // card progress minggu ini
  Widget _buildWeeklyProgressCard(BuildContext context) {
    final programProvider = context.watch<ProgramProvider>();
    final finished = programProvider.completedSessionsThisWeek;
    final total = programProvider.totalSessionsThisWeek;
    final durationStr = programProvider.totalDurationFormatted;
    final distanceStr = programProvider.totalDistanceThisWeek.toStringAsFixed(
      1,
    );

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.mutedCardBg,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress Minggu Ini',
            style: AppTextStyles.heading4(
              weight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          programProvider.isWeeklyLoading
              ? const Center(
                  child: LinearProgressIndicator(color: AppColors.primary),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCard(distanceStr, 'KM'),
                    _buildStatCard('$finished/$total', 'Sesi'),
                    _buildStatCard(durationStr, 'Jam'),
                  ],
                ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayIndicator(
                'S',
                status: programProvider.getDayStatus(1),
              ), // Senin
              _buildDayIndicator(
                'S',
                status: programProvider.getDayStatus(2),
              ), // Selasa
              _buildDayIndicator(
                'R',
                status: programProvider.getDayStatus(3),
              ), // Rabu
              _buildDayIndicator(
                'K',
                status: programProvider.getDayStatus(4),
              ), // Kamis
              _buildDayIndicator(
                'J',
                status: programProvider.getDayStatus(5),
              ), // Jumat
              _buildDayIndicator(
                'S',
                status: programProvider.getDayStatus(6),
              ), // Sabtu
              _buildDayIndicator(
                'M',
                status: programProvider.getDayStatus(7),
              ), // Minggu
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.white),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.trending_up, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Konsistensi',
                      style: AppTextStyles.heading4Uppercase(
                        weight: FontWeight.normal,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      finished > 0
                          ? 'Terus pertahankan performamu!'
                          : 'Ayo mulai latihan pertamamu!',
                      style: AppTextStyles.heading4Uppercase(
                        weight: FontWeight.normal,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // card statistik
  Widget _buildStatCard(String value, String unit) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.8,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.heading4(
              weight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            unit,
            style: AppTextStyles.heading4Uppercase(
              weight: FontWeight.normal,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // indikator hari
  Widget _buildDayIndicator(String day, {required int status}) {
    Color circleColor = Colors.transparent;
    Widget child = Text(
      day,
      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
    );

    if (status == 1) {
      circleColor = Colors.white;
      child = Text(
        day,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (status == 2) {
      circleColor = AppColors.primary;
      child = const Icon(Icons.check, color: Colors.white, size: 16);
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle,
        border: status == 0
            ? Border.all(color: Colors.grey[700]!, width: 1)
            : null,
      ),
      child: Center(child: child),
    );
  }
}
