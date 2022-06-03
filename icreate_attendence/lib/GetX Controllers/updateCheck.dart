import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/Requests/FirebaseRequests.dart';
import 'package:intl/intl.dart';

import '../Colors/Colors.dart';

class UpdateCheck extends GetxController {
  List<bool> status = [false, false, false].obs();
  List<int> index = [0, 1, 2].obs();
  String currentTime = DateTime.now().toString().obs();
  String currentStatus = "offline".obs();
  bool earlyMorning = true;
  String shiftHours = "".obs();
  String totalAwayHours = "".obs();
  String totalWorkingHours = "".obs();
  String todayDate = DateTime.now().toString().substring(0, 10).obs();
//   //
//   //
//   //Rec Av hours:min and Away hours:min
//   //to calc how many working hours in each day
  String latestAvailableHours = "".obs();
  String latestAvailableMin = "".obs();
  String latestAwayHours = "".obs();
  String latestAwayMin = "".obs();
//   //
//   //
  List<String> available = [""].obs();
  List<String> away = [""].obs();
  String offline = "".obs();
//   //
//   //
  Map day = {
    "available": "",
    "away": "",
    "shift hours": "",
    "total away time": "",
    "total working time": "",
    "offline": "",
  }.obs();
  Map<dynamic, dynamic> days = {}.obs();
// //
//

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //
  void updateCheck(bool clicked, int statusIndex, List<int> index) {
    status[statusIndex] = clicked;
    status[index[0]] = false;
    status[index[1]] = false;
  }
  //

  String getTime() {
    return DateTime.now().toString();
  }

  Future<void> updateStatus() async {
    try {
      final User? user = auth.currentUser;
      await firestore.collection("Adherence").doc(user?.uid).update({
        "current status": Get.find<UpdateCheck>().currentStatus,
      }).then((value) => log("current status updated successfully"));
    } on Exception catch (e) {
      log('ERROR IN UPDATING current status $e');
    }
  }

  Future<void> getStatus() async {
    final User? user = auth.currentUser;
    try {
      await firestore
          .collection("Adherence")
          // .doc(user?.uid)
          .doc(user?.uid)
          .get()
          .then((value) {
        if (!value.exists) {
          log("something went Wrong");
        }
        if (value.exists) {
          Map<String, dynamic>? data = value.data();
          Get.find<UpdateCheck>().currentStatus = data?['current status'];
          log("Current Status ${Get.find<UpdateCheck>().currentStatus}");
        }
      });
    } on Exception catch (e) {
      log("FAILED $e");
    }
  }

