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

    double racePaceDecimal = targetTime / targetDistance;
    int racePaceMin = racePaceDecimal.floor();
    int racePaceSec = ((racePaceDecimal - racePaceMin) * 60).round();
    String racePaceStr =
        "$racePaceMin:${racePaceSec.toString().padLeft(2, '0')}";

    double easyPaceDecimal = racePaceDecimal + 1.25;
    int easyPaceMin = easyPaceDecimal.floor();
    int easyPaceSec = ((easyPaceDecimal - easyPaceMin) * 60).round();
    String easyPaceStr =
        "$easyPaceMin:${easyPaceSec.toString().padLeft(2, '0')}";

    double longPaceDecimal = racePaceDecimal + 1.75;
    int longPaceMin = longPaceDecimal.floor();
    int longPaceSec = ((longPaceDecimal - longPaceMin) * 60).round();
    String longPaceStr =
        "$longPaceMin:${longPaceSec.toString().padLeft(2, '0')}";

    final String prompt =
        '''
      Berperanlah sebagai Pelatih Lari Profesional Khusus PEMULA.
      Buat jadwal latihan lari 5 minggu yang SANGAT DETAIL dan PERSONAL dalam format JSON.

      DATA ATLET (PENGGUNA):
      - Usia: $age tahun | Gender: $gender
      - Fisik: Berat $weight kg, Tinggi $height cm
      - BMI: ${bmi.toStringAsFixed(1)} ($bmiStatus)
      - Target: $targetDistance km dalam $targetTime menit.
      - Hari Latihan: ${availableDays.join(', ')} (${availableDays.length} hari/minggu).

      === ATURAN PELATIHAN & KESELAMATAN (WAJIB DIPATUHI) ===
      Berdasarkan profil medis pengguna, kamu HARUS menerapkan aturan berikut dalam jadwal:
      $expertContext
      =======================================================

      INSTRUKSI PENJADWALAN KETAT:
      1. Jika User Obese/Overweight: Minggu 1-2 HARUS fokus "Walk-Run" (Jalan-Lari). Jangan beri lari full.
      2. Key "title" gunakan bahasa Inggris baku (Easy Run, Long Run, Recovery Run, Rest Day).
      3. Hari kosong diisi: "Rest Day" atau "Strength Training".

      === PACE SUDAH DIHITUNG — GUNAKAN NILAI INI, JANGAN HITUNG ULANG ===
      - Race Pace (target pengguna): $racePaceStr min/km
        (dihitung dari $targetTime menit ÷ $targetDistance km = $racePaceStr min/km)
      - Easy Run pace: $easyPaceStr min/km (race pace + 75 detik, untuk sesi santai)
      - Long Run pace: $longPaceStr min/km (race pace + 105 detik, untuk sesi panjang)
      - Recovery Run: gunakan pace lebih lambat dari easy pace
      - Race Day (minggu 5): WAJIB gunakan race pace $racePaceStr min/km
      =====================================================================
      
      4. ***ATURAN KHUSUS DETAIL LATIHAN (WAJIB)***:
         a. Field "duration" = total durasi sesi dalam menit. WAJIB diisi untuk SEMUA hari
            termasuk Rest Day (isi 0) dan Race Day.
         b. Pada key "steps" -> "main":
            - Gunakan pace dari daftar di atas. JANGAN ubah nilainya.
            - WAJIB tulis durasi segmen inti dengan format "selama X menit"
              contoh: "selama 20 menit", "selama 30 menit".
            - WAJIB mengakhiri kalimat dengan estimasi total jarak: "Total jarak: X km".
         
         Contoh Format yang BENAR:
         - "Lari santai (pace $easyPaceStr min/km) selama 20 menit tanpa henti. Total jarak: 2.5 km"
         - "Interval: Lari (pace $racePaceStr min/km) selama 2 menit, Jalan 2 menit. Ulangi 5x. Total jarak: 2.5 km"

      FORMAT OUTPUT WAJIB (JSON ARRAY):
      [
        {
          "week": 1,
          "days": [
            {
              "day": "Senin",
              "title": "Easy Run", 
              "subtitle": "Membangun Aerobik Dasar",
              "objective": "Menjaga konsistensi pace.",
              "duration": 30,
              "steps": {
                 "warmup": "Jalan cepat 5 menit.",
                 "main": "Lari santai (pace $easyPaceStr min/km) selama 20 menit tanpa henti. Total jarak: 2.5 km",
                 "cooldown": "Jalan kaki 5 menit."
              }
            },
            ... (SISA HARI SENIN-MINGGU)
          ]
        },
        ... (ULANGI SAMPAI MINGGU 5)
      ]
      HANYA BERIKAN JSON MURNI TANPA MARKDOWN (```json).
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
            "temperature": 0.4,
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
                ? dayItem['steps']
                : {'instruction': 'Lihat deskripsi.'};

            String dayNameAI = dayItem['day'] ?? 'Senin';
            int dayOffset = dayOffsets[dayNameAI] ?? 0;

            DateTime scheduledDate = programStartDate.add(
              Duration(days: (weekIndex * 7) + dayOffset),
            );

            String dateString =
                "${scheduledDate.year}-${scheduledDate.month.toString().padLeft(2, '0')}-${scheduledDate.day.toString().padLeft(2, '0')}";

            dailyInserts.add({
              'week_id': weekId,
              'user_id': userId,
              'scheduled_date': dateString,
              'workout_title': dayItem['title'] ?? 'Rest',
              'workout_subtitle': dayItem['subtitle'] ?? '',
              'workout_objective': dayItem['objective'] ?? '',
              'duration_minutes': dayItem['duration'] ?? 0,
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
      } else {
        throw 'Google AI Error (${response.statusCode}): ${response.body}';
      }
    } catch (e) {
      print('CRITICAL ERROR AI SERVICE: $e');
      rethrow;
    }
  }
}
