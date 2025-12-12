import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:runmates/component/notifikasi.dart';
import 'package:runmates/features/input/finish.dart';
import 'package:runmates/service/notifService.dart';

class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({super.key});

  Future<void> _requestNotificationPermission(BuildContext context) async {
    try {
      final result = await Permission.notification.request();

      if (result.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terima kasih — notifikasi diaktifkan')),
        );

        await _showTestNotification(context);

        _goToNextPage(context);
      } else if (result.isPermanentlyDenied) {
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin notifikasi tidak diberikan')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi error: $e')));
    }
  }

  void _goToNextPage(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const FinishScreen()));
  }

  Future<void> _showTestNotification(BuildContext context) async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izin notifikasi belum diberikan.')),
      );
      return;
    }

    await NotifiService().showNotification(
      100,
      'RunMates',
      'Program anda sudah dibuat',
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0XFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _goToNextPage(context),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF4B4B4B).withOpacity(0.6),
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
              const SizedBox(height: 20),

              const Text(
                'Aktifkan \nnotifikasi yuk',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Biar RunMates bisa ingetin kamu tentang latihan kamu',
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),

              const SizedBox(height: 40),

              NotificationCard(
                title: 'Waktunya lari harian kamu',
                description:
                    'Lari 30 menit aja udah cukup buat jaga kebugaran dan progress menuju target bulanan kamu',
              ),

              const SizedBox(height: 16),

              NotificationCard(
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
                      onPressed: () {
                        _requestNotificationPermission(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0XFFFF5050),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        elevation: 6,
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
    );
  }
}
