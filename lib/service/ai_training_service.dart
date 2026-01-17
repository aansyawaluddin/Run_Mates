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
      Berperanlah sebagai Pelatih Lari Profesional. Buat jadwal lari 5 minggu yang sangat detail.
      
      DATA ATLET:
      - Profil: $userProfile
      - Target: $targetDistance km dalam $targetTime menit.
      - Hari Lari Tersedia: ${availableDays.join(', ')}.
      
      ATURAN PENJADWALAN:
      1. Program harus progresif (makin lama makin berat) selama 5 minggu.
      2. HANYA jadwalkan lari di "Hari Lari Tersedia". 
      3. Hari yang TIDAK dipilih user WAJIB diisi "Rest Day" atau "Strength Training".
      4. Minggu ke-5 adalah Race Week (tapering/pengurangan volume).
      
      FORMAT OUTPUT WAJIB JSON (ARRAY):
      [
        {
          "week": 1,
          "days": [
            {
              "day": "Senin",
              "title": "Judul Latihan (misal: Speed Run / Rest Day)",
              "subtitle": "Subjudul (misal: Interval 400m / Pemulihan)",
              "objective": "Tujuan latihan singkat",
              "duration": 45,
              "steps": {
                 "warmup": "pemanasan...", 
                 "main": "menu utama...", 
                 "cooldown": "pendinginan..."
              }
            }
            ... (ulangi untuk Selasa sampai Minggu)
          ]
        },
        ... (ulangi sampai week 5)
      ]
      
      JANGAN gunakan markdown ```json. Langsung mulai dengan kurung siku [ dan akhiri dengan ].
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
                  "You are a professional running coach API that outputs strictly valid JSON arrays without markdown formatting.",
            },
            {"role": "user", "content": prompt},
          ],
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String content = data['choices'][0]['message']['content'];

        content = content
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        print("AI Response: $content");

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
                'description': 'Minggu ke-$weekNum menuju targetmu.',
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
      } else {
        throw 'OpenRouter Error (${response.statusCode}): ${response.body}';
      }
    } catch (e) {
      print('Error AI Generator: $e');
      rethrow;
    }
  }
}
