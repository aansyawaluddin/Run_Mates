class UserModel {
  final String id;
  final String email;
  final String fullName;
  final int age;
  final double heightCm;
  final double weightKg;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.age,
    required this.heightCm,
    required this.weightKg,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? 'User',
      age: json['age'] ?? 0,
      heightCm: (json['height_cm'] as num?)?.toDouble() ?? 0.0,
      weightKg: (json['weight_kg'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
