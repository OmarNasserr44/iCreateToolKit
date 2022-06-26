import 'dart:developer';
import 'package:icreate_attendence/Colors/Colors.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  void initState() {
    () async {
      Get.find<SharedPreferencesController>().awaitedCheckLogin.value = false;
      await Get.find<SharedPreferencesController>().checkLogIn();
      Get.find<SharedPreferencesController>().awaitedCheckLogin.value = true;
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Obx(
      () => AnimatedSplashScreen(
          splash: SizedBox(
            height: screenSize.height,
            width: screenSize.width,
            child: Column(
              children: [
                SizedBox(
                  height: screenSize.height / 10,
                ),
                Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.white,
                    // leftDotColor: const Color(0xFF1A1A3F),
                    // rightDotColor: const Color(0xFFEA3799),
                    size: screenSize.width / 2,
                  ),
                ),
                SizedBox(
                  height: screenSize.height / 30,
                ),
                CustText(
                  text: "Loading Data..",
                  fontSize: screenSize.width / 12,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          backgroundColor: progressBackgroundColor,
          splashIconSize: screenSize.width / 1,
          duration: 4000,
          // splashTransition: SplashTransition.rotationTransition,
          nextScreen:
              Get.find<SharedPreferencesController>().awaitedCheckLogin.value
                  ? LogInScreen()
                  : Get.find<SharedPreferencesController>().splashLogin.value
                      ? NavMainBottom()
                      : LogInScreen()),
    );
  }
}
