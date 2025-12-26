import 'package:flutter/material.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/features/main/program_day.dart';

class ProgramWeekPage extends StatelessWidget {
  const ProgramWeekPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pekanList = [
      {'pekan': 1, 'color': AppColors.primary},
      {'pekan': 2, 'color': AppColors.primary},
      {'pekan': 3, 'color': AppColors.primary},
      {'pekan': 4, 'color': AppColors.primary},
    ];

    final int totalWeeks = pekanList.length;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.textSecondary,
        title: Text(
          'Program Latihan',
          style: AppTextStyles.heading4(
            weight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: AppColors.textSecondary),
        ),
      ),
      body: Container(
        color: const Color(0XFFFAFAFA),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          itemCount: pekanList.length,
          itemBuilder: (context, index) {
            final item = pekanList[index];
            final bool isEnabled = item['pekan'] != 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 164,
                child: ElevatedButton(
                  onPressed: isEnabled
                      ? () {
                          final int selectedWeek = item['pekan'] as int;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProgramDayPage(
                                weekNumber: selectedWeek,
                                totalWeeks: totalWeeks,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item['color'],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'PEKAN',
                        style: TextStyle(
                          color: isEnabled ? Colors.white : Colors.white70,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${item['pekan']}',
                        style: TextStyle(
                          color: isEnabled ? Colors.white : Colors.white70,
                          fontSize: 96,
                          fontWeight: FontWeight.bold,
                          height: 0.9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
