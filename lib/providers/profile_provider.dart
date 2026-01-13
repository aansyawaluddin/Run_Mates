import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:runmates/models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _user;
  UserModel? get user => _user;

  Future<String?> updateProfile({
    required String fullName,
    required int age,
    required double weight,
    required double height,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) throw "User tidak ditemukan";

      await Supabase.instance.client
          .schema('runmates')
          .from('profiles')
          .update({
            'full_name': fullName,
            'age': age,
            'weight_kg': weight,
            'height_cm': height,
          })
          .eq('id', currentUser.id);


      _isLoading = false;
      notifyListeners();
      return null; 
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString(); 
    }
  }
}
