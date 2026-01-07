import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/features/input/schedule.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  late final TextEditingController _distanceController;
  late final TextEditingController _hourController;
  late final TextEditingController _minuteController;
  late final TextEditingController _secondController;

  late final FocusNode _hourFocusNode;
  late final FocusNode _minuteFocusNode;
  late final FocusNode _secondFocusNode;

  int? _selectedDistance;

  bool _showErrorText = false;

  @override
  void initState() {
    super.initState();
    _distanceController = TextEditingController(text: '');
    _hourController = TextEditingController();
    _minuteController = TextEditingController();
    _secondController = TextEditingController();

    _hourFocusNode = FocusNode();
    _minuteFocusNode = FocusNode();
    _secondFocusNode = FocusNode();

    _distanceController.addListener(() {
      final value = int.tryParse(_distanceController.text);
      if (value != _selectedDistance) {
        setState(() {
          _selectedDistance = value;
        });
      }
    });
  }

  @override
  void dispose() {
    _distanceController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();

    _hourFocusNode.dispose();
    _minuteFocusNode.dispose();
    _secondFocusNode.dispose();
    super.dispose();
  }

  bool _validateInput() {
    final isDistanceFilled = _distanceController.text.isNotEmpty;
    final isTimeFilled =
        _hourController.text.isNotEmpty ||
        _minuteController.text.isNotEmpty ||
        _secondController.text.isNotEmpty;

    return isDistanceFilled && isTimeFilled;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.textSecondary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 24.0, left: 24.0, top: 35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Yuk set target kamu!",
                style: AppTextStyles.heading3(
                  weight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Pilih target jarak kamu atau atur sendiri sesuai keinginan",
                style: AppTextStyles.paragraph1(
                  weight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 24),

              if (_showErrorText)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'Ayo, isi target jarak dan waktu kamu dulu',
                    textAlign: TextAlign.start,
                    style: AppTextStyles.paragraph1(
                      weight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),

              // Pilihan Cepat
              Text(
                "Rekomendasi Kami",
                style: AppTextStyles.heading4(
                  weight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickOption("5K", 5),
                  _buildQuickOption("10K", 10),
                  _buildQuickOption("21K", 21),
                  _buildQuickOption("42K", 42),
                ],
              ),

              const SizedBox(height: 24),

              // Kustomisasi Target
              Text(
                "Kustomisasi Target",
                style: AppTextStyles.heading4(
                  weight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Distance Input
              Text(
                "Jarak",
                style: AppTextStyles.paragraph1(
                  weight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _distanceController,
                cursorColor: AppColors.primary,
                style: AppTextStyles.heading3(
                  weight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  suffixText: "KM",
                  suffixStyle: AppTextStyles.heading4(
                    weight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  filled: true,
                  fillColor: AppColors.textSecondary,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: _selectedDistance != null
                          ? AppColors.primary
                          : Colors.grey.shade400,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 4.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 24,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Time Input
              Text(
                "Waktu",
                style: AppTextStyles.paragraph1(
                  weight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              _TimeInput(
                hourController: _hourController,
                minuteController: _minuteController,
                secondController: _secondController,
                hourFocus: _hourFocusNode,
                minuteFocus: _minuteFocusNode,
                secondFocus: _secondFocusNode,
              ),

              const SizedBox(height: 60),

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
                        if (!_validateInput()) {
                          setState(() {
                            _showErrorText = true;
                          });
                          return; 
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScheduleScreen(),
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

  Widget _buildQuickOption(String label, int value) {
    final isSelected = _selectedDistance == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDistance = value;
            _distanceController.text = value.toString();
            FocusScope.of(context).unfocus();
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade400,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.heading4(
              weight: FontWeight.bold,
              color: isSelected
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget input waktu
class _TimeInput extends StatelessWidget {
  const _TimeInput({
    required this.hourController,
    required this.minuteController,
    required this.secondController,
    required this.hourFocus,
    required this.minuteFocus,
    required this.secondFocus,
  });

  final TextEditingController hourController;
  final TextEditingController minuteController;
  final TextEditingController secondController;

  final FocusNode hourFocus;
  final FocusNode minuteFocus;
  final FocusNode secondFocus;

  Widget _bracketBox(
    TextEditingController controller,
    String hint,
    FocusNode focus,
  ) {
    final commonStyle = AppTextStyles.heading2(
      weight: FontWeight.bold,
      color: AppColors.textPrimary,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("[ ", style: commonStyle),
        SizedBox(
          width: 50,
          child: TextField(
            controller: controller,
            focusNode: focus,
            cursorColor: AppColors.primary,
            textAlign: TextAlign.center,
            maxLength: 2,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: AppTextStyles.heading3(
              weight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              counterText: "",
              hintText: hint,
              hintStyle: commonStyle.copyWith(
                color: AppColors.textPrimary.withOpacity(0.3),
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        Text(" ]", style: commonStyle),
      ],
    );
  }

  Widget _colon() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Text(
      ":",
      style: AppTextStyles.heading2(
        weight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _bracketBox(hourController, "00", hourFocus),
        _colon(),
        _bracketBox(minuteController, "00", minuteFocus),
        _colon(),
        _bracketBox(secondController, "00", secondFocus),
      ],
    );
  }
}
