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

// // saveStatus(screenSize);
// if (updateCheck.earlyMorning &&
// (updateCheck.currentStatus == "offline" ||
// updateCheck.currentStatus == "away")) {
// ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// backgroundColor: mainTextColor,
// content: Text(
// "Hi champ, please confirm that you are available first",
// style: TextStyle(
// color: Colors.white, fontSize: screenSize.width / 20),
// ),
// ));
// } else {
// updateCheck.earlyMorning = false;
// updateCheck.currentTime = updateCheck.getTime();
// String time = updateCheck.currentTime.substring(11, 16);
//
// //
// //save the availability and away times to calculate working hours
// //
// if (updateCheck.currentStatus == 'available') {
// updateCheck.updateStatus();
// //
// //add the start of available time
// if (updateCheck.available[0] == "") {
// updateCheck.available[0] = time;
// } else {
// updateCheck.available.add(time);
// }
// //
// //add the start of available time hours
// updateCheck.latestAvailableHours = time.substring(0, 2);
// //
// //add the start of available time Minutes
// updateCheck.latestAvailableMin = time.substring(3, 5);
// //
// ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// backgroundColor: mainTextColor,
// content: Text(
// "Welcome back CHAMP!!",
// style: TextStyle(
// color: Colors.white,
// fontSize: screenSize.width / 20),
// ),
// ));
// } else if (updateCheck.currentStatus == 'away') {
// updateCheck.updateStatus();
//
// //
// //add the start of available time
// if (updateCheck.away[0] == "") {
// updateCheck.away[0] = time;
// } else {
// updateCheck.away.add(time);
// }
// //
// //add the start of available time hours
// updateCheck.latestAwayHours = time.substring(0, 2);
// //add the start of available time mins
// //
// updateCheck.latestAwayMin = time.substring(3, 5);
// //
// // updateCheck.totalWorkingHours=int.parse(source)
// } else if (updateCheck.currentStatus == 'offline') {
// updateCheck.updateStatus();
//
// updateCheck.offline = time;
//
// DateTime startTime =
// DateFormat("HH:mm").parse(updateCheck.available[0]);
// DateTime endTime;
// if (updateCheck.offline[0] == "-") {
// endTime = DateFormat("HH:mm")
//     .parse(updateCheck.offline.substring(1));
// } else {
// endTime = DateFormat("HH:mm").parse(updateCheck.offline);
// }
// //
// //
// Duration dif = endTime.difference(startTime);
// String twh = "";
// if (dif.toString().substring(0, 5)[4] == ":") {
// twh = dif.toString().substring(0, 4);
// } else {
// twh = dif.toString().substring(0, 5);
// }
// updateCheck.shiftHours = twh;
// //
// //
// List<String> awayTimes = [];
// if (updateCheck.away[0] != "") {
// for (int i = 0; i < updateCheck.away.length; i++) {
// DateTime awayStartTime =
// DateFormat("HH:mm").parse(updateCheck.away[i]);
// if (updateCheck.available.length > i + 1) {
// //
// DateTime awayEndTime = DateFormat("HH:mm")
//     .parse(updateCheck.available[i + 1]);
// Duration awayDiff =
// awayEndTime.difference(awayStartTime);
//
// String totalAwayHours = "";
// if (awayDiff.toString().substring(0, 5)[4] == ":") {
// totalAwayHours =
// "0${awayDiff.toString().substring(0, 4)}";
// awayTimes.add(totalAwayHours);
// } else {
// totalAwayHours =
// awayDiff.toString().substring(0, 5);
// awayTimes.add(totalAwayHours);
// }
// }
// }
// }
// int hours = 0;
// int mins = 0;
// for (int i = 0; i < awayTimes.length; i++) {
// hours = hours + int.parse(awayTimes[i].substring(0, 2));
// mins = mins + int.parse(awayTimes[i].substring(3, 5));
// if (mins > 59) {
// hours = hours + 1;
// mins = mins - 60;
// }
// //
// //
// }
// //
// updateCheck.totalAwayHours = "$hours:$mins";
// log("TOTAL AWAY H ${updateCheck.totalAwayHours}");
// //
// //
//
// if (awayTimes.isNotEmpty) {
// //total working hours
// DateTime totalWH =
// DateFormat("HH:mm").parse(updateCheck.shiftHours);
// //total away time
// DateTime tat;
// if (updateCheck.totalAwayHours[0] == '-') {
// tat = DateFormat("HH:mm")
//     .parse(updateCheck.totalAwayHours.substring(1));
// } else {
// tat = DateFormat("HH:mm")
//     .parse(updateCheck.totalAwayHours);
// }
// Duration workDiff = totalWH.difference(tat);
//
// if (workDiff.toString()[1] == ":") {
// updateCheck.totalWorkingHours =
// workDiff.toString().substring(0, 4);
// } else {
// updateCheck.totalWorkingHours =
// workDiff.toString().substring(0, 5);
// }
// } else {
// updateCheck.totalWorkingHours = updateCheck.shiftHours;
// }
// //
// //
// updateCheck.todayDate =
// DateTime.now().toString().substring(0, 10);
// Get.find<UpdateCheck>().saveStatus(screenSize, context);
// }
// }
