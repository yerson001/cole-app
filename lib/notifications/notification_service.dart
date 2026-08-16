import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:coleapp/core/navigation/app_navigator.dart';
import 'package:coleapp/notifications/background_message_handler.dart';
import 'package:coleapp/notifications/local_notification_service.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._internal();

  factory NotificationService() => instance;

  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await LocalNotificationService.instance.init();
    await LocalNotificationService.instance.requestPermissions();

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('[FCM] Permiso de notificaciones: ${settings.authorizationStatus}');

    final token = await _messaging.getToken();
    debugPrint('[FCM] Device token: $token');

    FirebaseMessaging.onMessage.listen((message) {
      final title =
          message.notification?.title ?? message.data['title'] ?? 'ColeCheck';
      final body =
          message.notification?.body ?? message.data['body'] ?? 'Nuevo aviso';
      LocalNotificationService.instance.show(
        id: message.messageId ?? 'push',
        title: title,
        body: body,
      );
    });

    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('[FCM] Token refrescado: $newToken');
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpened(initialMessage);
    }
  }

  /// Al tocar una notificación, regresa al home del padre (y lo recalca via
  /// `ParentHomeContent.initState` → GetParentUser), para ver la asistencia
  /// actualizada.
  Future<void> _handleMessageOpened(RemoteMessage message) async {
    debugPrint('[FCM] Notificación abierta: ${message.data}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appNavigatorKey.currentState
          ?.pushNamedAndRemoveUntil('parent/home', (route) => false);
    });
  }

  /// Suscribe el dispositivo al topic del padre: user_{tenant}_{dni}
  /// Así el backend puede enviar push por topic sin conocer el token.
  Future<void> subscribeToParentTopic({
    required String tenant,
    required String documentNumber,
  }) async {
    if (tenant.isEmpty || documentNumber.isEmpty) return;
    final topic = 'user_${tenant}_$documentNumber';
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('[FCM] Suscrito a topic: $topic');
    } catch (e) {
      debugPrint('[FCM] Error al suscribirse a $topic: $e');
    }
  }

  Future<void> unsubscribeFromParentTopic({
    required String tenant,
    required String documentNumber,
  }) async {
    if (tenant.isEmpty || documentNumber.isEmpty) return;
    final topic = 'user_${tenant}_$documentNumber';
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('[FCM] Desuscrito de topic: $topic');
    } catch (e) {
      debugPrint('[FCM] Error al desuscribirse de $topic: $e');
    }
  }
}
