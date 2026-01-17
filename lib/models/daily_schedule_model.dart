class DailyScheduleModel {
  final int id;
  final int weekId;
  final String dayName;
  final String workoutTitle;
  final String? workoutSubtitle;
  final String? workoutObjective;
  final int durationMinutes;
  final Map<String, dynamic> steps; 
  final bool isDone;

  DailyScheduleModel({
    required this.id,
    required this.weekId,
    required this.dayName,
    required this.workoutTitle,
    this.workoutSubtitle,
    this.workoutObjective,
    required this.durationMinutes,
    required this.steps,
    required this.isDone,
  });

  factory DailyScheduleModel.fromJson(Map<String, dynamic> json) {
    return DailyScheduleModel(
      id: json['id'] as int,
      weekId: json['week_id'] as int,
      dayName: json['day_name'] as String,
      workoutTitle: json['workout_title'] as String,
      workoutSubtitle: json['workout_subtitle'] as String?,
      workoutObjective: json['workout_objective'] as String?,
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      steps: json['steps'] != null ? json['steps'] as Map<String, dynamic> : {},
      isDone: json['is_done'] as bool? ?? false,
    );
  }
}