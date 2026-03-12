import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:book_bridge/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';

/// Service responsible for handling Firebase Push Notifications.
class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final AuthRepository _authRepository;

  PushNotificationService(this._authRepository);

  /// Initializes the notification service.
  Future<void> initialize() async {
    // 1. Request permissions (especially for iOS)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }

      // 2. Setup local notifications for foreground messages
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: DarwinInitializationSettings(),
          );
      await _localNotifications.initialize(settings: initializationSettings);

      // 3. Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showLocalNotification(message);
      });

      // 4. Handle background/terminated messages when app is opened via notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // Handle navigation or other logic here
      });

      // 5. Get and save token if user is logged in
      _setupTokenRefresh();
    }
  }

  /// Sets up token refresh listener and updates current token.
  Future<void> _setupTokenRefresh() async {
    // Get current token
    String? token = await _fcm.getToken();
    if (token != null) {
      await _updateTokenOnServer(token);
    }

    // Listen to token refresh
    _fcm.onTokenRefresh.listen((newToken) {
      _updateTokenOnServer(newToken);
    });
  }

  /// Updates the FCM token in Supabase for the current user.
  Future<void> _updateTokenOnServer(String token) async {
    final userResult = await _authRepository.getCurrentUser();
    userResult.fold(
      (failure) => null, // User not logged in, ignore
      (user) async {
        await _authRepository.updateFcmToken(user.id, token);
      },
    );
  }

  /// Displays a local notification when the app is in foreground.
  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null && !kIsWeb) {
      await _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // id
            'High Importance Notifications', // title
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
  }

  /// Background message handler (must be a top-level function).
  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    // This will be called when the app is in the background or killed.
    // Ensure Firebase is initialized here if needed.
    if (kDebugMode) {
      print("Handling a background message: ${message.messageId}");
    }
  }
}
