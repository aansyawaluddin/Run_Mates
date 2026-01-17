import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AITrainingService {
  final SupabaseClient supabase = Supabase.instance.client;

  final String apiKey = dotenv.env['OPEN_ROUTER_API_KEY'] ?? '';

  final String model = 'meta-llama/llama-3.3-70b-instruct:free';

  Future<void> generateAndSavePlan({
    required String userId,
    required List<String> availableDays,
    required double targetDistance,
    required int targetTime,
    required String userProfile,
  }) async {
    final String prompt =
        '''
      Berperanlah sebagai Pelatih Lari. Buat jadwal lari 5 minggu.
      
      DATA ATLET:
      - Profil: $userProfile
      - Target: $targetDistance km dalam $targetTime menit.
      - Hari Lari (Active Days): ${availableDays.join(', ')}.
      
      ATURAN WAJIB:
      1. Program progresif 5 minggu.
      2. Setiap minggu HARUS memuat output data untuk 7 HARI (Senin, Selasa, Rabu, Kamis, Jumat, Sabtu, Minggu) secara berurutan.
      3. Jika hari tersebut ada di "Hari Lari", berikan menu lari (Easy Run, Interval, dll).
      4. Jika hari tersebut TIDAK ada di "Hari Lari", WAJIB isi "title": "Rest Day" atau "Strength Training".
      5. Untuk Rest Day, isi duration: 0 dan steps kosong.
      6. Minggu 5 = Race Week.
      
      OUTPUT JSON (ARRAY):
      [
        {
          "week": 1,
          "days": [
            {
              "day": "Senin",
              "title": "Rest Day",
              "subtitle": "Recovery",
              "objective": "Istirahat total",
              "duration": 0,
              "steps": {}
            },
            {
              "day": "Selasa",
              "title": "Speed Run",
              "subtitle": "Interval",
              "objective": "Tujuan singkat",
              "duration": 45,
              "steps": {"warmup": "...", "main": "...", "cooldown": "..."}
            }
            ... (lanjutkan sampai Minggu lengkap 7 hari)
          ]
        },
        ... (lanjutkan sampai week 5)
      ]
      
      PENTING: 
      - Pastikan SETIAP minggu memiliki array "days" berisi tepat 7 item (Senin-Minggu).
      - Isi "steps" dengan RINGKAS padat dan jelas.
      - Pastikan JSON valid dan LENGKAP sampai penutup kurung siku.
      - JANGAN gunakan markdown.
    ''';

    try {
      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://runmates.app',
          'X-Title': 'RunMates App',
        },
        body: jsonEncode({
          "model": model,
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a coach API that outputs strictly valid JSON arrays.",
            },
            {"role": "user", "content": prompt},
          ],
          "temperature": 0.7,
          "max_tokens": 4000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['choices'] == null || data['choices'].isEmpty) {
          throw 'AI response empty.';
        }

        String content = data['choices'][0]['message']['content'];

        content = content
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        if (content.length > 50) {
          print("JSON End Check: ...${content.substring(content.length - 50)}");
        }

        List<dynamic> weeksData = jsonDecode(content);

        for (var weekItem in weeksData) {
          int weekNum = weekItem['week'];

          final weekRes = await supabase
              .schema('runmates')
              .from('program_weeks')
              .insert({
                'user_id': userId,
                'week_number': weekNum,
                'title': weekNum == 5 ? 'Race Week' : 'Training Phase',
                'description': 'Minggu ke-$weekNum.',
              })
              .select()
              .single();

          final int weekId = weekRes['id'];

          List<Map<String, dynamic>> dailyInserts = [];
          List<dynamic> days = weekItem['days'];

          for (var dayItem in days) {
            dailyInserts.add({
              'week_id': weekId,
              'user_id': userId,
              'day_name': dayItem['day'],
              'workout_title': dayItem['title'],
              'workout_subtitle': dayItem['subtitle'] ?? '',
              'workout_objective': dayItem['objective'] ?? '',
              'duration_minutes': dayItem['duration'] ?? 0,
              'steps': dayItem['steps'] ?? {},
              'is_done': false,
            });
          }

          await supabase
              .schema('runmates')
              .from('daily_schedules')
              .insert(dailyInserts);
        }
        await supabase
            .schema('runmates')
            .from('profiles')
            .update({'is_plan_ready': true})
            .eq('id', userId);

        print("Jadwal sukses dibuat & status diupdate!");
      } else {
        throw 'OpenRouter Error (${response.statusCode}): ${response.body}';
      }
    } catch (e) {
      print('Error AI Generator: $e');
      rethrow;
    }
  }
}
