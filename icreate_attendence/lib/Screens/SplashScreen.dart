import 'dart:developer';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/GetX%20Controllers/shared_preferences.dart';

import 'package:icreate_attendence/Screens/LogInScreen.dart';
import 'package:icreate_attendence/Screens/NavMainBar.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Obx(
      () => AnimatedSplashScreen(
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
          nextScreen: Get.find<SharedPreferencesController>().splashLogin.value
              ? NavMainBottom()
              : LogInScreen()),
    );
  }
}
