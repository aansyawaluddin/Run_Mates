import 'package:flutter/material.dart';
import 'package:runmates/models/achievements_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AchievementProvider extends ChangeNotifier {
  bool _isLoading = false;

  List<UserAchievementModel> _myAchievements = [];

  List<AchievementModel> _displayBadges = [];
  final Set<String> _unlockedTitles = {};

  bool get isLoading => _isLoading;
  List<UserAchievementModel> get myAchievements => _myAchievements; 
  List<AchievementModel> get displayBadges => _displayBadges;

  bool isUnlocked(String title) {
    return _unlockedTitles.contains(title);
  }


  Future<void> fetchProfileAchievements() async {
    try {
      _isLoading = true; 
      notifyListeners();

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final response = await Supabase.instance.client
          .schema('runmates')
          .from('user_achievements')
          .select('*, achievements(*)')
          .eq('user_id', user.id)
          .order('unlocked_at', ascending: false) 
          .limit(3); 

      final List<dynamic> data = response;
      _myAchievements = data.map((json) => UserAchievementModel.fromJson(json)).toList();

    } catch (e) {
      debugPrint("Gagal load profile achievements: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllBadges() async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final userResponse = await Supabase.instance.client
          .schema('runmates')
          .from('user_achievements')
          .select('*, achievements(*)')
          .eq('user_id', user.id);
      
      final List<dynamic> userData = userResponse;
      final userAchievements = userData.map((json) => UserAchievementModel.fromJson(json)).toList();

      _unlockedTitles.clear();
      for (var item in userAchievements) {
        _unlockedTitles.add(item.achievement.title);
      }

      final masterResponse = await Supabase.instance.client
          .schema('runmates')
          .from('achievements')
          .select()
          .gte('id', 12) 
          .lte('id', 22) 
          .order('id', ascending: true);

      final List<dynamic> masterData = masterResponse;
      final List<AchievementModel> lockedTemplates = masterData.map((json) => AchievementModel.fromJson(json)).toList();

      _displayBadges = [];

      for (var lockedItem in lockedTemplates) {
        if (_unlockedTitles.contains(lockedItem.title)) {
          final unlockedItem = userAchievements.firstWhere(
            (u) => u.achievement.title == lockedItem.title
          );
          _displayBadges.add(unlockedItem.achievement);
        } else {
          _displayBadges.add(lockedItem);
        }
      }

    } catch (e) {
      debugPrint("Gagal load all badges: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}