import 'dart:developer';
import 'package:icreate_attendence/Colors/Colors.dart';
import 'package:icreate_attendence/Screens/TempScreen.dart';
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
  bool temp = false;
  @override
  void initState() {
    () async {
      await Get.find<SharedPreferencesController>().checkLogIn();
      temp = Get.find<SharedPreferencesController>().splashLogin.value;
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return AnimatedSplashScreen(
        splash: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height / 10,
              ),

              ///
              /// ssh
              Center(
                child: LoadingAnimationWidget.prograssiveDots(
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
        duration: 7000,
        // splashTransition: SplashTransition.rotationTransition,
        nextScreen: Temp());
  }
}
