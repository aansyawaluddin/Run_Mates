import 'package:flutter/material.dart';
import 'package:runmates/page/inputan/goal.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  double _currentValue = 65.0;
  final int _minValue = 40;
  final int _maxValue = 150;

  late PageController _tickController;
  late PageController _labelController;

  // each 1 kg = 10 steps (0.1)
  late final int _totalTicks;

  @override
  void initState() {
    super.initState();
    _totalTicks = (_maxValue - _minValue) * 10 + 1;
    final initialPage = ((_currentValue - _minValue) * 10).toInt();

    _tickController = PageController(
      initialPage: initialPage,
      viewportFraction: 0.06,
    );

    _labelController = PageController(
      initialPage: initialPage,
      viewportFraction: 0.18,
    );
  }

  @override
  void dispose() {
    _tickController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    final value = _minValue + index / 10.0;
    setState(() => _currentValue = double.parse(value.toStringAsFixed(1)));

    if (_labelController.hasClients &&
        (_labelController.page?.round() ?? -1) != index) {
      _labelController.jumpToPage(index);
    }
  }

  String _displayValue() {
    if ((_currentValue - _currentValue.toInt()).abs() < 0.001) {
      return _currentValue.toInt().toString();
    } else {
      return _currentValue.toStringAsFixed(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final screenWidth = width;
    return Scaffold(
      backgroundColor: const Color(0XFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 30),
                    Text(
                      "Berapa berat badan\nkamu sekarang?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Tenang, ini cuma buat kami kasih latihan yang aman dan sesuai sama kemampuan kamu",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 70),

            SizedBox(
              height: 56,
              width: width,
              child: PageView.builder(
                controller: _labelController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _totalTicks,
                itemBuilder: (context, index) {
                  final value = _minValue + index / 10.0;
                  final isIntegerKg = index % 10 == 0;
                  final isSelected =
                      (value - _currentValue).abs() < 0.001 && isIntegerKg;
                  if (!isIntegerKg) {
                    return const SizedBox.shrink();
                  }

                  return Center(
                    child: Text(
                      '${value.toInt()}',
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.black,
                        fontSize: isSelected ? 30 : 18,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 6),

            // bar ticks
            SizedBox(
              height: 120,
              width: width,
              child: Center(
                child: SizedBox(
                  width: width,
                  height: 96,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: 96,
                            decoration: BoxDecoration(
                              color: Color(0XFFFF5050),
                            ),
                          ),
                        ),
                      ),

                      // ticks
                      Positioned.fill(
                        child: Center(
                          child: SizedBox(
                            height: 96,
                            width: double.infinity,
                            child: PageView.builder(
                              controller: _tickController,
                              scrollDirection: Axis.horizontal,
                              itemCount: _totalTicks,
                              onPageChanged: _onPageChanged,
                              itemBuilder: (context, index) {
                                // index step = 0.1 kg
                                final isBig = index % 10 == 0; // tiap 1 kg
                                final isMedium =
                                    index % 5 == 0 && !isBig; // tiap 0.5 kg
                                final tickHeight = isBig
                                    ? 44.0 
                                    : (isMedium ? 26.0 : 12.0);
                                final tickWidth = isBig ? 6.0 : 2.0;
                                final tickRadius = isBig ? 3.0 : 2.0;

                                final tickValue = _minValue + index / 10.0;
                                final isSelectedBig =
                                    isBig &&
                                    (tickValue - _currentValue).abs() < 0.001;

                                return Center(
                                  child: Container(
                                    width: tickWidth,
                                    height: tickHeight,
                                    decoration: BoxDecoration(
                                      color: isSelectedBig
                                          ? Colors.white
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        tickRadius,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // Garis merah di tengah
                      Positioned(
                        child: Container(
                          width: 6,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      // pointer
                      Positioned(
                        bottom: -30,
                        child: SizedBox(
                          width: 32,
                          height: 20,
                          child: CustomPaint(
                            painter: TriangleUpPainter(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    _displayValue(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Kg',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GoalsPage(),
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
    );
  }
}

// Pointer
class TriangleUpPainter extends CustomPainter {
  final Color color;
  TriangleUpPainter({this.color = Colors.pink});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
