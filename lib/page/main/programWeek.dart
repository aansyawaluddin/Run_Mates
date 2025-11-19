import 'package:flutter/material.dart';
import 'package:runmates/page/main/programDay.dart';

class ProgramWeekPage extends StatelessWidget {
  const ProgramWeekPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pekanList = [
      {'pekan': 1, 'color': const Color(0xFFF44336)},
      {'pekan': 2, 'color': const Color(0xFFF44336)},
      {'pekan': 3, 'color': const Color(0xFFF44336)},
      {'pekan': 4, 'color': const Color(0xFFF44336)},
    ];

    final int totalWeeks = pekanList.length;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0XFFFAFAFA),
        title: const Text(
          'Program Latihan',
          style: TextStyle(
            color: Color(0xFFF44336),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.notifications_none,
              color: Color(0xFFF44336),
              size: 28,
            ),
          ),
        ],
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Color(0XFFFAFAFA)),
        ),
      ),
      body: Container(
        color: const Color(0XFFFAFAFA),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: pekanList.length,
          itemBuilder: (context, index) {
            final item = pekanList[index];
            final bool isEnabled = item['pekan'] != 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 140,
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
                          print(
                            'Navigasi ke Week $selectedWeek dari $totalWeeks minggu',
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
                  child: Center(
                    child: Text(
                      'PEKAN ${item['pekan']}',
                      style: TextStyle(
                        color: isEnabled ? Colors.white : Colors.white70,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
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
