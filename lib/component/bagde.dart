import 'package:flutter/material.dart';

void showBadgeUnlockPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return const BadgeUnlockDialog();
    },
  );
}

class BadgeUnlockDialog extends StatelessWidget {
  const BadgeUnlockDialog({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0XFFFF5050);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),

            const Text(
              "Badge baru terbuka!",
              style: TextStyle(
                fontSize: 14,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),

            Image.asset(
              'assets/images/bagde.png',
              height: 180,
              width: 180,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            const Text(
              "Luar Biasa!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              "Target 20K Telah Tercapai",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            const Text(
              "Kamu telah menyelesaikan program\ndalam 12 minggu",
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  shadowColor: primaryColor.withOpacity(0.4),
                ),
                child: const Text(
                  "Tantang Diri Lebih Jauh",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: primaryColor,
                      width: 1,
                    ), // Border merah
                  ),
                  elevation: 3, // Tetap ada shadow sesuai gambar
                  shadowColor: Colors.grey.withOpacity(0.2),
                ),
                child: const Text(
                  "Lihat Progres",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
