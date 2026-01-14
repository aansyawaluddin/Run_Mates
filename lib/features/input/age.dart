import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmates/cores/app_colors.dart';
import 'package:runmates/cores/app_text_styles.dart';
import 'package:runmates/features/input/height.dart';
import 'package:runmates/providers/registration_provider.dart';

class AgePage extends StatefulWidget {
  const AgePage({super.key});

  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  final TextEditingController _ageController = TextEditingController();
  bool _isInputEmpty = false;

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;

    return Scaffold(
      backgroundColor: AppColors.textSecondary,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 45),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Berapa umur kamu?",
                    style: AppTextStyles.heading3(
                      weight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Setiap umur punya kapasitas berbeda, kami sesuaikan latihan buat usia kamu",
                    textAlign: TextAlign.start,
                    style: AppTextStyles.paragraph1(
                      weight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: _isInputEmpty ? Colors.red : AppColors.primary,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            style: AppTextStyles.heading3(
                              weight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: "Contoh : 25",
                              hintStyle: AppTextStyles.heading3(
                                weight: FontWeight.bold,
                                color: Colors.grey.shade400,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (value) {
                              if (_isInputEmpty) {
                                setState(() {
                                  _isInputEmpty = false;
                                });
                              }
                            },
                          ),
                        ),
                        Text(
                          "Tahun",
                          style: AppTextStyles.heading3(
                            weight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_isInputEmpty) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        "Isi umur kamu dulu ya",
                        style: AppTextStyles.paragraph1(
                          weight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
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
                    if (_ageController.text.isEmpty) {
                      setState(() {
                        _isInputEmpty = true;
                      });
                      return;
                    }

                    int? ageValue = int.tryParse(_ageController.text);

                    if (ageValue == null) {
                      return;
                    }
                    context.read<RegistrationProvider>().setAge(ageValue);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HeightPage(),
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
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
