import 'package:flutter/material.dart';
import 'package:runmates/cores/app_theme.dart';
import 'package:runmates/onboarding_screen.dart';
import 'package:runmates/service/notifService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotifiService().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Runmates',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const OnboardingScreen(),
    );
  }
}
