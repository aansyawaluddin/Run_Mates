import 'package:flutter/material.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';

class FinishConfirmation extends StatelessWidget {
  final VoidCallback onConfirm;

  const FinishConfirmation({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Selesaikan Latihan Hari Ini?',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading5(
                weight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Pastikan kamu udah menyelesaikan semua langkah latihan hari ini ya',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading4Uppercase(
                weight: FontWeight.normal,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              height: 45,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        elevation: 5,
                        shadowColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Belum',
                        style: AppTextStyles.button2(
                          weight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: AppColors.primary,
                        elevation: 5,
                        shadowColor: AppColors.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Ya, Udah Selesai',
                        style: AppTextStyles.button2(
                          weight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
