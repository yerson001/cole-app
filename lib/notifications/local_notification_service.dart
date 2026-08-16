import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationService {
  static final LocalNotificationService instance =
      LocalNotificationService._internal();

  factory LocalNotificationService() => instance;

  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(settings: initSettings);

    await _createChannel();

    _initialized = true;
  }

  Future<void> _createChannel() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('notification_sound_v4') != true) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.deleteNotificationChannel(channelId: 'colecheck_push');
      await prefs.setBool('notification_sound_v4', true);
    }
    const channel = AndroidNotificationChannel(
      'colecheck_push',
      'ColeCheck Avisos',
      description: 'Asistencia, avisos y agenda',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<bool> notificationsEnabled() async {
    final enabled = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();
    return enabled ?? true;
  }

  Future<void> show({
    required String id,
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      id: id.hashCode,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'colecheck_push',
          'Notificaciones ColeCheck',
          channelDescription:
              'Avisos de asistencia, avisos y agenda',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          sound: RawResourceAndroidNotificationSound('notification'),
        ),
      ),
    );
  }
}
