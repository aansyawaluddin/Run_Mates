import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/features/main/home/notification.dart';
import 'package:runmates/providers/auth_provider.dart';

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
              // Carousel Tips
              SizedBox(
                height: 200,
                child: PageView(
                  controller: _pageController,
                  children: [
                    tipsCardPage(
                      imagePath: 'assets/images/running_tips.png',
                      text: 'Half Marathon event held by Mandiri Bank Group',
                    ),
                    tipsCardPage(
                      imagePath: 'assets/images/running_tips.png',
                      text: 'Tips Nutrisi Penting Sebelum Lari Jarak Jauh',
                    ),
                    tipsCardPage(
                      imagePath: 'assets/images/running_tips.png',
                      text: 'Cara Memilih Sepatu Lari yang Tepat Untukmu',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildPageIndicator(),
              const SizedBox(height: 24),

              // card latihan hari ini
              _buildTodayActivityCard(),
              const SizedBox(height: 20),

              // card program lari
              _buildProgramCard(),
              const SizedBox(height: 20),

              // card progress minggu ini
              _buildWeeklyProgressCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // card tips
  Widget tipsCardPage({required String imagePath, required String text}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(imagePath, fit: BoxFit.cover),
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
                          text,
                          style: AppTextStyles.paragraph1(
                            weight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
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

  // indikator corousel tips
  Widget _buildPageIndicator() {
    int numPages = 3;
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
  Widget _buildTodayActivityCard() {
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
                'Latihan hari ini • Minggu 1, Hari 3',
                style: AppTextStyles.heading4Uppercase(
                  weight: FontWeight.normal,
                  color: AppColors.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Aksi untuk 'Lihat detail'
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
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'INTERVAL RUN',
            style: AppTextStyles.heading4(
              weight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Melatih daya tahan & kecepatan',
            style: AppTextStyles.heading4Uppercase(
              weight: FontWeight.normal,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // card program lari
  Widget _buildProgramCard() {
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
            'Program lari 20K',
            style: AppTextStyles.heading4(
              weight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '12 Minggu • Target : 20K dalam 1 jam',
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
                '25%',
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
              value: 0.25,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  // card progress minggu ini
  Widget _buildWeeklyProgressCard() {
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
          // baris statistik
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('5.5', 'KM'),
              _buildStatCard('3/6', 'Sesi'),
              _buildStatCard('2:30', 'Jam'),
            ],
          ),
          const SizedBox(height: 16),
          // baris indikator hari
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayIndicator('S', isDone: true, isRed: true),
              _buildDayIndicator('S', isDone: true, isRed: true),
              _buildDayIndicator('R', isDone: true, isRed: true),
              _buildDayIndicator('K'),
              _buildDayIndicator('J'),
              _buildDayIndicator('S'),
              _buildDayIndicator('M'),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white),
          const SizedBox(height: 8),
          // baris peningkatan
          Row(
            children: [
              Icon(Icons.trending_up, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Peningkatan minggu ini',
                      style: AppTextStyles.heading4Uppercase(
                        weight: FontWeight.normal,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Jarak lari meningkat 2KM dari minggu lalu',
                      style: AppTextStyles.heading4Uppercase(
                        weight: FontWeight.normal,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '+20%',
                style: AppTextStyles.heading4Uppercase(
                  weight: FontWeight.w500,
                  color: AppColors.primary,
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
  Widget _buildDayIndicator(
    String day, {
    bool isDone = false,
    bool isRed = false,
  }) {
    Color circleColor = Colors.white;
    Widget child = Text(
      day,
      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
    );

    if (isDone) {
      circleColor = AppColors.primary;
      child = const Icon(Icons.check, color: Colors.white, size: 16);
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
      child: Center(child: child),
    );
  }
}
