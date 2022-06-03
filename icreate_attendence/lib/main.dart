import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/GetX%20Controllers/Bindings.dart';
import 'package:icreate_attendence/Screens/LogInScreen.dart';
import 'package:icreate_attendence/Screens/NavMainBar.dart';
import 'package:icreate_attendence/Screens/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GetX Controllers/shared_preferences.dart';
import 'Screens/HomePage.dart';

Future<void> main() async {
  AllControllerBindings().dependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AllControllerBindings(),
      home: SplashScreen(),
    );
  }
}
