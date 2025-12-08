import 'package:flutter/material.dart';

/// Model untuk program lari
class RunningProgram {
  final String id;
  final String title;
  final String description;
  final List<String> weekSchedule; // Mon, Tue, Wed, etc.
  final Duration totalDuration;
  final int distance; // dalam km
  bool isCompleted;

  RunningProgram({
    required this.id,
    required this.title,
    required this.description,
    required this.weekSchedule,
    required this.totalDuration,
    required this.distance,
    this.isCompleted = false,
  });
}

/// Provider untuk mengelola program lari
class ProgramProvider extends ChangeNotifier {
  List<RunningProgram> _programs = [];
  RunningProgram? _selectedProgram;
  bool _isLoading = false;

  List<RunningProgram> get programs => _programs;
  RunningProgram? get selectedProgram => _selectedProgram;
  bool get isLoading => _isLoading;

  /// Ambil semua program
  Future<void> fetchPrograms() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulasi API call - ganti dengan API sebenarnya
      await Future.delayed(const Duration(seconds: 1));

      _programs = [
        RunningProgram(
          id: '1',
          title: 'Beginner 5K',
          description: 'Program pemula untuk berlari 5K',
          weekSchedule: ['Mon', 'Wed', 'Fri'],
          totalDuration: const Duration(minutes: 30),
          distance: 5,
        ),
        RunningProgram(
          id: '2',
          title: 'Intermediate 10K',
          description: 'Program menengah untuk berlari 10K',
          weekSchedule: ['Mon', 'Tue', 'Thu', 'Sat'],
          totalDuration: const Duration(minutes: 45),
          distance: 10,
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Pilih program
  void selectProgram(RunningProgram program) {
    _selectedProgram = program;
    notifyListeners();
  }

  /// Tandai program sebagai selesai
  void completeProgram(String programId) {
    final index = _programs.indexWhere((p) => p.id == programId);
    if (index != -1) {
      _programs[index].isCompleted = true;
      notifyListeners();
    }
  }

  /// Tambah program baru
  void addProgram(RunningProgram program) {
    _programs.add(program);
    notifyListeners();
  }

  /// Hapus program
  void deleteProgram(String programId) {
    _programs.removeWhere((p) => p.id == programId);
    if (_selectedProgram?.id == programId) {
      _selectedProgram = null;
    }
    notifyListeners();
  }
}
