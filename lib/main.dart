import 'package:flutter/material.dart';
import 'package:runmates/page/login/login.dart';


void main() async {
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
