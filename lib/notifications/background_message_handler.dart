import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:coleapp/notifications/local_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final data = message.data;
  await LocalNotificationService.instance.init();
  await LocalNotificationService.instance.show(
    id: data['id'] ?? message.messageId ?? 'push',
    title: data['title'] ?? 'ColeCheck',
    body: data['body'] ?? 'Nuevo aviso',
  );
}