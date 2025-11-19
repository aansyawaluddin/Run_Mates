import 'package:flutter/material.dart';

class ProgramPage extends StatelessWidget {
  const ProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pekanList = [
      {'pekan': 1, 'color': const Color(0xFFF44336)},
      {'pekan': 2, 'color': const Color(0xFFF44336)},
      {'pekan': 3, 'color': const Color(0xFFF44336)},
      {'pekan': 4, 'color': const Color(0xFFF44336)},
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
      ),
      body: Container(
        color: Colors.white,
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
                          // Aksi saat tombol ditekan
                          print('Tombol Pekan ${item['pekan']} ditekan');
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
