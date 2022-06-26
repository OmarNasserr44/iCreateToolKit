// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification extends GetxController {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  FirebaseMessaging getFCM() {
    return _fcm;
  }

  void registerNotification() async {
    var messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else {
      log('User declined or has not accepted permission');
    }
  }

// when user click on Notification but the app is RUNNING in the background
  void onNotificationClicked(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data['route'];
      Navigator.pushNamed(context, routeFromMessage.toString());
    });
  }
  //

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void notificationInitialize() async {
    // ignore: prefer_const_declarations
    final InitializationSettings initializationSettings =
        const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: IOSInitializationSettings());
    _notificationsPlugin.initialize(initializationSettings);
  }

  NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      "iCreate",
      "iCreate channel",
      importance: Importance.max,
      priority: Priority.max,
    ),
  );

  ///
  ///
  void displayNotificationPop(RemoteMessage message) async {
    int id = DateTime.now().millisecond;
    await _notificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      notificationDetails,
    );
  }
}
