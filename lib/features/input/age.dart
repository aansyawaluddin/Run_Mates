import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/features/input/height.dart';

class AgePage extends StatefulWidget {
  const AgePage({super.key});

  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  int _currentAge = 21;

  static const double _barHeight = 99.0;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;

    return Scaffold(
      backgroundColor: AppColors.textSecondary,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 65),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Berapa usia kamu?",
                    style: AppTextStyles.heading3(
                      weight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Setiap usia punya kapasitas berbeda, kami sesuaikan latihan buat usia kamu",
                    textAlign: TextAlign.start,
                    style: AppTextStyles.paragraph1(
                      weight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 108),

            Column(
              children: [
                Text(
                  "$_currentAge",
                  style: AppTextStyles.display1(
                    weight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                const Icon(Icons.arrow_drop_up, color: Colors.black, size: 90),
                const SizedBox(height: 16),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: _barHeight,
                      width: double.infinity,
                      color: AppColors.primary,
                      child: Center(
                        child: NumberPicker(
                          value: _currentAge,
                          minValue: 10,
                          maxValue: 99,
                          step: 1,
                          axis: Axis.horizontal,
                          itemWidth: 120,

                          onChanged: (newValue) {
                            setState(() {
                              _currentAge = newValue;
                            });
                          },
                          textStyle: AppTextStyles.heading3(
                            weight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ).copyWith(height: 1.0),

                          selectedTextStyle: AppTextStyles.heading2(
                            weight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ).copyWith(height: 1.0),
                        ),
                      ),
                    ),

                    // Garis Putih
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 2,
                            height: _barHeight,
                            color: AppColors.textSecondary,
                          ),

                          SizedBox(width: 110),

                          Container(
                            width: 2,
                            height: _barHeight,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Spacer(flex: 3),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 24,
              ),
              child: SizedBox(
                width: screenWidth * 0.6,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HeightPage(),
                      ),
                    );
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
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
