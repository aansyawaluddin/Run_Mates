import 'package:flutter/material.dart';
import 'package:runmates/component/notifikasi.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/models/notification_model.dart';
import 'package:runmates/service/notification_service.dart.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationService _service = NotificationService();

  @override
  Widget build(BuildContext context) {
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
              child: StreamBuilder<List<NotificationModel>>(
                stream: _service.getNotificationStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'Belum ada notifikasi',
                        style: AppTextStyles.paragraph1(
                          color: Colors.grey,
                          weight: FontWeight.normal,
                        ),
                      ),
                    );
                  }

                  final groupedNotifications = _service
                      .groupNotificationsByDate(snapshot.data!);
                  final groupKeys = groupedNotifications.keys.toList();

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: groupKeys.length,
                    itemBuilder: (context, index) {
                      final String dateLabel = groupKeys[index];
                      final List<NotificationModel> items =
                          groupedNotifications[dateLabel]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 12.0,
                              top: 8.0,
                            ),
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
                                title: item.title,
                                description: item.description,
                              ),
                            );
                          }),
                        ],
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
}
