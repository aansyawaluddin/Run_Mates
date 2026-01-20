class UserModel {
  final String id;
  final String email;
  final String fullName;
  final int gender;
  final int age;
  final double heightCm;
  final double weightKg;
  final double targetDistanceKm;
  final int targetTimeMinutes;
  final List<String> availableDays;
  final String? fcmToken;
  final bool isPlanReady;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.gender,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.targetDistanceKm,
    required this.targetTimeMinutes,
    required this.availableDays,
    this.fcmToken,
    required this.isPlanReady,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? 'Runner',
      gender: _parseInt(json['gender']),
      age: _parseInt(json['age']),
      heightCm: _parseDouble(json['height_cm']),
      weightKg: _parseDouble(json['weight_kg']),
      targetDistanceKm: _parseDouble(json['target_distance_km']),
      targetTimeMinutes: _parseInt(json['target_time_minutes']),
      availableDays:
          (json['available_days'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],

      fcmToken: json['fcm_token']?.toString(),
      isPlanReady: json['is_plan_ready'] ?? false,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num)
      return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
