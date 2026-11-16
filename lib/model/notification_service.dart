import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message: ${message.messageId}');
}

class PushService {
  static final ValueNotifier<String> lastMessage =
  ValueNotifier<String>('No message yet');

  static final FlutterLocalNotificationsPlugin _local =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'news_channel',
    'Notifications',
    description: 'App notifications',
    importance: Importance.high,
  );

  static StreamSubscription<RemoteMessage>? _messageSub;
  static StreamSubscription<String>? _tokenSub;

  // Which Firestore collection stores the token: 'users' or 'admins'
  static String _collection = 'users';

  /// Call once in main(), before runApp.
  static void registerBackground() {
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  }

  /// Call once in main(), after Firebase is initialized.
  static Future<void> initLocal() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _local.initialize(settings);

    await _local
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  /// Asks for permission, saves the token, and starts listening.
  /// Call this only after the user taps Allow and is logged in.
  /// Pass collection: 'admins' from the admin app flow.
  static Future<void> init({String collection = 'users'}) async {
    _collection = collection;

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    final token = await messaging.getToken();
    await _saveToken(token);

    _tokenSub ??= messaging.onTokenRefresh.listen(_saveToken);
    _messageSub ??= FirebaseMessaging.onMessage.listen(_onForegroundMessage);
  }

  static void _onForegroundMessage(RemoteMessage message) {
    final title =
        message.notification?.title ?? message.data['title'] ?? 'New message';
    final body = message.notification?.body ?? message.data['body'] ?? '';

    lastMessage.value = '$title\n$body';

    _local.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  static Future<void> _saveToken(String? token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (token == null || uid == null) return;

    await FirebaseFirestore.instance
        .collection(_collection)
        .doc(uid)
        .set({'fcmToken': token}, SetOptions(merge: true));
  }

  static void dispose() {
    _messageSub?.cancel();
    _tokenSub?.cancel();
    _messageSub = null;
    _tokenSub = null;
  }
}