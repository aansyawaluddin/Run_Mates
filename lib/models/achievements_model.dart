class AchievementModel {
  final int id;
  final String title;
  final String imageUrl;

  AchievementModel({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      imageUrl: json['image_path'] ?? '', 
    );
  }
}

class UserAchievementModel {
  final int id;
  final AchievementModel achievement;

  UserAchievementModel({
    required this.id,
    required this.achievement,
  });

  factory UserAchievementModel.fromJson(Map<String, dynamic> json) {
    return UserAchievementModel(
      id: json['id'] ?? 0,
      // Karena kita pakai select('*, achievements(*)') maka data achievement ada di key 'achievements'
      achievement: AchievementModel.fromJson(json['achievements'] ?? {}),
    );
  }
}