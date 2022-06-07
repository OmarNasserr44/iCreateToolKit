// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/GetX%20Controllers/TasksController.dart';
import 'package:icreate_attendence/GetX%20Controllers/shared_preferences.dart';
import 'package:icreate_attendence/GetX%20Controllers/updateCheck.dart';
import 'package:icreate_attendence/Requests/FirebaseRequests.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';
import 'package:icreate_attendence/Screens/LogInScreen.dart';
import 'package:icreate_attendence/Widgets_/Button.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Colors/Colors.dart';
import 'package:intl/intl.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SignInUp signInUp = Get.find<SignInUp>();

  FirebaseRequests firebaseRequests = Get.find<FirebaseRequests>();

  TasksController tasksController = Get.find<TasksController>();
  UpdateCheck updateCheck = Get.find<UpdateCheck>();
  //
  bool waitStatus = true;

  @override
  void initState() {
    super.initState();
    getS();
  }

  void getS() async {
    await updateCheck
        .getStatus()
        .then((value) => log('results ${updateCheck.currentStatus}'));

    if (updateCheck.currentStatus == "available") {
      setState(() {
        updateCheck.status[0] = true;
        updateCheck.status[updateCheck.index[1]] = false;
        updateCheck.status[updateCheck.index[2]] = false;
        waitStatus = false;
      });
    } else if (updateCheck.currentStatus == "away") {
      setState(() {
        updateCheck.status[1] = true;
        updateCheck.status[updateCheck.index[0]] = false;
        updateCheck.status[updateCheck.index[2]] = false;
        waitStatus = false;
      });
    } else if (updateCheck.currentStatus == "offline") {
      setState(() {
        updateCheck.status[2] = true;
        updateCheck.status[updateCheck.index[0]] = false;
        updateCheck.status[updateCheck.index[1]] = false;
        waitStatus = false;
      });
    }
  }

  //

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
            child: SizedBox(
      height: screenSize.height,
      width: screenSize.width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
          height: screenSize.height / 8,
        ),
        SizedBox(
          width: screenSize.width / 1.1,
          height: screenSize.height / 20,
          child: CustText(text: "Settings", fontSize: screenSize.width / 8),
        ),
        SizedBox(
          height: screenSize.height / 15,
        ),
        SizedBox(
          height: screenSize.height / 4,
          width: screenSize.width / 1.1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustText(text: "Status", fontSize: screenSize.width / 10),
              SizedBox(
                height: screenSize.height / 60,
              ),
              waitStatus
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width / 15,
                            ),
                            SizedBox(
                              height: screenSize.height / 30,
                              width: screenSize.width / 13,
                              child: Checkbox(
                                fillColor: MaterialStateProperty.all<Color>(
                                    Colors.green),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)),
                                onChanged: (bool? value) {
                                  setState(() {
                                    updateCheck.status[0] = value!;
                                    updateCheck.currentStatus = "available";
                                    // firebaseRequests.updateStatus();
                                    updateCheck.status[updateCheck.index[1]] =
                                        false;
                                    updateCheck.status[updateCheck.index[2]] =
                                        false;
                                  });
                                },
                                value: updateCheck.status[0],
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width / 36,
                            ),
                            CustText(
                              text: "Available",
                              fontSize: screenSize.width / 15,
                              bold: false,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenSize.height / 50,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width / 15,
                            ),
                            SizedBox(
                              height: screenSize.height / 30,
                              width: screenSize.width / 13,
                              child: Checkbox(
                                fillColor: MaterialStateProperty.all<Color>(
                                    Colors.red),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)),
                                onChanged: (bool? value) {
                                  setState(() {
                                    updateCheck.status[1] = value!;
                                    updateCheck.currentStatus = "away";
                                    // firebaseRequests.updateStatus();
                                    updateCheck.status[updateCheck.index[0]] =
                                        false;
                                    updateCheck.status[updateCheck.index[2]] =
                                        false;
                                  });
                                },
                                value: updateCheck.status[1],
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width / 36,
                            ),
                            CustText(
                              text: "Away",
                              fontSize: screenSize.width / 15,
                              bold: false,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenSize.height / 50,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: screenSize.width / 15,
                            ),
                            SizedBox(
                              height: screenSize.height / 30,
                              width: screenSize.width / 13,
                              child: Checkbox(
                                fillColor: MaterialStateProperty.all<Color>(
                                    Colors.grey),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)),
                                onChanged: (bool? value) {
                                  setState(() {
                                    updateCheck.status[2] = value!;
                                    updateCheck.currentStatus = "offline";
                                    // firebaseRequests.updateStatus();
                                    updateCheck.status[updateCheck.index[0]] =
                                        false;
                                    updateCheck.status[updateCheck.index[1]] =
                                        false;
                                  });
                                },
                                value: updateCheck.status[2],
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width / 36,
                            ),
                            CustText(
                              text: "Offline",
                              fontSize: screenSize.width / 15,
                              bold: false,
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
        SizedBox(
          height: screenSize.height / 10,
        ),
        CustButton(
            width: screenSize.width / 1.3,
            text: "Confirm Status",
            onTap: () async {
              await Get.find<SharedPreferencesController>().checkInternet();
              if (Get.find<SharedPreferencesController>().hasInternet) {
                Get.find<UpdateCheck>().saveStatus(screenSize, context);
              } else {
                log("IN NO INTERNET");
                Get.find<SharedPreferencesController>()
                    .showAlertDialog(context);
              }
            }),
        SizedBox(
          height: screenSize.height / 9,
        ),
        CustButton(
          width: screenSize.width / 2.4,
          text: 'Sign Out',
          onTap: () async {
            await Get.find<SharedPreferencesController>().checkInternet();
            if (Get.find<SharedPreferencesController>().hasInternet) {
              signInUp.showAlertDialog(context);
              await signInUp.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('email');
              prefs.remove('password');
              Get.back();
              Get.back();
              Navigator.pop(context);
              Get.to(() => LogInScreen());
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LogInScreen()));
            } else {
              Get.find<SharedPreferencesController>().showAlertDialog(context);
            }
          },
        ),
      ]),
    )));
  }
}
