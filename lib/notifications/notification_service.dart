import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:coleapp/core/navigation/app_navigator.dart';
import 'package:coleapp/notifications/background_message_handler.dart';
import 'package:coleapp/notifications/local_notification_service.dart';

/// Guarda la página a la que debe ir la app tras abrir una notificación push.
class PendingNotificationRoute {
  static final PendingNotificationRoute _instance = PendingNotificationRoute._internal();
  factory PendingNotificationRoute() => _instance;
  PendingNotificationRoute._internal();

  int? pageIndex;

  void clear() => pageIndex = null;
}

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

  /// Al tocar una notificación, decide si va a Avisos, Agenda o Home según
  /// el contenido del push, y navega al home del padre.
  Future<void> _handleMessageOpened(RemoteMessage message) async {
    debugPrint('[FCM] Notificación abierta: ${message.data}');
    final pageIndex = _resolvePageIndex(message);
    PendingNotificationRoute().pageIndex = pageIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appNavigatorKey.currentState
          ?.pushNamedAndRemoveUntil('parent/home', (route) => false);
    });
  }

  int _resolvePageIndex(RemoteMessage message) {
    final type = message.data['type']?.toString().toUpperCase();
    if (type != null) {
      switch (type) {
        case 'ANNOUNCEMENT':
          return 10;
        case 'TASK':
        case 'STUDENT_OBSERVATION':
          return 8;
        case 'ATTENDANCE':
        case 'MEETING':
        default:
          return 0;
      }
    }

    final text = '${message.notification?.title ?? ''} '
        '${message.notification?.body ?? ''} '
        '${message.data['title'] ?? ''} '
        '${message.data['body'] ?? ''}'
        .toLowerCase();

    if (text.contains('aviso') ||
        text.contains('comunicado') ||
        text.contains('anuncio')) {
      return 10;
    }
    if (text.contains('tarea') ||
        text.contains('observación') ||
        text.contains('observacion') ||
        text.contains('llamada de atención') ||
        text.contains('llamada de atencion')) {
      return 8;
    }
    return 0;
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
