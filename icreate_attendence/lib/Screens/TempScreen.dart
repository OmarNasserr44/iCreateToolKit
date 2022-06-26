import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/Screens/LogInScreen.dart';
import 'package:icreate_attendence/Screens/NavMainBar.dart';

import '../Colors/Colors.dart';
import '../GetX Controllers/shared_preferences.dart';

class Temp extends StatefulWidget {
  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
  @override
  void initState() {
    Future(() {
      if (Get.find<SharedPreferencesController>().splashLogin.value) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NavMainBottom()),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LogInScreen()),
          (Route<dynamic> route) => false,
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: progressBackgroundColor,
    );
  }
}
