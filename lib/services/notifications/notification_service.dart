import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';

const _androidChannel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    description: "This channel is used for important notifications",
    importance: Importance.defaultImportance);

bool isFlutterLocalNotificationsInitialized = false;

final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

String? FCMToken = '';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
}

void handleMessage(RemoteMessage? message) {
  if (message == null) return;
}

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotificaitons() async {
    await _firebaseMessaging.requestPermission();
    FCMToken = await _firebaseMessaging.getToken();
    print('Token: $FCMToken');

    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> setupNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: "This channel is used for important notifications",
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> initLocalNotifications() async {
    if (isFlutterLocalNotificationsInitialized) return;

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {
        print('Notification Payload: $payload');
      },
    );

    await setupNotificationChannel();

    isFlutterLocalNotificationsInitialized = true;
  }

  Future initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    _firebaseMessaging.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    FirebaseMessaging.onMessage.listen((message) {
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      final notification = message.notification;
      if (notification == null) return;
      _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
            ),
          ),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future<String> getTokenByID(String userID) async {
    await _firebaseMessaging.requestPermission();
    final databaseRef = FirebaseDatabase.instance.ref();
    final snapshot = await databaseRef.child("users/$userID/fcmtoken").get();

    if (snapshot.exists) {
      final FCMToken = snapshot.value as String;
      return FCMToken;
    }
    return '0';
  }

  Future<String> getDeviceToken() async {
    if (FCMToken != null) {
      return FCMToken!;
    }
    return '0';
  }

  

  Future<void> sendPushNotification({
    required String recipientToken,
    required String title,
    required String body,
  }) async {
    const String projectId = 'hedieaety';

    const String serviceAccountKeyPath =
        'assets/services/hedieaety-firebase-adminsdk-aan55-a79f9a3859.json';
    try {
      final accountCredentials = json.decode(await rootBundle.loadString(
          'assets/services/hedieaety-firebase-adminsdk-aan55-a79f9a3859.json'));

      final serviceAccountCredentials =
          ServiceAccountCredentials.fromJson(accountCredentials);
      final scopes = ['https:
      final client =
          await clientViaServiceAccount(serviceAccountCredentials, scopes);

      final url = Uri.parse(
          'https:

      final payload = {
        "message": {
          "token": recipientToken,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
          },
        },
      };

      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

    } catch (e) {
    }
  }
}
