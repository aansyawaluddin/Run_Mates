import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:runmates/page/inputan/height.dart';

class AgePage extends StatefulWidget {
  const AgePage({super.key});

  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  int _currentAge = 21;

  static const double _selectedItemWidth = 90.0;
  static const double _barHeight = 70.0;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;

    return Scaffold(
      backgroundColor: const Color(0XFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Berapa usia kamu?",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Setiap usia punya kapasitas berbeda, kami sesuaikan latihan buat usia kamu",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 2),

            Column(
              children: [
                Text(
                  "$_currentAge",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(
                  Icons.arrow_drop_up,
                  color: Colors.black,
                  size: 50,
                ),
                const SizedBox(height: 16),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Bar cyan
                    Container(
                      height: _barHeight,
                      width: double.infinity,
                      color: Color(0XFFFF5050),
                      child: Center(
                        child: NumberPicker(
                          value: _currentAge,
                          minValue: 10,
                          maxValue: 99,
                          step: 1,
                          axis: Axis.horizontal,
                          itemWidth: 90,
                          onChanged: (newValue) {
                            setState(() {
                              _currentAge = newValue;
                            });
                          },
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                          ),
                          selectedTextStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // garis kiri
                          Container(
                            width: 2,
                            height: _barHeight,
                            color: Colors.white,
                          ),

                          SizedBox(width: _selectedItemWidth),

                          // garis kanan
                          Container(
                            width: 2,
                            height: _barHeight,
                            color: Colors.white,
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
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
