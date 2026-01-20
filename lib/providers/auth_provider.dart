import 'package:flutter/material.dart';
import 'package:runmates/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

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

  Future<void> loadUserProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final response = await Supabase.instance.client
          .schema('runmates')
          .from('profiles')
          .update({'is_plan_ready': true})
          .eq('id', user.id) 
          .select() 
          .single();

      _currentUser = UserModel.fromJson(response);
      notifyListeners();
    } catch (e) {
      debugPrint("Gagal memuat profil: $e");
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
