import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:runmates/page/inputan/schedule.dart';

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

  static const Color RedColor = Color(0XFFFF5050);
  static const Color kBg = Color(0XFFFAFAFA);
  static const Color kFill = Color(0XFFFAFAFA);
  static const Color kEnabledBorder = Color(0XFFFAFAFA);

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Yuk set target kamu!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Berapa KM yang mau kamu taklukkan dan dalam waktu berapa?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 60),

              // Distance
              const Text(
                "Distance",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _distanceController,
                cursorColor: RedColor,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  suffixText: "KM",
                  suffixStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: kFill,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: kEnabledBorder,
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: RedColor, width: 4.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Time
              const Text(
                "Time",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Time input
              _TimeInput(
                hourController: _hourController,
                minuteController: _minuteController,
                secondController: _secondController,
                hourFocus: _hourFocusNode,
                minuteFocus: _minuteFocusNode,
                secondFocus: _secondFocusNode,
                enabledBorderColor: kEnabledBorder,
                focusedBorderColor: RedColor,
                fillColor: kFill,
              ),

              const SizedBox(height: 160),

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
                            builder: (context) => const ScheduleScreen(),
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
}

/// Widget input waktu dengan 3 TextField: jam, menit, detik
class _TimeInput extends StatefulWidget {
  const _TimeInput({
    required this.hourController,
    required this.minuteController,
    required this.secondController,
    required this.hourFocus,
    required this.minuteFocus,
    required this.secondFocus,
    required this.enabledBorderColor,
    required this.focusedBorderColor,
    required this.fillColor,
  });

  final TextEditingController hourController;
  final TextEditingController minuteController;
  final TextEditingController secondController;

  final FocusNode hourFocus;
  final FocusNode minuteFocus;
  final FocusNode secondFocus;

  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final Color fillColor;

  @override
  State<_TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<_TimeInput> {
  bool get _isAnyFocused =>
      widget.hourFocus.hasFocus ||
      widget.minuteFocus.hasFocus ||
      widget.secondFocus.hasFocus;

  @override
  void initState() {
    super.initState();
    widget.hourFocus.addListener(_onFocus);
    widget.minuteFocus.addListener(_onFocus);
    widget.secondFocus.addListener(_onFocus);
  }

  void _onFocus() => setState(() {});

  @override
  void dispose() {
    widget.hourFocus.removeListener(_onFocus);
    widget.minuteFocus.removeListener(_onFocus);
    widget.secondFocus.removeListener(_onFocus);
    super.dispose();
  }

  Widget _bracketBox(
    TextEditingController controller,
    String hint,
    FocusNode focus,
  ) {
    return SizedBox(
      width: 80,
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "[",
            style: TextStyle(
              color: Colors.black,
              fontSize: 50,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Center(
              child: TextField(
                controller: controller,
                focusNode: focus,
                cursorColor: widget.focusedBorderColor,
                textAlign: TextAlign.center,
                maxLength: 2,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.only(bottom: 4),
                ),
              ),
            ),
          ),
          const Text(
            "]",
            style: TextStyle(
              color: Colors.black,
              fontSize: 50,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _colon() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Text(
      ":",
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.fillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isAnyFocused
              ? widget.focusedBorderColor
              : widget.enabledBorderColor,
          width: _isAnyFocused ? 4.0 : 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _bracketBox(widget.hourController, "00", widget.hourFocus),
          _colon(),
          _bracketBox(widget.minuteController, "00", widget.minuteFocus),
          _colon(),
          _bracketBox(widget.secondController, "00", widget.secondFocus),
        ],
      ),
    );
  }
}
