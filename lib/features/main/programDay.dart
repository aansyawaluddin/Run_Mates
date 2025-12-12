import 'package:flutter/material.dart';
import 'package:runmates/features/main/detailProgram.dart';

class ProgramDayPage extends StatelessWidget {
  final int weekNumber;
  final int totalWeeks;

  const ProgramDayPage({
    super.key,
    required this.weekNumber,
    required this.totalWeeks,
  });

  final List<Map<String, dynamic>> dailyWorkouts = const [
    {'day': 'Senin', 'title': 'Easy Run', 'isCompleted': false},
    {'day': 'Selasa', 'title': 'Short Train', 'isCompleted': false},
    {'day': 'Rabu', 'title': 'Tempo Run', 'isCompleted': false},
    {'day': 'Kamis', 'title': 'Interval Run', 'isCompleted': false},
    {'day': 'Jumat', 'title': 'Interval Run', 'isCompleted': false},
    {'day': 'Sabtu', 'title': 'Interval Run', 'isCompleted': false},
    {'day': 'Minggu', 'title': 'Interval Run', 'isCompleted': false},
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0XFFFF5050);

    return Scaffold(
      backgroundColor: const Color(0XFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 18.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: const BoxDecoration(
                        color: primaryRed,
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
                          color: primaryRed,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 60),

                  Expanded(
                    child: Text(
                      'Pekan $weekNumber dari $totalWeeks',
                      style: const TextStyle(
                        color: primaryRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      // TODO: aksi ketika tap notifikasi
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Icon(
                        Icons.notifications_none,
                        color: primaryRed,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // List latihan
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                itemCount: dailyWorkouts.length,
                itemBuilder: (context, index) {
                  final workout = dailyWorkouts[index];
                  return _buildWorkoutCard(
                    context: context,
                    day: workout['day'] as String,
                    title: workout['title'] as String,
                    isCompleted: workout['isCompleted'] as bool,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProgramDetailPage(),
                        ),
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

  Widget _buildWorkoutCard({
    required BuildContext context,
    required String day,
    required String title,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    const Color primaryRed = Color(0xFFF44336);

    final Color cardColor = isCompleted ? primaryRed : Colors.white;
    final Color textColor = isCompleted ? Colors.white : primaryRed;
    final Border? border = isCompleted
        ? null
        : Border.all(color: primaryRed, width: 1.5);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: isCompleted ? null : onTap,
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(15),
            border: border,
            boxShadow: [
              if (isCompleted)
                BoxShadow(
                  color: primaryRed.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      color: isCompleted ? Colors.white : primaryRed,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (isCompleted)
                const Icon(Icons.check_circle, color: Colors.white, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
