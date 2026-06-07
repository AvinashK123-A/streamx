import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Firebase Cloud Messaging service for push notifications
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
}

class NotificationService {
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    final settings = await _messaging.requestPermission(
      alert: true, badge: true, sound: true, provisional: false,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _fcmToken = await _messaging.getToken();
      _messaging.onTokenRefresh.listen((token) { _fcmToken = token; });
    }
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpened);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Show in-app notification
  }

  void _handleNotificationOpened(RemoteMessage message) {
    // Navigate based on notification data
  }

  Future<void> subscribeToTopic(String topic) async =>
      _messaging.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) async =>
      _messaging.unsubscribeFromTopic(topic);
}
