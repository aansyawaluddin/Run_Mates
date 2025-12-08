import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runmates/page/login/login.dart';
import 'package:runmates/home.dart';
import 'package:runmates/providers/app_provider.dart';
import 'package:runmates/providers/auth_provider.dart';
import 'package:runmates/providers/navigation_provider.dart';
import 'package:runmates/providers/program_provider.dart';
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
    return MultiProvider(
      providers: [
        // Auth Provider - untuk mengelola autentikasi user
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Navigation Provider - untuk mengelola navigasi halaman
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        // Program Provider - untuk mengelola data program lari
        ChangeNotifierProvider(create: (_) => ProgramProvider()),
        // App Provider - untuk state umum aplikasi
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          return MaterialApp(
            theme: ThemeData(fontFamily: "Outfit"),
            debugShowCheckedModeBanner: false,
            home: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                // Jika sudah login, tampilkan MainScreen, jika tidak tampilkan LoginScreen
                return authProvider.isAuthenticated
                    ? const MainScreen()
                    : const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
