import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> scheduleWorkoutReminders(List<dynamic> schedules) async {
    await _notificationsPlugin.cancelAll();

    for (var item in schedules) {
      DateTime date = DateTime.parse(item.scheduledDate);

      final scheduledTime = DateTime(
        date.year,
        date.month,
        date.day,
        6, 
        0,
      );

      if (scheduledTime.isBefore(DateTime.now())) continue;

      final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

      await _notificationsPlugin.zonedSchedule(
        item.id,
        'Jadwal Lari Hari Ini! 🏃‍♂️',
        'Saatnya bangun: ${item.workoutTitle}',
        tzTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_workout_channel',
            'Workout Reminders',
            channelDescription: 'Pengingat lari pagi jam 6',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(presentSound: true),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );

      print("Jadwal dipasang untuk: $tzTime - ${item.workoutTitle}");
    }
  }
}
