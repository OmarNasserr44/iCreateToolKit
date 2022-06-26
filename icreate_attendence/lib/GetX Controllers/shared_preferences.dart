import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/GetX%20Controllers/DoneHistory.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Requests/FirebaseRequests.dart';
import '../Requests/SignInUpFirebase.dart';
import 'AdminsController.dart';
import 'NewTaskController.dart';
import 'TasksController.dart';

class SharedPreferencesController extends GetxController {
  //
  String sharedEmail = "".obs();
  String sharedPassword = "".obs();
  Map<dynamic, dynamic> dateTasksDone = {}.obs();

  //
  bool hasInternet = false.obs();

  _onTimeOut() {
    log("checked Internet done");
  }

  Future<void> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 3), onTimeout: _onTimeOut());
      log("aa ${result[0].rawAddress}");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Get.find<SharedPreferencesController>().hasInternet = true;
      }
    } on SocketException catch (_) {
      Get.find<SharedPreferencesController>().hasInternet = false;
    }
  }

  //
  RxBool splashLogin = false.obs;
  Future<void> checkLogIn() async {
    await Get.find<SharedPreferencesController>().checkInternet();
    if (Get.find<SharedPreferencesController>().hasInternet) {
      UserCredential? userCredential;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Get.find<SharedPreferencesController>().sharedEmail =
          prefs.getString('email') ?? "";
      Get.find<SharedPreferencesController>().sharedPassword =
          prefs.getString('password') ?? "";

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
          log("IN shared sign in HERE");
        } on FirebaseAuthException catch (e) {
          log("UserC null");
          if (e.code == 'user-not-found') {
            log('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            log('Wrong password provided for that user.');
          }
        }
        if (userCredential != null) {
          log("UserC not null");

          await Get.find<FirebaseRequests>().currentUserData();
          await Get.find<FirebaseRequests>().getDoneTasks();
          await Get.find<TasksController>().getUserTasks();
          await Get.find<AdminController>().getAdminTasks();
          await Get.find<DoneTasksHistory>().getDoneHistory();
          Get.find<SharedPreferencesController>().splashLogin.value = true;
          Get.find<SharedPreferencesController>().splashLogin.refresh();
          log("BOOOL ${Get.find<SharedPreferencesController>().splashLogin}");
          if (Get.find<SignInUp>().adminAcc.value) {
            Get.find<NewTaskController>().usersNames = [""];
            Get.find<NewTaskController>()
                .getFieldDataQuery("User Information", "ID", "Name");
          }
        }
      }
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 10,
        child: Row(
          children: [
            Center(
                child: CustText(
                    text: "No Internet Access",
                    fontSize: MediaQuery.of(context).size.width / 10)),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
