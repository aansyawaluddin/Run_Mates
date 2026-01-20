class DailyScheduleModel {
  final int id;
  final int weekId;
  final DateTime scheduledDate; 
  final String workoutTitle;
  final String workoutSubtitle;
  final String? workoutObjective;
  final int durationMinutes;
  final Map<String, dynamic> steps;
  final bool isDone;

  DailyScheduleModel({
    required this.id,
    required this.weekId,
    required this.scheduledDate,
    required this.workoutTitle,
    required this.workoutSubtitle,
    this.workoutObjective,
    required this.durationMinutes,
    required this.steps,
    required this.isDone,
  });

  String get dayName {
    const List<String> days = [
      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
    ];
    return days[scheduledDate.weekday - 1];
  }

  factory DailyScheduleModel.fromJson(Map<String, dynamic> json) {
    return DailyScheduleModel(
      id: json['id'] as int,
      weekId: json['week_id'] as int,
      scheduledDate: DateTime.parse(json['scheduled_date']), 
      workoutTitle: json['workout_title'] as String,
      workoutSubtitle: json['workout_subtitle'] as String,
      workoutObjective: json['workout_objective'] as String?,
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      steps: json['steps'] != null ? json['steps'] as Map<String, dynamic> : {},
      isDone: json['is_done'] as bool? ?? false,
    );
  }
}