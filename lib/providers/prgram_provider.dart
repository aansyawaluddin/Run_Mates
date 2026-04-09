import 'package:flutter/material.dart';
import 'package:runmates/service/flutter_local_notifications.dart';
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

  int _currentWeekNumber = 1;
  int get currentWeekNumber => _currentWeekNumber;

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

  String formatDuration(int totalMinutes) {
    if (totalMinutes <= 0) return '0 Menit';

    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '$hours Jam $minutes Menit';
    } else if (hours > 0) {
      return '$hours Jam';
    } else {
      return '$minutes Menit';
    }
  }

  double _parseDistanceFromSteps(dynamic steps) {
    try {
      if (steps == null || steps is! Map) return 0.0;

      String text = steps['main']?.toString().toLowerCase() ?? '';

      text = text.replaceAll(RegExp(r'\d+:\d+\s*(min/km|menit/km)'), '');

      final explicitKmRegex = RegExp(
        r'(total|sejauh|jarak).*?(\d+(\.\d+)?)\s*km',
      );
      final explicitMatch = explicitKmRegex.firstMatch(text);
      if (explicitMatch != null) {
        return double.tryParse(explicitMatch.group(2) ?? '0') ?? 0.0;
      }

      final intervalMeterRegex = RegExp(r'(\d+)\s*x\s*(\d+)\s*m');
      final intervalMatch = intervalMeterRegex.firstMatch(text);
      if (intervalMatch != null) {
        double reps = double.tryParse(intervalMatch.group(1) ?? '0') ?? 0.0;
        double distM = double.tryParse(intervalMatch.group(2) ?? '0') ?? 0.0;
        return (reps * distM) / 1000;
      }

      final simpleKmRegex = RegExp(r'(\d+(\.\d+)?)\s*km');
      final simpleMatch = simpleKmRegex.firstMatch(text);
      if (simpleMatch != null) {
        return double.tryParse(simpleMatch.group(1) ?? '0') ?? 0.0;
      }

      return 0.0;
    } catch (e) {
      debugPrint("Error parsing distance: $e");
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
          .select('*, program_weeks(week_number)')
          .eq('user_id', userId)
          .gte('scheduled_date', startStr)
          .lte('scheduled_date', endStr);

      final List<dynamic> data = response;

      if (data.isNotEmpty) {
        final firstItem = data.first;
        if (firstItem['program_weeks'] != null) {
          _currentWeekNumber = firstItem['program_weeks']['week_number'] ?? 1;
        }
      }

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

      if (schedule.isDone) {
        return 2;
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final scheduleDate = DateTime(
        schedule.scheduledDate.year,
        schedule.scheduledDate.month,
        schedule.scheduledDate.day,
      );

      if (scheduleDate.isBefore(today)) {
        return 3;
      }

      return 1;
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
      await LocalNotificationService.scheduleWorkoutReminders(_dailySchedules);
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

  /// Penalty System
  Future<bool> checkAndApplyPenalty() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final now = DateTime.now();
      final todayStr =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final missedResponse = await _supabase
          .schema('runmates')
          .from('daily_schedules')
          .select('id')
          .eq('user_id', userId)
          .lt('scheduled_date', todayStr)
          .eq('is_done', false);

      final int missedCount = (missedResponse as List).length;

      if (missedCount >= 2) {
        final nextWorkoutResponse = await _supabase
            .schema('runmates')
            .from('daily_schedules')
            .select()
            .eq('user_id', userId)
            .gte('scheduled_date', todayStr)
            .eq('is_done', false)
            .order('scheduled_date', ascending: true)
            .limit(1)
            .maybeSingle();

        if (nextWorkoutResponse != null) {
          final String currentTitle =
              nextWorkoutResponse['workout_title'] ?? '';

          if (!currentTitle.contains('(Extra Load)')) {
            final int currentDuration =
                nextWorkoutResponse['duration_minutes'] ?? 0;
            final int newDuration = currentDuration + 15;

            Map<String, dynamic> currentSteps = Map<String, dynamic>.from(
              nextWorkoutResponse['steps'] ?? {},
            );
            String mainStep = currentSteps['main']?.toString() ?? '';

            // Apakah ini latihan Interval? (Ada format "6 x 400m")
            if (mainStep.contains(RegExp(r'\d+\s*x'))) {
              // Cari angka sebelum huruf 'x' (contoh: "6" dari "6 x 400m")
              final intervalRegex = RegExp(r'(\d+)(\s*x)');
              mainStep = mainStep.replaceAllMapped(intervalRegex, (match) {
                int reps = int.tryParse(match.group(1) ?? '0') ?? 0;
                if (reps > 0) {
                  // Hukuman: Tambah 2 repetisi (misal 6x jadi 8x)
                  return "${reps + 2}${match.group(2)}";
                }
                return match.group(0)!;
              });
            }
            // Apakah ini Lari Jarak Jauh? (Ada format "5 km" atau "5.0 km")
            // Kita pakai lookbehind negatif (logic manual) untuk hindari "min/km" (pace)
            else if (mainStep.contains('km')) {
              final kmRegex = RegExp(r'(\d+(\.\d+)?)\s*km');
              // Kita iterasi semua match, tapi biasanya jarak utama ada di awal atau setelah kata "total"
              // Untuk simpelnya, kita ganti angka "km" pertama yang ditemukan yang nilainya masuk akal (bukan pace)
              mainStep = mainStep.replaceAllMapped(kmRegex, (match) {
                double val = double.tryParse(match.group(1) ?? '0') ?? 0;
                // Filter: Jika angka < 15 kemungkinan itu jarak. Jika > 15 kemungkinan pace menit (kecuali ultramarathon).
                // Atau kita pastikan tidak ada "min/" atau "menit/" sebelumnya (tapi regex dart lookbehind terbatas).
                // Solusi aman: Tambah jarak hanya jika teks tidak mengandung format waktu "titik dua" sebelumnya (misal 5:30)
                bool isPace = mainStep
                    .substring(0, match.start)
                    .trim()
                    .endsWith(':');

                if (val > 0 && !isPace) {
                  // Hukuman: Tambah 1.5 KM
                  double newVal = val + 1.5;
                  // Hapus .0 jika bulat
                  String sVal = newVal.toString().replaceAll(
                    RegExp(r'\.0$'),
                    '',
                  );
                  return "$sVal km";
                }
                return match.group(0)!;
              });
            }

            currentSteps['main'] = mainStep;

            await _supabase
                .schema('runmates')
                .from('daily_schedules')
                .update({
                  'workout_title': '$currentTitle (Extra Load)',
                  'duration_minutes': newDuration,
                  'steps': currentSteps,
                  'workout_objective':
                      'Target jarak & durasi ditingkatkan karena kamu melewatkan $missedCount sesi latihan.',
                })
                .eq('id', nextWorkoutResponse['id']);

            fetchTodaySchedule();
            fetchWeeklyProgress();

            return true;
          }
        }
      }
      return false;
    } catch (e) {
      debugPrint("Error applying penalty: $e");
      return false;
    }
  }
}
