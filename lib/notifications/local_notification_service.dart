import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

    _initialized = true;
  }

  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
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
              'Avisos de asistencia, comunicados y agenda',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}
