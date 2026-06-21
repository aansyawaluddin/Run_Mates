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

      final allSchedulesResponse = await _supabase
          .schema('runmates')
          .from('daily_schedules')
          .select('scheduled_date, workout_title, is_done')
          .eq('user_id', userId);

      final List<dynamic> allSchedules = allSchedulesResponse;
      _totalWorkouts = allSchedules.length;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      int completedCount = 0;
      for (var s in allSchedules) {
        final isDone = s['is_done'] == true;
        final title = (s['workout_title'] ?? '').toString().toLowerCase();
        final isRest = title.contains('rest');

        final dateStr = s['scheduled_date']?.toString() ?? '';
        DateTime? scheduleDate;
        try {
          scheduleDate = DateTime.parse(dateStr);
        } catch (_) {
          scheduleDate = null;
        }

        final isPast =
            scheduleDate != null &&
            DateTime(
              scheduleDate.year,
              scheduleDate.month,
              scheduleDate.day,
            ).isBefore(today);

        if (isDone || (isRest && isPast)) {
          completedCount++;
        }
      }

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

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final scheduleDate = DateTime(
        schedule.scheduledDate.year,
        schedule.scheduledDate.month,
        schedule.scheduledDate.day,
      );
      final isRest = schedule.workoutTitle.toLowerCase().contains('rest');
      final isPast = scheduleDate.isBefore(today);

      if (schedule.isDone || (isRest && isPast)) return 2;

      if (isPast && !isRest) return 3;

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

      // Hitung sesi yang terlewat (kecuali Rest Day)
      final missedResponse = await _supabase
          .schema('runmates')
          .from('daily_schedules')
          .select('id, workout_title')
          .eq('user_id', userId)
          .lt('scheduled_date', todayStr)
          .eq('is_done', false);

      final List<dynamic> missedList = missedResponse;
      // Filter: Rest Day tidak dihitung sebagai "missed"
      final missedCount = missedList.where((item) {
        final title = (item['workout_title'] ?? '').toString().toLowerCase();
        return !title.contains('rest');
      }).length;

      if (missedCount < 2) return false;

      // Cari sesi berikutnya yang belum selesai DAN bukan Rest Day / Race Day
      final nextWorkoutResponse = await _supabase
          .schema('runmates')
          .from('daily_schedules')
          .select()
          .eq('user_id', userId)
          .gte('scheduled_date', todayStr)
          .eq('is_done', false)
          .order('scheduled_date', ascending: true)
          .limit(10); // ambil 10 sesi terdekat untuk filter

      final List<dynamic> candidates = nextWorkoutResponse;
      Map<String, dynamic>? targetWorkout;

      for (var workout in candidates) {
        final title = (workout['workout_title'] ?? '').toString().toLowerCase();
        // Skip Rest Day, Race Day, Shakeout (tapering), dan yang sudah Extra Load
        if (title.contains('rest') ||
            title.contains('race') ||
            title.contains('shakeout') ||
            title.contains('extra load')) {
          continue;
        }
        targetWorkout = Map<String, dynamic>.from(workout);
        break;
      }

      if (targetWorkout == null) return false;

      final String currentTitle = (targetWorkout['workout_title'] ?? '')
          .toString();
      final Map<String, dynamic> currentSteps = Map<String, dynamic>.from(
        targetWorkout['steps'] ?? {},
      );
      String mainStep = currentSteps['main']?.toString() ?? '';

      final lowerTitle = currentTitle.toLowerCase();

      // ── STRATEGI PENALTI BERDASARKAN TIPE SESI ──

      if (lowerTitle.contains('interval')) {
        // Format: "8x pengulangan lari cepat ... selama 1 menit, diselingi jalan santai 90 detik..."
        // Tambah 2 repetisi
        final intervalRegex = RegExp(
          r'(\d+)(x\s+pengulangan)',
          caseSensitive: false,
        );
        final intervalMatch = intervalRegex.firstMatch(mainStep);
        if (intervalMatch != null) {
          final reps = int.tryParse(intervalMatch.group(1)!) ?? 0;
          if (reps > 0) {
            final newReps = reps + 2;
            mainStep = mainStep.replaceFirst(
              intervalRegex,
              '${newReps}x pengulangan',
            );

            // Update "Total jarak: X km" dengan proporsi reps baru
            final jarakRegex = RegExp(
              r'total\s+jarak[:\s]+(\d+(?:\.\d+)?)\s*km',
              caseSensitive: false,
            );
            final jarakMatch = jarakRegex.firstMatch(mainStep);
            if (jarakMatch != null) {
              final oldKm = double.tryParse(jarakMatch.group(1)!) ?? 0;
              final newKm = (oldKm / reps * newReps).toStringAsFixed(1);
              mainStep = mainStep.replaceFirst(
                jarakRegex,
                'Total jarak: $newKm km',
              );
            }
          }
        }
      } else if (lowerTitle.contains('strength')) {
        // Format Strength: "Squats 3 set x 12 reps ... Estimasi total: 25 menit"
        // Tambah 5 menit di estimasi total
        final estimasiRegex = RegExp(
          r'estimasi\s+total[:\s]+(\d+)\s*menit',
          caseSensitive: false,
        );
        final estimasiMatch = estimasiRegex.firstMatch(mainStep);
        if (estimasiMatch != null) {
          final oldMin = int.tryParse(estimasiMatch.group(1)!) ?? 0;
          final newMin = oldMin + 5;
          mainStep = mainStep.replaceFirst(
            estimasiRegex,
            'Estimasi total: $newMin menit',
          );
        }
      } else {
        // Easy Run, Long Run, Recovery Run, Fartlek dll
        // Format: "...selama X menit... Total jarak: Y km"
        // Tambah 5 menit di "selama"
        final selamaRegex = RegExp(
          r'selama\s+(\d+(?:\.\d+)?)\s+menit',
          caseSensitive: false,
        );
        final selamaMatch = selamaRegex.firstMatch(mainStep);
        if (selamaMatch != null) {
          final oldMin = double.tryParse(selamaMatch.group(1)!) ?? 0;
          final newMin = oldMin + 5;
          final displayMin = newMin == newMin.truncateToDouble()
              ? newMin.toInt().toString()
              : newMin.toString();
          mainStep = mainStep.replaceFirst(
            selamaRegex,
            'selama $displayMin menit',
          );

          // Update "Total jarak: X km" proporsional
          final jarakRegex = RegExp(
            r'total\s+jarak[:\s]+(\d+(?:\.\d+)?)\s*km',
            caseSensitive: false,
          );
          final jarakMatch = jarakRegex.firstMatch(mainStep);
          if (jarakMatch != null && oldMin > 0) {
            final oldKm = double.tryParse(jarakMatch.group(1)!) ?? 0;
            final newKm = (oldKm / oldMin * newMin).toStringAsFixed(1);
            mainStep = mainStep.replaceFirst(
              jarakRegex,
              'Total jarak: $newKm km',
            );
          }
        }
      }

      currentSteps['main'] = mainStep;

      // Hitung ulang durasi total dari steps (warmup + main + cooldown)
      final newDuration = _recalculateDuration(currentSteps);

      await _supabase
          .schema('runmates')
          .from('daily_schedules')
          .update({
            'workout_title': '$currentTitle (Extra Load)',
            'duration_minutes': newDuration,
            'steps': currentSteps,
            'workout_objective':
                'Beban latihan ditingkatkan karena kamu melewatkan $missedCount sesi latihan. Ayo kejar ketertinggalan!',
          })
          .eq('id', targetWorkout['id']);

      fetchTodaySchedule();
      fetchWeeklyProgress();

      return true;
    } catch (e) {
      debugPrint("Error applying penalty: $e");
      return false;
    }
  }

  // Helper untuk recalculate durasi (sama dengan logic di AITrainingService)
  int _recalculateDuration(Map<String, dynamic> steps) {
    int extractTotal(String text) {
      final p = RegExp(
        r'total[:\s]+(\d+(?:[.,]\d+)?)\s*menit',
        caseSensitive: false,
      );
      final m = p.firstMatch(text);
      if (m != null) {
        final n = double.tryParse(m.group(1)!.replaceAll(',', '.'));
        if (n != null) return n.round();
      }
      return 0;
    }

    int extractMain(String text) {
      // Interval
      final intP = RegExp(
        r'(\d+)\s*x\s+.*?selama\s+(\d+(?:[.,]\d+)?)\s+menit.*?(\d+)\s+detik',
        caseSensitive: false,
        dotAll: true,
      );
      final intM = intP.firstMatch(text);
      if (intM != null) {
        final reps = int.tryParse(intM.group(1)!);
        final runMin = double.tryParse(intM.group(2)!.replaceAll(',', '.'));
        final restSec = int.tryParse(intM.group(3)!);
        if (reps != null && runMin != null && restSec != null) {
          final total = (reps * runMin) + ((reps - 1) * restSec / 60.0);
          return total.round();
        }
      }

      // Strength
      final esP = RegExp(
        r'estimasi\s+total[:\s]+(\d+(?:[.,]\d+)?)\s*menit',
        caseSensitive: false,
      );
      final esM = esP.firstMatch(text);
      if (esM != null) {
        final n = double.tryParse(esM.group(1)!.replaceAll(',', '.'));
        if (n != null) return n.round();
      }

      // Race Day
      final raceP = RegExp(
        r'lari\s+(\d+(?:[.,]\d+)?)\s+km\s+dengan\s+target\s+pace\s+(\d+):(\d+)',
        caseSensitive: false,
      );
      final raceM = raceP.firstMatch(text);
      if (raceM != null) {
        final km = double.tryParse(raceM.group(1)!.replaceAll(',', '.'));
        final pMin = int.tryParse(raceM.group(2)!);
        final pSec = int.tryParse(raceM.group(3)!);
        if (km != null && pMin != null && pSec != null) {
          final pDec = pMin + (pSec / 60.0);
          return (km * pDec).round();
        }
      }

      // Lari biasa
      final selP = RegExp(
        r'selama\s+(\d+(?:[.,]\d+)?)\s+menit',
        caseSensitive: false,
      );
      final selM = selP.firstMatch(text);
      if (selM != null) {
        final n = double.tryParse(selM.group(1)!.replaceAll(',', '.'));
        if (n != null) return n.round();
      }

      return 0;
    }

    final w = (steps['warmup'] ?? '').toString();
    final m = (steps['main'] ?? '').toString();
    final c = (steps['cooldown'] ?? '').toString();

    return extractTotal(w) + extractMain(m) + extractTotal(c);
  }

  // State untuk progress semua minggu
  List<Map<String, dynamic>> _allWeeksProgress = [];
  bool _isAllWeeksLoading = false;

  List<Map<String, dynamic>> get allWeeksProgress => _allWeeksProgress;
  bool get isAllWeeksLoading => _isAllWeeksLoading;

  /// Mengambil progress untuk SEMUA minggu (untuk PageView di home)
  Future<void> fetchAllWeeksProgress() async {
    try {
      _isAllWeeksLoading = true;
      notifyListeners();

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final weeksResponse = await _supabase
          .schema('runmates')
          .from('program_weeks')
          .select('id, week_number')
          .eq('user_id', userId)
          .order('week_number', ascending: true);

      final List<dynamic> weeks = weeksResponse;
      List<Map<String, dynamic>> results = [];

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      for (var week in weeks) {
        final int weekId = week['id'];
        final int weekNumber = week['week_number'];

        final schedulesResponse = await _supabase
            .schema('runmates')
            .from('daily_schedules')
            .select()
            .eq('user_id', userId)
            .eq('week_id', weekId)
            .order('scheduled_date', ascending: true);

        final List<dynamic> rawSchedules = schedulesResponse;
        final schedules = rawSchedules
            .map((json) => DailyScheduleModel.fromJson(json))
            .toList();

        final completed = schedules.where((s) {
          final isRest = s.workoutTitle.toLowerCase().contains('rest');
          final scheduleDate = DateTime(
            s.scheduledDate.year,
            s.scheduledDate.month,
            s.scheduledDate.day,
          );
          final isPast = scheduleDate.isBefore(today);

          return s.isDone || (isRest && isPast);
        }).toList();

        final actuallyDone = schedules.where((s) => s.isDone).toList();

        final totalDuration = actuallyDone.fold<int>(
          0,
          (sum, item) => sum + item.durationMinutes,
        );

        final totalDistance = actuallyDone.fold<double>(0.0, (sum, item) {
          return sum + _parseDistanceFromSteps(item.steps);
        });

        results.add({
          'weekNumber': weekNumber,
          'schedules': schedules,
          'totalSessions': schedules.length,
          'completedSessions': completed.length,
          'totalDurationMinutes': totalDuration,
          'totalDistance': totalDistance,
        });
      }

      _allWeeksProgress = results;
    } catch (e) {
      debugPrint("Error fetching all weeks progress: $e");
    } finally {
      _isAllWeeksLoading = false;
      notifyListeners();
    }
  }

  /// Helper format durasi (jam:menit) dari menit total
  String formatHoursMinutes(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }

  /// Status day untuk minggu spesifik
  /// 0 = tidak ada jadwal, 1 = belum, 2 = selesai (atau Rest Day yang sudah lewat), 3 = missed
  int getDayStatusForWeek(List<DailyScheduleModel> schedules, int weekday) {
    try {
      final schedule = schedules.firstWhere(
        (s) => s.scheduledDate.weekday == weekday,
      );

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final scheduleDate = DateTime(
        schedule.scheduledDate.year,
        schedule.scheduledDate.month,
        schedule.scheduledDate.day,
      );
      final isRest = schedule.workoutTitle.toLowerCase().contains('rest');
      final isPast = scheduleDate.isBefore(today);

      if (schedule.isDone || (isRest && isPast)) return 2;

      if (isPast && !isRest) return 3;

      return 1;
    } catch (e) {
      return 0;
    }
  }
}
