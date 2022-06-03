import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class PushNotification extends GetxController {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;

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
}
