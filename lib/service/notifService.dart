import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifiService {
  NotifiService._private();
  static final NotifiService _instance = NotifiService._private();
  factory NotifiService() => _instance;

  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  bool initialized = false;

  Future<void> initNotifications() async {
    if (initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/launcher_icon');
    const initSettings = InitializationSettings(android: androidInit);

    // callback (optional) untuk response klik notifikasi
    await notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (payload) {
        // optional: handle tap
      },
    );

    // Buat channel Android (Android 8+)
    const androidChannel = AndroidNotificationChannel(
      'channel_id', // id
      'RunMates Channel', // name
      description: 'Channel untuk notifikasi RunMates',
      importance: Importance.max,
    );

    await notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    initialized = true;
  }

  Future<void> showNotification(int id, String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'RunMates Channel',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const details = NotificationDetails(android: androidDetails);

    await notifications.show(id, title, body, details);
  }
}
