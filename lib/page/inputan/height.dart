import 'package:flutter/material.dart';
import 'package:runmates/page/inputan/weight.dart';

class HeightPage extends StatefulWidget {
  const HeightPage({super.key});

  @override
  State<HeightPage> createState() => _HeightPageState();
}

class _HeightPageState extends State<HeightPage> {
  int _currentHeight = 165;
  final int _minHeight = 100;
  final int _maxHeight = 220;

  late FixedExtentScrollController _scrollController;
  late FixedExtentScrollController _labelScrollController;

  @override
  void initState() {
    super.initState();

    int initialItem = _currentHeight - _minHeight;
    _scrollController = FixedExtentScrollController(initialItem: initialItem);
    _labelScrollController = FixedExtentScrollController(
      initialItem: initialItem,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _labelScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    return Scaffold(
      backgroundColor: const Color(0XFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Berapa tinggi badan kamu?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Setiap usia punya kapasitas berbeda, kami sesuaikan latihan buat usia kamu",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ],
              ),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "$_currentHeight",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Cm",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStaticLabels(),
                        const SizedBox(width: 12),
                        _buildPicker(),
                      ],
                    ),
                  ),
                ],
              ),

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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WeightScreen(),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Picker
  Widget _buildPicker() {
    return SizedBox(
      width: 120,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 90,
              height: 300,
              decoration: BoxDecoration(
                color: Color(0XFFFF5050),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Wheel dengan ticks
          Positioned(
            left: 0,
            child: SizedBox(
              width: 90,
              height: 300,
              child: ListWheelScrollView.useDelegate(
                controller: _scrollController,
                itemExtent: 30,
                perspective: 0.005,
                diameterRatio: 1.5,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    _currentHeight = _minHeight + index;
                  });

                  if (_labelScrollController.hasClients) {
                    if (_labelScrollController.selectedItem != index) {
                      _labelScrollController.jumpToItem(index);
                    }
                  }
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: _maxHeight - _minHeight + 1,
                  builder: (context, index) {
                    int currentNumber = _minHeight + index;
                    bool isBigTick = (currentNumber % 10 == 0);
                    bool isMediumTick = (currentNumber % 5 == 0);

                    double tickWidth = isBigTick
                        ? 60
                        : (isMediumTick ? 40 : 20);

                    return Center(
                      child: Container(
                        width: tickWidth,
                        height: 2,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          //garis
          Positioned(
            left: 0,
            child: SizedBox(
              width: 90,
              height: 300,
              child: Center(
                child: Container(
                  height: 6,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            right: 5,
            child: SizedBox(
              width: 18,
              height: 15,
              child: CustomPaint(
                painter: TriangleLeftPainter(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Label
  Widget _buildStaticLabels() {
    int minLabel = _minHeight;
    int labelCount = _maxHeight - _minHeight + 1;

    double labelItemExtent = 30.0;

    return Container(
      width: 50,
      height: 300,
      child: IgnorePointer(
        child: ListWheelScrollView.useDelegate(
          controller: _labelScrollController,
          itemExtent: labelItemExtent,
          perspective: 0.005,
          diameterRatio: 1.5,
          physics: const NeverScrollableScrollPhysics(),
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: labelCount,
            builder: (context, index) {
              int value = minLabel + index;
              final isSelected = value == _currentHeight;

              return Center(
                child: Text(
                  "$value",
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.black,
                    fontSize: isSelected ? 18 : 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TriangleLeftPainter extends CustomPainter {
  final Color color;
  TriangleLeftPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    // segitiga menunjuk ke kiri
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
