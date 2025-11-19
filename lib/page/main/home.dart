import 'package:flutter/material.dart';

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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color RedColor = Color(0XFFFF5050);
    const Color cardBackground = Color(0XFFeeeded);

    return Scaffold(
      backgroundColor: Color(0XFFFAFAFA),
      appBar: AppBar(
        title: Text(
          'Halo, Runners!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color(0XFFFF5050),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const NotificationPage(),
                //   ),
                // );
              },
              child: const Icon(
                Icons.notifications_none_outlined,
                size: 28,
                color: RedColor,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0XFFFAFAFA),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              _buildProgramCard(cardBackground, RedColor),
              const SizedBox(height: 20),

              // card progress minggu ini
              _buildWeeklyProgressCard(cardBackground, RedColor),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.cyan.shade400,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'TIPS!',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
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
                ? const Color(0XFF00DEEC)
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
        color: Color(0XFFFF5050),
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Aksi untuk 'Lihat detail'
                },
                child: const Row(
                  children: [
                    Text(
                      'Lihat detail',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Color(0XFF00DEEC),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'INTERVAL RUN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Melatih daya tahan & kecepatan',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // card program lari
  Widget _buildProgramCard(Color cardBackground, Color RedColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Program lari 20K',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '12 Minggu • Target : 20K dalam 1 jam',
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress program',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              const Text(
                '25%',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.25, // 25%
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(RedColor),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  // card progress minggu ini
  Widget _buildWeeklyProgressCard(Color cardBackground, Color RedColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress Minggu Ini',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
          Divider(color: Colors.white),
          const SizedBox(height: 8),
          // baris peningkatan
          Row(
            children: [
              Icon(Icons.trending_up, color: RedColor, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Peningkatan minggu ini',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Jarak lari meningkat 2KM dari minggu lalu',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Text(
                '+20%',
                style: TextStyle(
                  color: Color(0XFFFF5050),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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
        color: Color(0XFFFF5050),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(unit, style: TextStyle(color: Colors.white, fontSize: 14)),
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
      style: TextStyle(
        color: isRed ? const Color(0XFFFF5050) : Color(0XFFFF5050),
        fontWeight: FontWeight.bold,
      ),
    );

    if (isDone) {
      circleColor = const Color(0XFFFF5050);
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
