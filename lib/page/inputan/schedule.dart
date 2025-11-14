import 'package:flutter/material.dart';
import 'package:runmates/permission/notifPermission.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final Set<String> _selectedDays = {};

  final List<String> _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  final Color _activeColor = const Color(0xFF00FFFF);
  final Color _inactiveColor = const Color(0xFF333333);
  final Color _backgroundColor = const Color(0XFF1A1A1A);

  // tombol hari ditekan
  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final screenWidth = width;
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                const Text(
                  'Hari apa aja kamu ada waktu luang?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kami tau kamu sibuk, pilih hari yang realistis buat kamu latihan',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                const SizedBox(height: 40),

                // Pilih hari
                const Text(
                  'Pilih hari',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Column(
                  children: _days.map((day) {
                    return _buildDayButton(day);
                  }).toList(),
                ),

                const SizedBox(height: 10),

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
                          Navigator.push(context, MaterialPageRoute(builder:(context) => NotificationPermissionScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
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
      ),
    );
  }

  // tombol hari
  Widget _buildDayButton(String day) {
    final bool isSelected = _selectedDays.contains(day);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => _toggleDay(day),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          decoration: BoxDecoration(
            color: _inactiveColor,
            borderRadius: BorderRadius.circular(15.0),
            border: isSelected
                ? Border.all(color: _activeColor, width: 2.5)
                : null,
          ),
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
