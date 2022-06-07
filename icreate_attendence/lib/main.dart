import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/GetX%20Controllers/Bindings.dart';
import 'package:icreate_attendence/GetX%20Controllers/GoogleSheets.dart';
import 'package:icreate_attendence/GetX%20Controllers/Push_Notification.dart';
import 'package:icreate_attendence/Screens/LogInScreen.dart';
import 'package:icreate_attendence/Screens/NavMainBar.dart';
import 'package:icreate_attendence/Screens/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GetX Controllers/shared_preferences.dart';
import 'Screens/HomePage.dart';

Future<void> main() async {
  AllControllerBindings().dependencies();
  WidgetsFlutterBinding.ensureInitialized();
  PushNotification.notificationInitialize();
  await Firebase.initializeApp();
  await GoogleSheetsController.init();
  await Get.find<SharedPreferencesController>().checkLogIn();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  FirebaseMessaging.onMessage.listen((message) {
    // log(message.data.toString());
    // log("${message.notification?.title}");
    // log("${message.notification?.body}");
    Get.find<PushNotification>().displayNotificationPop(message);
  });
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

///Receive message when app is on background
Future<void> backgroundHandler(RemoteMessage message) async {
  Get.lazyPut(() => PushNotification());
  log("on backgroundHandler");
  // log(message.data.toString());
  // log("${message.notification?.title}");
  // log("${message.notification?.body}");
  Get.find<PushNotification>().displayNotificationPop(message);
}
// ///Receive message when app is on backgroundqs

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    ///
    ///when user click on Notification but app is TERMINATED
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;

    _fcm.getInitialMessage().then((message) {
      log("click notification");
    });

    ///

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AllControllerBindings(),
      // home: SplashScreen(),
      initialRoute: "SplashScreen",
      routes: {
        "SplashScreen": (context) => SplashScreen(),
      },
    );
  }
}
