import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:coleapp/notifications/local_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Si el mensaje trae `notification`, Android lo muestra por si solo
  // (incluso con el app cerrada). Solo mostramos la local si es data-only
  // para evitar notificaciones duplicadas. El caso normal ya no pasa aquí.
  if (message.notification != null) return;

  await LocalNotificationService.instance.init();
  await LocalNotificationService.instance.show(
    id: message.messageId ?? 'push',
    title: message.data['title'] ?? 'ColeCheck',
    body: message.data['body'] ?? 'Nuevo aviso',
  );
}