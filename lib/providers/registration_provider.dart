import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:runmates/service/ai_training_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrationProvider extends ChangeNotifier {
  String email = '';
  String password = '';
  String fullName = '';
  int? gender;
  int age = 0;
  double heightCm = 0.0;
  double weightKg = 0.0;
  double targetDistanceKm = 0.0;
  int targetTimeMinutes = 0;
  List<String> availableDays = [];

  bool isLoading = false;

  void setAccountData(String emailVal, String usernameVal, String passwordVal) {
    email = emailVal;
    fullName = usernameVal;
    password = passwordVal;
    notifyListeners();
  }

  void setGender(int genderVal) {
    gender = genderVal;
    notifyListeners();
  }

  void setAge(int ageVal) {
    age = ageVal;
    notifyListeners();
  }

  void setHeight(double heightVal) {
    heightCm = heightVal;
    notifyListeners();
  }

  void setWeight(double weightVal) {
    weightKg = weightVal;
    notifyListeners();
  }

  void setGoal(double distanceVal, int timeVal) {
    targetDistanceKm = distanceVal;
    targetTimeMinutes = timeVal;
    notifyListeners();
  }

  void setSchedule(List<String> daysVal) {
    availableDays = daysVal;
    notifyListeners();
  }

  Future<String?> registerUser() async {
    try {
      isLoading = true;
      notifyListeners();

      final fcmToken = await FirebaseMessaging.instance.getToken();

      final supabase = Supabase.instance.client;

      final AuthResponse res = await supabase.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'full_name': fullName},
      );

      final User? user = res.user;

      if (user == null) {
        throw 'Gagal membuat user auth.';
      }

      await supabase.schema('runmates').from('profiles').insert({
        'id': user.id,
        'email': email.trim(),
        'full_name': fullName,
        'gender': gender,
        'age': age,
        'height_cm': heightCm,
        'weight_kg': weightKg,
        'target_distance_km': targetDistanceKm,
        'target_time_minutes': targetTimeMinutes,
        'available_days': availableDays,
        'fcm_token': fcmToken,
      });

      String genderStr = gender == 1 ? "Laki-laki" : "Perempuan";
      String profileSummary = "$genderStr, $age tahun, $weightKg kg, $heightCm cm";

      final aiService = AITrainingService();
      
      await aiService.generateAndSavePlan(
        userId: user.id,
        availableDays: availableDays,
        targetDistance: targetDistanceKm,
        targetTime: targetTimeMinutes,
        userProfile: profileSummary,
      );

      isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }
}
