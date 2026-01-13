import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:runmates/component/notifikasi.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/features/input/finish.dart';
import 'package:runmates/providers/registration_provider.dart';
import 'package:runmates/service/notifService.dart';

class NotificationPermissionScreen extends StatefulWidget {
  const NotificationPermissionScreen({super.key});

  @override
  State<NotificationPermissionScreen> createState() =>
      _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState
    extends State<NotificationPermissionScreen> {
  Future<void> _submitAndGoNext(BuildContext context) async {
    final provider = context.read<RegistrationProvider>();

    String? error = await provider.registerUser();

    if (!mounted) return;

    if (error == null) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const FinishPage()));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.textSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            title: Text(
              'Gagal Mendaftar', 
              style: AppTextStyles.heading4(
                weight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            content: Text(
              error,
              style: AppTextStyles.heading4Uppercase(
                weight: FontWeight.normal,
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Coba Lagi',
                    style: AppTextStyles.button(
                      weight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _requestNotificationPermission(BuildContext context) async {
    try {
      final result = await Permission.notification.request();

      if (result.isGranted) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terima kasih — notifikasi diaktifkan')),
        );

        await _showTestNotification(context);
        await _submitAndGoNext(context);
      } else if (result.isPermanentlyDenied) {
        if (context.mounted) await _submitAndGoNext(context);
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin notifikasi tidak diberikan')),
        );
        await _submitAndGoNext(context);
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi error: $e')));
    }
  }

  Future<void> _showTestNotification(BuildContext context) async {
    final status = await Permission.notification.status;
    if (!status.isGranted) return;

    await NotifiService().showNotification(
      100,
      'RunMates',
      'Selamat Datang! Akun kamu berhasil dibuat.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrationProvider>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.textSecondary,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: provider.isLoading
                          ? null
                          : () => _submitAndGoNext(context),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF4B4B4B,
                        ).withOpacity(0.6),
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'Nanti aja',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Aktifkan \nnotifikasi yuk',
                    style: AppTextStyles.heading3(
                      weight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Biar RunMates bisa ingetin kamu tentang latihan kamu',
                    style: AppTextStyles.paragraph1(
                      weight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const NotificationCard(
                    title: 'Waktunya lari harian kamu',
                    description:
                        'Lari 30 menit aja udah cukup buat jaga kebugaran dan progress menuju target bulanan kamu',
                  ),
                  const SizedBox(height: 16),
                  const NotificationCard(
                    title: 'Tinggal 5 km lagi menuju target kamu!',
                    description:
                        'Lari sebentar hari ini bisa bantu kamu capai target bulanan kamu lho',
                  ),
                  const Spacer(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 24,
                      ),
                      child: SizedBox(
                        width: screenWidth * 0.6,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: provider.isLoading
                              ? null
                              : () {
                                  _requestNotificationPermission(context);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            elevation: 6,
                          ),
                          child: Text(
                            'Lanjutkan',
                            style: AppTextStyles.button(
                              weight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (provider.isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.textPrimary),
            ),
        ],
      ),
    );
  }
}
