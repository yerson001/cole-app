import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions no está configurado para web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions no está configurado para iOS.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions no está configurado para macOS.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no está configurado para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlhzDOtRoof0C_CG8mg4LRHReNvKAie6I',
    appId: '1:795329561861:android:a40f8f763cf2affdc8236c',
    messagingSenderId: '795329561861',
    projectId: 'mobile-push-81f14',
    storageBucket: 'mobile-push-81f14.firebasestorage.app',
  );
}