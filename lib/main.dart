import 'package:flutter/material.dart';
import 'package:runmates/features/auth/login.dart';
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
      theme: ThemeData(fontFamily: "Outfit"),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
