import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:runmates/models/program_week_model.dart';
import 'package:runmates/models/daily_schedule_model.dart';

class ProgramProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<ProgramWeekModel> _weeks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProgramWeekModel> get weeks => _weeks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<DailyScheduleModel> _dailySchedules = [];
  bool _isDayLoading = false;

  List<DailyScheduleModel> get dailySchedules => _dailySchedules;
  bool get isDayLoading => _isDayLoading;

  Future<void> fetchProgramWeeks() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw 'User tidak ditemukan (belum login).';
      }

      final response = await _supabase
          .schema('runmates')
          .from('program_weeks')
          .select()
          .eq('user_id', userId)
          .order('week_number', ascending: true);

      final List<dynamic> data = response;
      _weeks = data.map((json) => ProgramWeekModel.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = 'Gagal memuat program: $e';
      debugPrint("Error fetching weeks: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDailySchedules(int weekId) async {
    try {
      _isDayLoading = true;
      _dailySchedules = [];
      notifyListeners();

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await _supabase
          .schema('runmates')
          .from('daily_schedules')
          .select()
          .eq('week_id', weekId)
          .eq('user_id', userId)
          .order('id', ascending: true); 

      final List<dynamic> data = response;
      _dailySchedules = data
          .map((json) => DailyScheduleModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint("Error fetching daily schedules: $e");
    } finally {
      _isDayLoading = false;
      notifyListeners();
    }
  }

  Future<void> markScheduleAsDone(int scheduleId) async {
    try {
      await _supabase
          .schema('runmates')
          .from('daily_schedules')
          .update({
            'is_done': true,
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', scheduleId);

      final index = _dailySchedules.indexWhere((item) => item.id == scheduleId);
      if (index != -1) {
        final oldItem = _dailySchedules[index];
        final newItem = DailyScheduleModel(
          id: oldItem.id,
          weekId: oldItem.weekId,
          dayName: oldItem.dayName,
          workoutTitle: oldItem.workoutTitle,
          workoutSubtitle: oldItem.workoutSubtitle,
          workoutObjective: oldItem.workoutObjective,
          durationMinutes: oldItem.durationMinutes,
          steps: oldItem.steps,
          isDone: true, 
        );

        _dailySchedules[index] = newItem;
        notifyListeners(); 
      }
    } catch (e) {
      debugPrint("Gagal update status selesai: $e");
      rethrow; 
    }
  }
}