  //
//
  void saveStatus(Size screenSize, BuildContext context) async {
    if (Get.find<UpdateCheck>().earlyMorning &&
        (Get.find<UpdateCheck>().currentStatus == "offline" ||
            Get.find<UpdateCheck>().currentStatus == "away")) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: mainTextColor,
        content: Text(
          "Hi champ, please confirm that you are available first",
          style:
              TextStyle(color: Colors.white, fontSize: screenSize.width / 20),
        ),
      ));
    } else {
      Get.find<UpdateCheck>().currentTime = Get.find<UpdateCheck>().getTime();
      String time = Get.find<UpdateCheck>().currentTime.substring(11, 16);

      //
      //save the availability and away times to calculate working hours
      //
      if (Get.find<UpdateCheck>().currentStatus == 'available') {
        Get.find<UpdateCheck>().earlyMorning = false;

        Get.find<UpdateCheck>().updateStatus();
        //
        //add the start of available time
        if (Get.find<UpdateCheck>().available.isEmpty) {
          Get.find<UpdateCheck>().available.add("");
        } else if (Get.find<UpdateCheck>().available[0] == "") {
          Get.find<UpdateCheck>().available[0] = time;
        } else {
          Get.find<UpdateCheck>().available.add(time);
        }
        log("Av ${Get.find<UpdateCheck>().available}");

        //
        //add the start of available time hours
        Get.find<UpdateCheck>().latestAvailableHours = time.substring(0, 2);
        //
        //add the start of available time Minutes
        Get.find<UpdateCheck>().latestAvailableMin = time.substring(3, 5);
        //
        log("today date ${Get.find<UpdateCheck>().todayDate}");

        if (Get.find<UpdateCheck>().days[Get.find<UpdateCheck>().todayDate] ==
            null) {
          Get.find<UpdateCheck>().day = {
            "available": Get.find<UpdateCheck>().available,
            "away": Get.find<UpdateCheck>().away,
            "shift hours": Get.find<UpdateCheck>().shiftHours,
            "total away time": Get.find<UpdateCheck>().totalAwayHours,
            "total working time": Get.find<UpdateCheck>().totalWorkingHours,
            "offline": Get.find<UpdateCheck>().offline,
          };
          Get.find<UpdateCheck>().days[Get.find<UpdateCheck>().todayDate] =
              Get.find<UpdateCheck>().day;
        }
        Get.find<UpdateCheck>().days[Get.find<UpdateCheck>().todayDate]
            ['available'] = Get.find<UpdateCheck>().available;
        log("Days available ${Get.find<UpdateCheck>().days}");
        await Get.find<FirebaseRequests>().updateDays();
//
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: mainTextColor,
          content: Text(
            "Let's Go champ!!",
            style:
                TextStyle(color: Colors.white, fontSize: screenSize.width / 20),
          ),
        ));
      } else if (Get.find<UpdateCheck>().currentStatus == 'away') {
        Get.find<UpdateCheck>().updateStatus();

        //
        //add the start of available time
        if (Get.find<UpdateCheck>().away.isEmpty) {
          Get.find<UpdateCheck>().away.add("");
        } else if (Get.find<UpdateCheck>().away[0] == "") {
          Get.find<UpdateCheck>().away[0] = time;
        } else {
          Get.find<UpdateCheck>().away.add(time);
        }
        log("AWAY ${Get.find<UpdateCheck>().away}");
        //
        //add the start of available time hours
        Get.find<UpdateCheck>().latestAwayHours = time.substring(0, 2);
        //add the start of available time mins
        //
        Get.find<UpdateCheck>().latestAwayMin = time.substring(3, 5);
        //
        Get.find<UpdateCheck>().days[Get.find<UpdateCheck>().todayDate]
            ['away'] = Get.find<UpdateCheck>().away;
        await Get.find<FirebaseRequests>().updateDays();

        // updateCheck.totalWorkingHours=int.parse(source)
      } else if (Get.find<UpdateCheck>().currentStatus == 'offline') {
        Get.find<UpdateCheck>().updateStatus();

        Get.find<UpdateCheck>().offline = time;

        DateTime startTime =
            DateFormat("HH:mm").parse(Get.find<UpdateCheck>().available[0]);
        DateTime endTime =
            DateFormat("HH:mm").parse(Get.find<UpdateCheck>().offline);
        //
        // DateTime startTime = DateFormat("HH:mm").parse("08:00");
        // DateTime endTime = DateFormat("HH:mm").parse("22:00");
        //
        Duration dif = endTime.difference(startTime);
        String twh = "";
        if (dif.toString().substring(0, 5)[4] == ":") {
          twh = dif.toString().substring(0, 4);
        } else {
          twh = dif.toString().substring(0, 5);
        }
        Get.find<UpdateCheck>().shiftHours = twh;
        //
        //
        List<String> awayTimes = [];
        log("AWAY ${Get.find<UpdateCheck>().away.length}");
        if (Get.find<UpdateCheck>().away[0].isNotEmpty) {
          log("HERE IN AWAY");
          for (int i = 0; i < Get.find<UpdateCheck>().away.length; i++) {
            DateTime awayStartTime =
                DateFormat("HH:mm").parse(Get.find<UpdateCheck>().away[i]);
            if (Get.find<UpdateCheck>().available.length > i + 1) {
              //
              DateTime awayEndTime = DateFormat("HH:mm")
                  .parse(Get.find<UpdateCheck>().available[i + 1]);
              Duration awayDiff = awayEndTime.difference(awayStartTime);

              String totalAwayHours = "";
              if (awayDiff.toString().substring(0, 5)[4] == ":") {
                totalAwayHours = "0${awayDiff.toString().substring(0, 4)}";
                awayTimes.add(totalAwayHours);
              } else {
                totalAwayHours = awayDiff.toString().substring(0, 5);
                awayTimes.add(totalAwayHours);
              }
            }
          }
        } else {
          awayTimes.add("00:00");
          log("AWAY TIMES ${awayTimes}");
        }
        int hours = 0;
        int mins = 0;
        for (int i = 0; i < awayTimes.length; i++) {
          hours = hours + int.parse(awayTimes[i].substring(0, 2));
          mins = mins + int.parse(awayTimes[i].substring(3, 5));
          if (mins > 59) {
            hours = hours + 1;
            mins = mins - 60;
          }
          //
          //
        }
        //
        Get.find<UpdateCheck>().totalAwayHours = "$hours:$mins";
        //
        //

        //total working hours
        DateTime totalWH =
            DateFormat("HH:mm").parse(Get.find<UpdateCheck>().shiftHours);
        //total away time
        DateTime tat =
            DateFormat("HH:mm").parse(Get.find<UpdateCheck>().totalAwayHours);
        Duration workDiff = totalWH.difference(tat);

        if (workDiff.toString()[1] == ":") {
          Get.find<UpdateCheck>().totalWorkingHours =
              workDiff.toString().substring(0, 4);
        } else {
          Get.find<UpdateCheck>().totalWorkingHours =
              workDiff.toString().substring(0, 5);
        }
        //
        //
        Get.find<UpdateCheck>().todayDate =
            DateTime.now().toString().substring(0, 10);
        Get.find<UpdateCheck>().day = {
          "available": Get.find<UpdateCheck>().available,
          "away": Get.find<UpdateCheck>().away,
          "shift hours": Get.find<UpdateCheck>().shiftHours,
          "total away time": Get.find<UpdateCheck>().totalAwayHours,
          "total working time": Get.find<UpdateCheck>().totalWorkingHours,
          "offline": Get.find<UpdateCheck>().offline,
        };
        Get.find<UpdateCheck>().days[Get.find<UpdateCheck>().todayDate] =
            Get.find<UpdateCheck>().day;
        log("day ${Get.find<UpdateCheck>().day}");
        log("days ${Get.find<UpdateCheck>().days}");
        await Get.find<FirebaseRequests>().updateDays();
      }
    }
  }
}
