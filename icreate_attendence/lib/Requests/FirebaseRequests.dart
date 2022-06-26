// ignore_for_file: unnecessary_string_interpolations

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icreate_attendence/GetX%20Controllers/TasksController.dart';
import 'package:icreate_attendence/GetX%20Controllers/updateCheck.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';

import '../GetX Controllers/shared_preferences.dart';

class FirebaseRequests extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //
  String userDoc = "".obs();
  Future<void> currentUserData() async {
    final User? user = auth.currentUser;
    var tempDoc = user?.uid;
    Get.find<FirebaseRequests>().userDoc = tempDoc.toString();
    try {
      await firestore
          .collection("User Information")
          .doc(user?.uid)
          .get()
          .then((value) async {
        if (!value.exists) {
          log("something went Wrong");
        }
        if (value.exists) {
          Map<String, dynamic>? data = value.data();
          Get.find<SignInUp>().name = data?['Name'];
          Get.find<SignInUp>().email = data?['Email'];
          Get.find<SignInUp>().phoneNo = data?['Phone Number'];
          Get.find<SignInUp>().password = data?['Password'];
          Get.find<SignInUp>().id = data?['ID'];
          Get.find<SignInUp>().title = data?['Title'];
          Get.find<SignInUp>().admin = data?['admin'];

          if (Get.find<SignInUp>().admin == "not admin") {
            Get.find<SignInUp>().adminAcc.value = false;
            Get.find<SignInUp>().adminAcc.refresh();
          } else if (Get.find<SignInUp>().admin == "admin") {
            Get.find<SignInUp>().adminAcc.value = true;
            Get.find<SignInUp>().adminAcc.refresh();
          }
        }
      });
    } on Exception catch (e) {
      log("FAILED $e");
    }
    await Get.find<UpdateCheck>().getDaysAdherence();
  }

  Future<void> getDoneTasks() async {
    final User? user = auth.currentUser;
    try {
      await firestore
          .collection("Done Tasks")
          .doc(user?.uid)
          .get()
          .then((value) async {
        if (!value.exists) {
          log("something went Wrong");
        }
        if (value.exists) {
          Map<String, dynamic>? data = value.data();
          Get.find<SharedPreferencesController>().dateTasksDone =
              data?['done tasks'];
          if (Get.find<SharedPreferencesController>().dateTasksDone.isEmpty) {
            Get.find<SharedPreferencesController>().dateTasksDone[""] = "";
          }
          if (Get.find<SharedPreferencesController>()
                  .dateTasksDone
                  .keys
                  .toList()[0]
                  .toString() ==
              Get.find<TasksController>().month.toString()) {
            Get.find<TasksController>().doneTasks.value = int.parse(
                Get.find<SharedPreferencesController>()
                    .dateTasksDone[Get.find<TasksController>().month.toString()]
                    .toString());
            Get.find<TasksController>().doneTasks.refresh();
          } else {
            Get.find<SharedPreferencesController>().dateTasksDone = {};
            Get.find<SharedPreferencesController>().dateTasksDone[
                Get.find<TasksController>().month.toString()] = "0";
            Get.find<TasksController>().doneTasks.value = int.parse(
                Get.find<SharedPreferencesController>().dateTasksDone[
                    Get.find<TasksController>().month.toString()]);
            await Get.find<FirebaseRequests>().updateDoneTasks();
          }
        }
      });
    } on Exception catch (e) {
      log("FAILED $e");
    }
  }

  //
  //
  Future<void> generateID() async {
    final User? user = auth.currentUser;
    try {
      await firestore.collection("IDs").doc('ids').get().then((value) {
        if (!value.exists) {
          log("something went Wrong");
        }
        if (value.exists) {
          Map<String, dynamic>? data = value.data();
          Get.find<SignInUp>().id = data?['ID'];
          log("${Get.find<SignInUp>().id}");
        }
      });
    } on Exception catch (e) {
      log("FAILED $e");
    }
  }

  Future<void> updateIDs() async {
    try {
      final User? user = auth.currentUser;
      await firestore.collection("IDs").doc('ids').set({
        "ID": Get.find<SignInUp>().id + 1,
      }).then((value) => log("Retrieved ID successfully"));
    } on Exception catch (e) {
      log('ERROR IN UPDATING ID $e');
    }
  }

  Future<void> updateDoneTasks() async {
    try {
      final User? user = auth.currentUser;
      await firestore.collection("Done Tasks").doc(user?.uid).update({
        "done tasks": Get.find<SharedPreferencesController>().dateTasksDone,
      }).then((value) => log("Updated dateTasksDone successfully"));
    } on Exception catch (e) {
      log('ERROR IN UPDATING dateTasksDone $e');
    }
  }

  Future<void> updateDays() async {
    try {
      final User? user = auth.currentUser;
      await firestore.collection("Adherence").doc(user?.uid).update({
        "days": Get.find<UpdateCheck>().days,
      }).then((value) => log("days updated successfully"));
    } on Exception catch (e) {
      log('ERROR IN UPDATING days $e');
    }
  }

  //
//
//   void inputTask() async {
//     try {
//       final User? user = auth.currentUser;
//       await firestore.collection("Tasks").doc(user?.uid).set({
//         // "Tasks":
//       }, SetOptions(merge: true));
//     } on Exception catch (e) {
//       print('ERROR IN INPUT DATA $e');
//     }
//   }
}
