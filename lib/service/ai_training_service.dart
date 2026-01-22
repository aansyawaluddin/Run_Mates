import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AITrainingService {
  final SupabaseClient supabase = Supabase.instance.client;

  String get apiKey => dotenv.env['AI_API_KEY'] ?? '';

  final String model = 'gemini-2.5-flash';

  Future<void> generateAndSavePlan({
    required String userId,
    required List<String> availableDays,
    required double targetDistance,
    required int targetTime,
    required String userProfile,
  }) async {
    if (apiKey.isEmpty) throw 'API Key tidak ditemukan di .env';
    if (availableDays.isEmpty) throw 'Hari latihan tidak boleh kosong.';

    // --- LOGIKA TANGGAL ---
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

    final String prompt =
        '''
      Berperanlah sebagai Pelatih Lari Maraton Profesional.
      Buat jadwal latihan 5 minggu yang SANGAT DETAIL dan TERSTRUKTUR dalam format JSON.

      DATA ATLET:
      - Profil: $userProfile
      - Target: $targetDistance km dalam $targetTime menit.
      - HARI LARI TERSEDIA: ${availableDays.join(', ')}.
      - JUMLAH HARI LARI: ${availableDays.length} Hari.

      ATURAN KONTEN PENTING (WAJIB DIPATUHI):
      1. Key "title" HARUS menggunakan ISTILAH LARI STANDAR (Inggris/Indonesia Baku).
         - CONTOH BENAR: "Easy Run", "Long Run", "Interval Run", "Tempo Run", "Fartlek", "Recovery Run".
         - CONTOH SALAH: "Lari Mudah Aerobik", "Lari Santai Pagi", "Latihan Kekuatan & Stabilitas".
      2. Key "steps" -> "main" WAJIB MENYERTAKAN JARAK (KM/Meter) secara eksplisit.
         - JANGAN HANYA DURASI WAKTU.
         - CONTOH BENAR: "Lari Easy Run sejauh 5 km di Zone 2." atau "Interval 8 x 400m dengan istirahat 2 menit."
         - CONTOH SALAH: "Lari santai selama 30 menit."

      ATURAN JSON:
      1. Output HANYA JSON Array.
      2. Key "day" HARUS: "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu".
      3. Struktur object hari: "title", "subtitle", "objective", "duration", "steps" (warmup, main, cooldown).

      LOGIKA PENJADWALAN:
      - Jika <= 2 hari: Fokus Speed & Long Run.
      - Jika 3 hari: Interval, Easy, Long Run.
      - Jika > 3 hari: Tambahkan Easy Run (Zone 2).
      - Hari kosong diisi: Rest Day / Strength Training.

      FORMAT OUTPUT WAJIB (JSON ARRAY):
      [
        {
          "week": 1,
          "days": [
            {
              "day": "Senin",
              "title": "Speed Interval", 
              "subtitle": "VO2 Max Builder",
              "objective": "Meningkatkan kecepatan dan ambang laktat.",
              "duration": 60,
              "steps": {
                 "warmup": "Jogging 10 menit + Dynamic Stretch",
                 "main": "Interval 6 x 800m @ Target Pace, Istirahat 90 detik jog",
                 "cooldown": "Jogging pendinginan 10 menit"
              }
            },
            {
              "day": "Selasa",
              "title": "Easy Run",
              "subtitle": "Aerobic Base",
              "objective": "Membangun pondasi aerobik.",
              "duration": 45,
              "steps": {
                 "warmup": "Jalan cepat 5 menit",
                 "main": "Lari Easy sejauh 5 km di Zone 2 (Conversational Pace)",
                 "cooldown": "Jalan kaki 5 menit"
              }
            }
            ... (LENGKAPI 7 HARI SENIN-MINGGU)
          ]
        },
        ... (ULANGI SAMPAI MINGGU 5)
      ]
    ''';

    try {
      print("Mengirim request ke Google AI Studio...");

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
        content = content.replaceAll(RegExp(r'```'), '');

        int startIndex = content.indexOf('[');
        int endIndex = content.lastIndexOf(']');

        if (startIndex == -1 || endIndex == -1) {
          print("Raw Content: $content");
          throw 'Format JSON rusak atau tidak ditemukan.';
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
                'description': 'Minggu ke-$weekNum.',
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
