import 'package:flutter/material.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/features/input/weight.dart';

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
      backgroundColor: AppColors.textSecondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    "Berapa tinggi badan kamu?",
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

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "$_currentHeight",
                        style: AppTextStyles.display1(
                          weight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Cm",
                        style: AppTextStyles.heading4(
                          weight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 420,
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
      height: 380,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 90,
              height: 380,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Wheel dengan ticks
          Positioned(
            left: 0,
            child: SizedBox(
              width: 90,
              height: 380,
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
                        color: AppColors.textSecondary,
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
              height: 380,
              child: Center(
                child: Container(
                  height: 6,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary,
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
                painter: TriangleLeftPainter(color: AppColors.textPrimary),
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
      height: 380,
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
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textPrimary,
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
  TriangleLeftPainter({this.color = AppColors.textSecondary});

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
