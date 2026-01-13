import 'package:flutter/material.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';

class BadgePage extends StatelessWidget {
  const BadgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Text(
                    'Lencana',
                    style: AppTextStyles.heading4(
                      weight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),

              const SizedBox(height: 30),

              // Progress Program
              _buildSectionTitle('Progress Program'),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: buildBadgeCard(
                      context: context,
                      title: 'Langkah Pertama',
                      imageAsset: 'assets/images/lencana.png',
                      onTap: () {
                        // contoh aksi: buka detail
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildBadgeCard(
                      context: context,
                      title: 'Menyelesaikan Pekan 1',
                      imageAsset: 'assets/images/lencana.png',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Pencapaian Jarak
              _buildSectionTitle('Pencapaian Jarak'),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: buildBadgeCard(
                      context: context,
                      title: 'Lorem Ipsum',
                      imageAsset: 'assets/images/lencana.png',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildBadgeCard(
                      context: context,
                      title: 'Lorem Ipsum',
                      imageAsset: 'assets/images/lencana.png',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Judul
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.heading4(
        weight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  // widget BadgeCard
  Widget buildBadgeCard({
    required BuildContext context,
    required String title,
    required String imageAsset,
    double height = 160,
    VoidCallback? onTap,
    bool locked = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      imageAsset,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.emoji_events, size: 40);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.paragraph2(
                      weight: FontWeight.bold,
                      color: Colors.black,
                    ).copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),

            if (locked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.lock, size: 28, color: Colors.black54),
                        SizedBox(height: 6),
                        Text(
                          'Terkunci',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
