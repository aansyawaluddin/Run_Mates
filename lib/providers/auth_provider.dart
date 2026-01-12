import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<String?> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final supabase = Supabase.instance.client;

      await supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      _isLoading = false;
      notifyListeners();
      return null; 

    } on AuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message; 
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Terjadi kesalahan jaringan atau server';
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    notifyListeners();
  }
}