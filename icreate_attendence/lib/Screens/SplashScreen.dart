import 'dart:developer';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/Colors/Colors.dart';
import 'package:icreate_attendence/GetX%20Controllers/shared_preferences.dart';
import 'package:icreate_attendence/Requests/FirebaseRequests.dart';
import 'package:icreate_attendence/Screens/HomePage.dart';
import 'package:icreate_attendence/Screens/LogInScreen.dart';
import 'package:icreate_attendence/Screens/NavMainBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GetX Controllers/NewTaskController.dart';
import '../GetX Controllers/TasksController.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //
  Future<void> checkLogIn() async {
    await Get.find<SharedPreferencesController>().checkInternet();
    if (Get.find<SharedPreferencesController>().hasInternet) {
      UserCredential? userCredential;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Get.find<SharedPreferencesController>().sharedEmail =
          prefs.getString('email') ?? "";
      Get.find<SharedPreferencesController>().sharedPassword =
          prefs.getString('password') ?? "";
      //
      log("EMAIL ${Get.find<SharedPreferencesController>().sharedEmail}");
      log("Pass ${Get.find<SharedPreferencesController>().sharedPassword}");
      //
      if (Get.find<SharedPreferencesController>().sharedEmail != "") {
        try {
          userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: Get.find<SharedPreferencesController>().sharedEmail,
            password: Get.find<SharedPreferencesController>().sharedPassword,
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            log('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            log('Wrong password provided for that user.');
          }
        }
        if (userCredential != null) {
          await Get.find<FirebaseRequests>().currentUserData();
          await Get.find<TasksController>().getUserTasks();
          Get.find<NewTaskController>()
              .getFieldDataQuery("User Information", "ID", "Name");
        }
      }
    }
  }

  @override
  void initState() {
    checkLogIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return AnimatedSplashScreen(
        splash: Container(
          height: screenSize.height,
          width: screenSize.width,
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height / 12,
              ),
              Center(
                child: Container(
                    height: screenSize.height / 3,
                    width: screenSize.width / 1.1,
                    child: Image.asset(
                      "Assets/Images/iCreate logo PNG.png",
                      fit: BoxFit.fill,
                    )),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        splashIconSize: screenSize.width / 1,
        duration: 2500,
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: Get.find<SharedPreferencesController>().sharedEmail == ""
            ? LogInScreen()
            : NavMainBottom());
  }
}
