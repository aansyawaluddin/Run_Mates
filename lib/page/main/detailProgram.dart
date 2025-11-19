import 'package:flutter/material.dart';

class ProgramDetailPage extends StatelessWidget {
  const ProgramDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFF44336);
    const Color darkGrey = Color(0xFF424242);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryRed),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '', // Judul AppBar kosong sesuai desain
          style: TextStyle(color: primaryRed),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_none, color: primaryRed, size: 28),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Bagian Gambar Header ---
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/detail.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: const Center(
                            child: Text(
                              "Gambar Tidak Ditemukan",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
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
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EASY RUN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            'Daya Tahan Dasar',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
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

            // --- Deskripsi Latihan ---
            Text(
              'Easy run adalah Lorem ipsum dolor sit amet, consectetur adipiscing elit. In fermentum dignissim diam at elementum. Ut pharetra orci vitae massa mattis ornare. Vivamus nec pulvinar magna. Integer et nisl gravida, mollis dui a, sagittis massa.',
              style: TextStyle(color: darkGrey, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 25),

            // --- Tujuan Latihan ---
            _buildInfoSection(
              icon: Icons.track_changes, // Ikon target
              title: 'Tujuan Latihan',
              description:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In fermentum dignissim diam at elementum.',
              iconColor: primaryRed,
            ),
            const SizedBox(height: 25),

            // --- Durasi Latihan ---
            _buildInfoSection(
              icon: Icons.timer, // Ikon durasi
              title: 'Durasi',
              description: '40 menit',
              isDuration: true, // Untuk styling khusus durasi
              iconColor: primaryRed,
              durationColor: primaryRed,
            ),
            const SizedBox(height: 25),

            // --- Langkah-langkah Latihan ---
            Text(
              'Langkah-langkah',
              style: TextStyle(
                color: darkGrey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            _buildStepCard(
              stepNumber: 1,
              stepTitle: 'Pemanasan (5 Menit)',
              stepDescription:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In fermentum dignissim diam at elementum.',
              iconPath:
                  'assets/icons/warmup_icon.png', // Ganti dengan path ikon pemanasan
            ),
            _buildStepCard(
              stepNumber: 2,
              stepTitle: 'Lari (10 Menit)',
              stepDescription:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In fermentum dignissim diam at elementum.',
              iconPath:
                  'assets/icons/run_icon.png', // Ganti dengan path ikon lari
            ),
            _buildStepCard(
              stepNumber: 3,
              stepTitle: 'Pendinginan (10 Menit)',
              stepDescription:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In fermentum dignissim diam at elementum.',
              iconPath:
                  'assets/icons/cooldown_icon.png', // Ganti dengan path ikon pendinginan
            ),
            const SizedBox(height: 30),

            // --- Tombol Selesai ---
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  // Aksi saat tombol selesai ditekan
                  print('Latihan selesai!');
                  Navigator.pop(context); // Kembali atau ke halaman berikutnya
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Selesai',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ), // Tambahkan ruang di bagian bawah tombol
          ],
        ),
      ),
    );
  }

  // Widget untuk bagian "Tujuan Latihan" dan "Durasi"
  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String description,
    required Color iconColor,
    Color? durationColor,
    bool isDuration = false,
  }) {
    const Color darkGrey = Color(0xFF424242);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 30),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: darkGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  color: isDuration ? (durationColor ?? darkGrey) : darkGrey,
                  fontSize: isDuration ? 20 : 14,
                  fontWeight: isDuration ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget untuk setiap langkah latihan
  Widget _buildStepCard({
    required int stepNumber,
    required String stepTitle,
    required String stepDescription,
    required String iconPath,
  }) {
    const Color primaryRed = Color(0xFFF44336);
    const Color darkGrey = Color(0xFF424242);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nomor Langkah
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: primaryRed,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stepTitle,
                  style: TextStyle(
                    color: darkGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stepDescription,
                  style: TextStyle(color: darkGrey, fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          // Ikon di sisi kanan
          // Untuk menggunakan Image.asset, pastikan Anda memiliki gambar di folder 'assets/icons/'
          // dan mendeklarasikannya di pubspec.yaml
          Image.asset(
            iconPath,
            width: 40,
            height: 40,
            color: primaryRed, // Aplikasikan warna merah ke ikon
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.fitness_center,
                color: primaryRed,
                size: 40,
              ); // Ikon fallback
            },
          ),
        ],
      ),
    );
  }
}
