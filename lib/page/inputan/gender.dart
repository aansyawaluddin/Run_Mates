import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GenderSelectionPage extends StatefulWidget {
  const GenderSelectionPage({super.key});

  @override
  State<GenderSelectionPage> createState() => _GenderSelectionPageState();
}

enum Gender { male, female }

class _GenderSelectionPageState extends State<GenderSelectionPage> {
  final Color _primaryColor = const Color(0XFF00F0FF);
  final Color _darkBackground = const Color(0XFF1A1A1A);

  Gender? _selectedGender;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.07;

    return Scaffold(
      backgroundColor: _darkBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30.0),

              Text(
                'Yuk kenalan dulu, kamu cowok atau cewek?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),

              const SizedBox(height: 12.0),

              Text(
                'Pria dan wanita butuh pendekatan latihan yang beda, kami sesuaikan buat kamu',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Outfit',
                ),
              ),

              const SizedBox(height: 40.0),

              // Card Laki-laki
              _buildGenderCard(
                title: 'Cowok',
                icon: FontAwesomeIcons.mars,
                imageAsset: 'assets/images/male.png',
                value: Gender.male,
              ),

              const SizedBox(height: 24.0),

              // Card Perempuan
              _buildGenderCard(
                title: 'Cewek',
                icon: FontAwesomeIcons.venus,
                imageAsset: 'assets/images/female.png',
                value: Gender.female,
              ),

              const Spacer(),

              // Continue
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0, top: 20.0),
                  child: SizedBox(
                    width: screenWidth * 0.6,
                    height: 56,
                    child: TextButton(
                      onPressed: () {
                        if (_selectedGender == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Silakan pilih gender terlebih dahulu',
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => AgePage()),
                        // );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: _primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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

  // Widget Card Gender
  Widget _buildGenderCard({
    required String title,
    required IconData icon,
    required String imageAsset,
    required Gender value,
  }) {
    final bool isSelected = (_selectedGender == value);

    final Widget checkboxIcon = Icon(
      isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
      color: isSelected ? _primaryColor : Colors.black,
      size: 28,
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        height: 160,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: isSelected ? _primaryColor : Colors.transparent,
            width: 3.0,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -20,
              right: -10,
              child: Image.asset(
                imageAsset,
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 160,
                  width: 150,
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Text(
                      'Image \nNot Found',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FaIcon(
                        icon,
                        color: isSelected ? _primaryColor : Colors.black,
                        size: 26,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  checkboxIcon,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
