class ProgramWeekModel {
  final int id;
  final int weekNumber;
  final String? title;
  final String? description;

  ProgramWeekModel({
    required this.id,
    required this.weekNumber,
    this.title,
    this.description,
  });

  factory ProgramWeekModel.fromJson(Map<String, dynamic> json) {
    return ProgramWeekModel(
      id: json['id'] as int,
      weekNumber: json['week_number'] as int,
      title: json['title'] as String?,
      description: json['description'] as String?,
    );
  }
}