import 'package:flutter/material.dart';
import 'package:runmates/component/notifikasi.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'date': 'Hari Ini',
        'items': [
          {
            'title': 'Waktunya Lari Harian Kamu',
            'desc':
                'Lari 30 menit aja udah cukup buat jaga kebugaran dan progress menuju target bulanan kamu',
          },
          {
            'title': '5 Km Lagi Menuju Target Kamu!',
            'desc':
                'Lari sebentar hari ini bisa bantu kamu capai target kamu lho',
          },
          {
            'title': 'Kamu Berhasil Capai Target Mingguan!',
            'desc': 'Target lari 3x seminggu berhasil! Terus pertahankan ya',
          },
        ],
      },
      {
        'date': 'Kemarin',
        'items': [
          {
            'title': 'Waktunya Lari Harian Kamu',
            'desc':
                'Lari 30 menit aja udah cukup buat jaga kebugaran dan progress menuju target bulanan kamu',
          },
          {
            'title': '5 Km Lagi Menuju Target Kamu!',
            'desc':
                'Lari sebentar hari ini bisa bantu kamu capai target kamu lho',
          },
        ],
      },
      {
        'date': '3 Desember 20xx',
        'items': [
          {
            'title': 'Waktunya Lari Harian Kamu',
            'desc':
                'Lari 30 menit aja udah cukup buat jaga kebugaran dan progress menuju target bulanan kamu',
          },
        ],
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.textSecondary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
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
                    'Notifikasi',
                    style: AppTextStyles.heading3(
                      weight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final group = notifications[index];
                  final String dateLabel = group['date'];
                  final List items = group['items'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
                        child: Text(
                          dateLabel,
                          style: AppTextStyles.paragraph1(
                            weight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      ...items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: NotificationCard(
                            title: item['title'],
                            description: item['desc'],
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
