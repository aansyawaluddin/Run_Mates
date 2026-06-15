import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:runmates/service/running_knowledge.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AITrainingService {
  final SupabaseClient supabase = Supabase.instance.client;

  String get apiKey => dotenv.env['AI_API_KEY'] ?? '';

  final String model = 'gemini-2.5-flash-lite';

  String _getWeekDescription(int weekNum, int daysPerWeek) {
    const descriptions = {
      1: 'Fondasi: Membangun kebiasaan & adaptasi tubuh',
      2: 'Konsistensi: Meningkatkan durasi & daya tahan',
      3: 'Pengembangan: Menambah jarak & intensitas',
      4: 'Puncak: Latihan tertinggi sebelum tapering',
      5: 'Race Week: Tapering & persiapan hari perlombaan',
    };
    return descriptions[weekNum] ??
        'Minggu ke-$weekNum ($daysPerWeek hari latihan)';
  }

  String _addSeconds(double paceDecimal, int seconds) {
    double totalSeconds = (paceDecimal * 60) + seconds;
    if (totalSeconds < 0) totalSeconds = 0;
    int min = (totalSeconds / 60).floor();
    int sec = (totalSeconds % 60).round();
    if (sec == 60) {
      min += 1;
      sec = 0;
    }
    return "$min:${sec.toString().padLeft(2, '0')}";
  }

  String _estimateDistance(double paceDecimal, int durationMinutes) {
    if (paceDecimal <= 0) return '0.0';
    double distance = durationMinutes / paceDecimal;
    return distance.toStringAsFixed(1);
  }

  // Helper: ekstrak "Total: X menit" dari teks warmup/cooldown
  int _extractTotalMinutes(String text) {
    final totalPattern = RegExp(
      r'total[:\s]+(\d+(?:[.,]\d+)?)\s*menit',
      caseSensitive: false,
    );
    final match = totalPattern.firstMatch(text);
    if (match != null) {
      final num = double.tryParse(match.group(1)!.replaceAll(',', '.'));
      if (num != null) return num.round();
    }
    return 0;
  }

  int _extractMainMinutes(String text) {
    final intervalPattern = RegExp(
      r'(\d+)\s*x\s+.*?selama\s+(\d+(?:[.,]\d+)?)\s+menit.*?(\d+)\s+detik',
      caseSensitive: false,
      dotAll: true,
    );
    final intervalMatch = intervalPattern.firstMatch(text);
    if (intervalMatch != null) {
      final reps = int.tryParse(intervalMatch.group(1)!);
      final runMin = double.tryParse(
        intervalMatch.group(2)!.replaceAll(',', '.'),
      );
      final restSec = int.tryParse(intervalMatch.group(3)!);
      if (reps != null && runMin != null && restSec != null) {
        final total = (reps * runMin) + ((reps - 1) * restSec / 60.0);
        return total.round();
      }
    }

    final estimasiPattern = RegExp(
      r'estimasi\s+total[:\s]+(\d+(?:[.,]\d+)?)\s*menit',
      caseSensitive: false,
    );
    final estimasiMatch = estimasiPattern.firstMatch(text);
    if (estimasiMatch != null) {
      final num = double.tryParse(estimasiMatch.group(1)!.replaceAll(',', '.'));
      if (num != null) return num.round();
    }

    final racePattern = RegExp(
      r'lari\s+(\d+(?:[.,]\d+)?)\s+km\s+dengan\s+target\s+pace\s+(\d+):(\d+)',
      caseSensitive: false,
    );
    final raceMatch = racePattern.firstMatch(text);
    if (raceMatch != null) {
      final km = double.tryParse(raceMatch.group(1)!.replaceAll(',', '.'));
      final paceMin = int.tryParse(raceMatch.group(2)!);
      final paceSec = int.tryParse(raceMatch.group(3)!);
      if (km != null && paceMin != null && paceSec != null) {
        final paceDecimal = paceMin + (paceSec / 60.0);
        final durationMin = km * paceDecimal;
        return durationMin.round();
      }
    }

    final selamaPattern = RegExp(
      r'selama\s+(\d+(?:[.,]\d+)?)\s+menit',
      caseSensitive: false,
    );
    final selamaMatch = selamaPattern.firstMatch(text);
    if (selamaMatch != null) {
      final num = double.tryParse(selamaMatch.group(1)!.replaceAll(',', '.'));
      if (num != null) return num.round();
    }

    return 0;
  }

  // Helper: hitung total durasi sesi dari 3 langkah
  int _calculateTotalDuration(Map<String, dynamic> steps) {
    final warmup = (steps['warmup'] ?? '').toString();
    final main = (steps['main'] ?? '').toString();
    final cooldown = (steps['cooldown'] ?? '').toString();

    final warmupMin = _extractTotalMinutes(warmup);
    final mainMin = _extractMainMinutes(main);
    final cooldownMin = _extractTotalMinutes(cooldown);

    return warmupMin + mainMin + cooldownMin;
  }

  Future<void> generateAndSavePlan({
    required String userId,
    required int age,
    required int weight,
    required int height,
    required String gender,
    required List<String> availableDays,
    required double targetDistance,
    required int targetTime,
  }) async {
    if (apiKey.isEmpty) throw 'API Key tidak ditemukan di .env';
    if (availableDays.isEmpty) throw 'Hari latihan tidak boleh kosong.';

    double heightInM = height / 100;
    double bmi = weight / (heightInM * heightInM);

    String bmiStatus = "Normal";
    if (bmi <= 18.49) {
      bmiStatus = "Underweight";
    } else if (bmi <= 24.9) {
      bmiStatus = "Normal Weight";
    } else if (bmi <= 27.0) {
      bmiStatus = "Overweight";
    } else {
      bmiStatus = "Obese";
    }

    String expertContext = RunningKnowledgeBase.getRelevantTips(
      age: age,
      bmi: bmi,
    );

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime programStartDate;

    if (today.weekday == DateTime.monday) {
      programStartDate = today;
    } else {
      int daysToAdd = 8 - today.weekday;
      programStartDate = today.add(Duration(days: daysToAdd));
    }

    final Map<String, int> dayOffsets = {
      'Senin': 0,
      'Selasa': 1,
      'Rabu': 2,
      'Kamis': 3,
      'Jumat': 4,
      'Sabtu': 5,
      'Minggu': 6,
    };

    final List<String> allDays = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    final List<String> restDays = allDays
        .where((d) => !availableDays.contains(d))
        .toList();

    // Tentukan Race Day: hari latihan TERAKHIR dalam minggu
    // Urutkan availableDays berdasarkan urutan hari (Senin=0, Minggu=6)
    final List<String> sortedAvailable = List.from(availableDays);
    sortedAvailable.sort(
      (a, b) => (dayOffsets[a] ?? 0).compareTo(dayOffsets[b] ?? 0),
    );
    final String raceDayName = sortedAvailable.last;

    // Pace
    double racePaceDecimal = targetTime / targetDistance;
    int racePaceMin = racePaceDecimal.floor();
    int racePaceSec = ((racePaceDecimal - racePaceMin) * 60).round();
    String racePaceStr =
        "$racePaceMin:${racePaceSec.toString().padLeft(2, '0')}";

    double easyPaceDecimal = racePaceDecimal + 1.25;
    String easyPaceStr = _addSeconds(easyPaceDecimal, 0);

    double longPaceDecimal = racePaceDecimal + 1.75;
    String longPaceStr = _addSeconds(longPaceDecimal, 0);

    String easyW1 = _addSeconds(easyPaceDecimal, 30);
    String easyW2 = _addSeconds(easyPaceDecimal, 15);
    String easyW3 = easyPaceStr;
    String easyW4 = _addSeconds(easyPaceDecimal, -10);
    String easyW5 = _addSeconds(easyPaceDecimal, -15);

    String longW1 = _addSeconds(longPaceDecimal, 30);
    String longW2 = _addSeconds(longPaceDecimal, 15);
    String longW3 = longPaceStr;
    String longW4 = _addSeconds(longPaceDecimal, -10);

    String recoveryW12 = _addSeconds(longPaceDecimal, 45);
    String recoveryW34 = _addSeconds(longPaceDecimal, 30);
    String recoveryW5 = _addSeconds(longPaceDecimal, 15);

    String intervalW1 = _addSeconds(racePaceDecimal, 30);
    String intervalW2 = _addSeconds(racePaceDecimal, 15);
    String intervalW3 = racePaceStr;
    String intervalW4 = _addSeconds(racePaceDecimal, -5);

    String distEasyW1 = _estimateDistance(easyPaceDecimal + 0.5, 20);
    String distEasyW2 = _estimateDistance(easyPaceDecimal + 0.25, 25);
    String distEasyW3 = _estimateDistance(easyPaceDecimal, 30);
    String distEasyW4 = _estimateDistance(easyPaceDecimal - 0.17, 30);

    String distLongW1 = _estimateDistance(longPaceDecimal + 0.5, 40);
    String distLongW2 = _estimateDistance(longPaceDecimal + 0.25, 50);
    String distLongW3 = _estimateDistance(longPaceDecimal, 60);
    String distLongW4 = _estimateDistance(longPaceDecimal - 0.17, 70);

    final String prompt =
        '''
Berperanlah sebagai Pelatih Lari Profesional Bersertifikat untuk PEMULA.
Output: JSON array berisi 5 minggu jadwal latihan.

DATA ATLET:
- Usia: $age tahun | Gender: $gender
- Fisik: Berat $weight kg, Tinggi $height cm
- BMI: ${bmi.toStringAsFixed(1)} ($bmiStatus)
- Target: $targetDistance km dalam $targetTime menit

HARI LATIHAN (${availableDays.length} hari/minggu): ${availableDays.join(', ')}
HARI ISTIRAHAT WAJIB (${restDays.length} hari/minggu): ${restDays.isEmpty ? '(tidak ada)' : restDays.join(', ')}
RACE DAY WAJIB DI HARI: $raceDayName (hari latihan terakhir user)

=== ATURAN KESELAMATAN ===
$expertContext
==========================

=== ATURAN HARI WAJIB (PALING PENTING) ===
1. SETIAP minggu HARUS punya 7 entri hari LENGKAP: Senin, Selasa, Rabu, Kamis, Jumat, Sabtu, Minggu.
2. Hari HARI LATIHAN → isi sesi latihan (Easy Run, Long Run, Interval, Strength, dll).
3. Hari HARI ISTIRAHAT → WAJIB diisi "Rest Day" dengan format STANDAR:
   {
     "day": "[NamaHari]",
     "title": "Rest Day",
     "subtitle": "Pemulihan Total",
     "objective": "Memberikan tubuh waktu pulih dan beradaptasi dari latihan.",
     "duration": 0,
     "steps": {
       "warmup": "Tidak ada.",
       "main": "Istirahat total. Fokus pada hidrasi, nutrisi seimbang, tidur 7-8 jam, dan peregangan ringan opsional.",
       "cooldown": "Tidak ada."
     }
   }
4. Urutkan dari Senin hingga Minggu di setiap minggu.

=== ATURAN RACE WEEK (MINGGU 5 - TAPERING) ===
1. Race Day WAJIB di hari "$raceDayName" — JANGAN di hari lain.
2. Sehari sebelum Race Day: "Shakeout Run" 15-20 menit (sangat ringan + 2-3 strides), BUKAN intensitas tinggi, BUKAN Rest.
3. 2 hari sebelum Race Day: Easy Run pendek 15-20 menit ATAU Rest Day.
4. Sesi intensitas (Interval/Tempo/Long Run/Strength berat) DILARANG di minggu 5.
5. Volume total minggu 5 turun 40-50% dari minggu 4.

=== STRUKTUR PROGRAM 5 MINGGU ===
- Minggu 1 → Fondasi: volume rendah, pace paling santai
- Minggu 2 → Konsistensi: durasi naik 10-15%
- Minggu 3 → Pengembangan: volume & intensitas meningkat
- Minggu 4 → Puncak: latihan terberat
- Minggu 5 → Race Week: tapering, fokus ke Race Day

=== ATURAN PENJADWALAN PROFESIONAL ===
1. JANGAN tempatkan Strength Training sehari SETELAH Long Run.
2. JANGAN tempatkan Interval Training sehari SETELAH Long Run.
3. Sehari setelah Long Run: HARUS Rest atau Recovery Run.
4. Long Run idealnya di hari latihan SEBELUM hari Race Day pattern (akhir minggu).

=== PACE REFERENSI (PROGRESIF) ===

EASY RUN pace:
- Minggu 1: $easyW1 min/km
- Minggu 2: $easyW2 min/km
- Minggu 3: $easyW3 min/km
- Minggu 4: $easyW4 min/km
- Minggu 5: $easyW5 min/km

LONG RUN pace:
- Minggu 1: $longW1 min/km
- Minggu 2: $longW2 min/km
- Minggu 3: $longW3 min/km
- Minggu 4: $longW4 min/km

RECOVERY RUN pace:
- Minggu 1-2: $recoveryW12 min/km
- Minggu 3-4: $recoveryW34 min/km
- Minggu 5: $recoveryW5 min/km

INTERVAL pace lari cepat:
- Minggu 1: $intervalW1 min/km
- Minggu 2: $intervalW2 min/km
- Minggu 3: $intervalW3 min/km
- Minggu 4: $intervalW4 min/km

RACE DAY (Minggu 5): WAJIB $racePaceStr min/km

=== ATURAN ESTIMASI JARAK (HARUS AKURAT) ===
Rumus: jarak_km = durasi_menit / pace_desimal
PENTING untuk Interval: total jarak lari cepat = (jumlah_repetisi × durasi_lari_menit) / pace_desimal
Contoh: 4x lari 4 menit di pace 5:14 (=5.23) → (4×4)/5.23 = 3.1 km (BUKAN 15.7 km)
Contoh referensi Easy/Long Run:
- Easy Run W1 ~20 menit → ~$distEasyW1 km
- Easy Run W3 ~30 menit → ~$distEasyW3 km
- Long Run W1 ~40 menit → ~$distLongW1 km
- Long Run W3 ~60 menit → ~$distLongW3 km

=== ATURAN PENULISAN WARMUP (DURASI AKURAT) ===
Setiap aktivitas dengan durasinya, akhiri "Total: X menit."

Easy/Long Run (5-7 menit):
- "Jalan cepat 3 menit, lalu leg swings 10x per kaki dan hip circles 10x per arah (2 menit). Total: 5 menit."
- "Jogging sangat pelan 4 menit, lanjut arm circles 30 detik + high knees 30 detik + butt kicks 30 detik. Total: 5,5 menit."
- "Jalan bertahap dari pelan ke cepat 4 menit, walking lunges 8 langkah dan side shuffle 30 detik per arah. Total: 6 menit."

Recovery Run (4-5 menit):
- "Jalan sangat santai 4 menit + ankle rolls dan hip circles ringan 1 menit. Total: 5 menit."

Interval (10-12 menit):
- "Jogging pelan 7 menit, drills: high knees 30 detik, butt kicks 30 detik, A-skip 30 detik, karaoke 30 detik per arah (3 menit). Total: 10 menit."

Strength (8-10 menit):
- "Jumping jacks 1 menit, bodyweight squat 15 reps, hip circles 10x per arah, arm swings 30 detik, lunges 10x per kaki, plank 30 detik. Total: 8 menit."

Shakeout Run (5-7 menit):
- "Jalan cepat 3 menit, dynamic stretching ringan 2 menit, 2x strides 20 detik dengan jalan recovery 40 detik (2 menit). Total: 7 menit."

Race Day (10-15 menit):
- "Jalan cepat 5 menit, dynamic stretching 3 menit, 4x strides 20 detik dengan jalan recovery 40 detik (4 menit). Total: 12 menit."

=== ATURAN PENULISAN COOLDOWN ===
Akhiri "Total: X menit."

Easy Run (5-7 menit):
- "Jalan pelan 3 menit, lanjut static stretching: hamstring 30 detik per kaki, quad 30 detik per kaki, calf 30 detik per kaki. Total: 6 menit."

Long Run (10-12 menit):
- "Jalan pelan 5 menit, lanjut stretching menyeluruh: hamstring, quad, betis, hip flexor, IT band (masing-masing 45 detik per sisi). Total: 11 menit."

Recovery Run (4-5 menit), Interval (8-10 menit), Strength (8-10 menit), Race Day (10-15 menit): rinci dengan durasi tiap komponen.

=== ATURAN STRENGTH TRAINING ===
Format: [Nama] - [set] x [rep ATAU durasi] - rest [detik]
WAJIB akhiri: "Estimasi total: X menit latihan inti."
Pilih 4-5 gerakan rotasi tiap sesi.

Progresi:
- W1: 2-3 set x 8-12 reps (20-30 detik hold)
- W2: 3 set x 12-15 reps (30-40 detik)
- W3: 3 set x 15 reps (40-50 detik)
- W4: 3-4 set x 12-15 reps (45-60 detik)
- W5: TIDAK ADA Strength berat

=== VARIASI LATIHAN INTI ===

Easy Run: lari santai konstan / fartlek ringan / lari + 2-3x akselerasi 30 detik
Long Run: konstan / negative split / progression run
Recovery Run: santai konstan / jalan-lari (run 3 min, walk 1 min)
Interval: 1min×8 / 2min×6 / 4min×4 / pyramid / tempo 10-15 min
Shakeout: lari santai 10-15 menit + 2-3 strides (RINGAN)

=== ATURAN FORMAT FIELD ===
- "duration": isi dengan ESTIMASI total. Sistem akan menghitung ulang otomatis dari ketiga langkah.
- "steps.main" lari: format "selama X menit" + akhiri "Total jarak: Y km"
- "steps.main" Interval: "Nx pengulangan lari cepat (pace X) selama Y menit, diselingi jalan santai Z detik. Total jarak: A km (lari cepat saja)"
- "steps.main" Strength: akhiri "Estimasi total: X menit latihan inti."
- Bahasa Indonesia kecuali "title"

FORMAT OUTPUT (JSON ARRAY, TANPA MARKDOWN):
[
  {
    "week": 1,
    "days": [
      {
        "day": "Senin",
        "title": "Easy Run",
        "subtitle": "Membangun Fondasi Aerobik",
        "objective": "Membiasakan tubuh dengan pace konsisten.",
        "duration": 30,
        "steps": {
          "warmup": "Jalan cepat 3 menit, lalu leg swings 10x per kaki dan hip circles 10x per arah (2 menit). Total: 5 menit.",
          "main": "Lari santai (pace $easyW1 min/km) selama 20 menit tanpa henti. Total jarak: $distEasyW1 km",
          "cooldown": "Jalan pelan 3 menit, lanjut static stretching: hamstring 30 detik per kaki, quad 30 detik per kaki, calf 30 detik per kaki. Total: 6 menit."
        }
      }
    ]
  }
]
HANYA JSON MURNI TANPA MARKDOWN. Setiap minggu HARUS 7 hari (Senin-Minggu). Race Day WAJIB di hari $raceDayName.
''';

    try {
      print("Mengirim request ke Gemini...");

      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
          "generationConfig": {
            "temperature": 0.8,
            "responseMimeType": "application/json",
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['candidates'] == null ||
            (data['candidates'] as List).isEmpty) {
          throw 'AI tidak memberikan jawaban.';
        }

        String content = data['candidates'][0]['content']['parts'][0]['text'];

        content = content.replaceAll(
          RegExp(r'```json', caseSensitive: false),
          '',
        );
        content = content.replaceAll(RegExp(r'```'), '').trim();

        int startIndex = content.indexOf('[');
        int endIndex = content.lastIndexOf(']');

        if (startIndex == -1 || endIndex == -1) {
          throw 'Format JSON rusak.';
        }

        String jsonString = content.substring(startIndex, endIndex + 1);
        List<dynamic> weeksData = jsonDecode(jsonString);

        print("JSON Valid! Menyimpan ke Supabase...");

        for (var weekItem in weeksData) {
          int weekNum = weekItem['week'];
          int weekIndex = weekNum - 1;

          final weekRes = await supabase
              .schema('runmates')
              .from('program_weeks')
              .insert({
                'user_id': userId,
                'week_number': weekNum,
                'title': weekNum == 5 ? 'Race Week' : 'Phase $weekNum',
                'description': _getWeekDescription(
                  weekNum,
                  availableDays.length,
                ),
              })
              .select()
              .single();

          final int weekId = weekRes['id'];
          List<Map<String, dynamic>> dailyInserts = [];
          List<dynamic> days = weekItem['days'];

          for (var dayItem in days) {
            final Map<String, dynamic> steps = dayItem['steps'] is Map
                ? Map<String, dynamic>.from(dayItem['steps'])
                : {'instruction': 'Lihat deskripsi.'};

            String dayNameAI = dayItem['day'] ?? 'Senin';
            int dayOffset = dayOffsets[dayNameAI] ?? 0;

            DateTime scheduledDate = programStartDate.add(
              Duration(days: (weekIndex * 7) + dayOffset),
            );

            String dateString =
                "${scheduledDate.year}-${scheduledDate.month.toString().padLeft(2, '0')}-${scheduledDate.day.toString().padLeft(2, '0')}";

            // ── HITUNG ULANG TOTAL DURASI DI DART ──
            String title = (dayItem['title'] ?? 'Rest').toString();
            int finalDuration;

            if (title.toLowerCase().contains('rest')) {
              finalDuration = 0;
            } else {
              int calculated = _calculateTotalDuration(steps);
              // Kalau hasil hitung valid (>0), pakai itu; kalau tidak, fallback ke nilai Gemini
              finalDuration = calculated > 0
                  ? calculated
                  : (dayItem['duration'] ?? 0);
            }

            dailyInserts.add({
              'week_id': weekId,
              'user_id': userId,
              'scheduled_date': dateString,
              'workout_title': title,
              'workout_subtitle': dayItem['subtitle'] ?? '',
              'workout_objective': dayItem['objective'] ?? '',
              'duration_minutes': finalDuration,
              'steps': steps,
              'is_done': false,
            });
          }

          if (dailyInserts.isNotEmpty) {
            await supabase
                .schema('runmates')
                .from('daily_schedules')
                .insert(dailyInserts);
          }
        }

        await supabase
            .schema('runmates')
            .from('profiles')
            .update({'is_plan_ready': true})
            .eq('id', userId);

        print("Program berhasil disimpan!");
      } else {
        throw 'Google AI Error (${response.statusCode}): ${response.body}';
      }
    } catch (e) {
      print('CRITICAL ERROR AI SERVICE: $e');
      rethrow;
    }
  }
}
