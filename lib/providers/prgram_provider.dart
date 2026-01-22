import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:runmates/models/program_week_model.dart';
import 'package:runmates/models/daily_schedule_model.dart';

class ProgramProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  // State untuk List Minggu (Weeks)
  List<ProgramWeekModel> _weeks = [];
  bool _isLoading = false;
  String? _errorMessage;

  // State untuk Detail Latihan Harian (Daily Schedules)
  List<DailyScheduleModel> _dailySchedules = [];
  bool _isDayLoading = false;

  // State untuk Latihan Hari Ini
  DailyScheduleModel? _todaySchedule;
  bool _isTodayLoading = false;

  // State untuk Progress Mingguan
  List<DailyScheduleModel> _weeklySchedules = [];
  bool _isWeeklyLoading = false;
  int _completedSessionsThisWeek = 0;
  int _totalSessionsThisWeek = 0;
  int _totalDurationMinutesThisWeek = 0;
  double _totalDistanceThisWeek = 0.0;

  // State untuk Progress Dashboard (Card Program)
  int _totalWeeks = 0;
  int _totalWorkouts = 0;
  int _completedWorkouts = 0;
  bool _isProgressLoading = false;

  List<ProgramWeekModel> get weeks => _weeks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<DailyScheduleModel> get dailySchedules => _dailySchedules;
  bool get isDayLoading => _isDayLoading;

  DailyScheduleModel? get todaySchedule => _todaySchedule;
  bool get isTodayLoading => _isTodayLoading;

  int get totalWeeks => _totalWeeks;
  bool get isProgressLoading => _isProgressLoading;

  bool get isWeeklyLoading => _isWeeklyLoading;
  int get completedSessionsThisWeek => _completedSessionsThisWeek;
  int get totalSessionsThisWeek => _totalSessionsThisWeek;
  double get totalDistanceThisWeek => _totalDistanceThisWeek;

  // Helper untuk konversi menit ke jam
  String get totalDurationFormatted {
    final hours = _totalDurationMinutesThisWeek ~/ 60;
    final minutes = _totalDurationMinutesThisWeek % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }

  // Helper function untuk ekstrak angka dari teks JSON
  double _parseDistanceFromSteps(dynamic steps) {
    try {
      if (steps == null || steps is! Map) return 0.0;
      final String mainText = steps['main']?.toString().toLowerCase() ?? '';
      final RegExp regex = RegExp(r'(\d+(\.\d+)?)\s*km');
      final match = regex.firstMatch(mainText);
      if (match != null) {
        return double.tryParse(match.group(1) ?? '0') ?? 0.0;
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  double get progressPercentage {
    if (_totalWorkouts == 0) return 0.0;
    return _completedWorkouts / _totalWorkouts;
  }

  /// Menghitung total minggu, total latihan, dan latihan yang selesai.
  Future<void> fetchProgramProgress() async {
    try {
      _isProgressLoading = true;

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final weeksCount = await _supabase
          .schema('runmates')
          .from('program_weeks')
          .count(CountOption.exact)
          .eq('user_id', userId);

      _totalWeeks = weeksCount;

      final totalWorkoutsCount = await _supabase
          .schema('runmates')
          .from('daily_schedules')
          .count(CountOption.exact)
          .eq('user_id', userId);

      _totalWorkouts = totalWorkoutsCount;

      final completedCount = await _supabase
          .schema('runmates')
          .from('daily_schedules')
          .count(CountOption.exact)
          .eq('user_id', userId)
          .eq('is_done', true);

      _completedWorkouts = completedCount;
    } catch (e) {
      debugPrint("Error fetching program progress: $e");
    } finally {
      _isProgressLoading = false;
      notifyListeners();
    }
  }

  // Mengambil Jadwal Latihan Hari Ini
  Future<void> fetchTodaySchedule() async {
    try {
      _isTodayLoading = true;

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final now = DateTime.now();
      final dateStr =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final response = await _supabase
          .schema('runmates')
          .from('daily_schedules')
          .select()
          .eq('user_id', userId)
          .eq('scheduled_date', dateStr)
          .maybeSingle();

      if (response != null) {
        _todaySchedule = DailyScheduleModel.fromJson(response);
      } else {
        _todaySchedule = null;
      }
    } catch (e) {
      debugPrint("Error fetching today schedule: $e");
      _todaySchedule = null;
    } finally {
      _isTodayLoading = false;
      notifyListeners();
    }
  }

  // Mengambil progress minggu ini
  Future<void> fetchWeeklyProgress() async {
    try {
      _isWeeklyLoading = true;
      _totalDistanceThisWeek = 0.0;

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));

      final startStr = startOfWeek.toIso8601String().split('T')[0];
      final endStr = endOfWeek.toIso8601String().split('T')[0];

      final response = await _supabase
          .schema('runmates')
          .from('daily_schedules')
          .select()
          .eq('user_id', userId)
          .gte('scheduled_date', startStr)
          .lte('scheduled_date', endStr);

      final List<dynamic> data = response;
      _weeklySchedules = data
          .map((json) => DailyScheduleModel.fromJson(json))
          .toList();

      _totalSessionsThisWeek = _weeklySchedules.length;

      final completedSchedules = _weeklySchedules
          .where((e) => e.isDone)
          .toList();

      _completedSessionsThisWeek = completedSchedules.length;

      _totalDurationMinutesThisWeek = completedSchedules.fold(
        0,
        (sum, item) => sum + item.durationMinutes,
      );

      _totalDistanceThisWeek = completedSchedules.fold(0.0, (sum, item) {
        return sum + _parseDistanceFromSteps(item.steps);
      });
    } catch (e) {
      debugPrint("Error fetching weekly progress: $e");
    } finally {
      _isWeeklyLoading = false;
      notifyListeners();
    }
  }

  int getDayStatus(int weekday) {
    try {
      final schedule = _weeklySchedules.firstWhere(
        (s) => s.scheduledDate.weekday == weekday,
      );
      return schedule.isDone ? 2 : 1;
    } catch (e) {
      return 0;
    }
  }

  /// Mengambil Daftar Minggu
  Future<void> fetchProgramWeeks() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw 'User tidak ditemukan (belum login).';

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

  /// Mengambil Detail Latihan per Minggu
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
          .order('scheduled_date', ascending: true);

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

  /// Menandai Latihan sebagai Selesai
  Future<void> markScheduleAsDone(int scheduleId) async {
    try {
      // Update ke Supabase
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
          scheduledDate: oldItem.scheduledDate,
          workoutTitle: oldItem.workoutTitle,
          workoutSubtitle: oldItem.workoutSubtitle,
          workoutObjective: oldItem.workoutObjective,
          durationMinutes: oldItem.durationMinutes,
          steps: oldItem.steps,
          isDone: true, // Set true
        );

        _dailySchedules[index] = newItem;

        _completedWorkouts++;

        notifyListeners();
      }
    } catch (e) {
      debugPrint("Gagal update status selesai: $e");
      rethrow;
    }
  }

  /// Cek Achievement
  Future<bool> hasAchievement(int achievementId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await _supabase
          .schema('runmates')
          .from('user_achievements')
          .select('id')
          .eq('user_id', userId)
          .eq('achievement_id', achievementId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      debugPrint("Error checking achievement: $e");
      return false;
    }
  }
}
