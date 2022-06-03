// ignore_for_file: unnecessary_string_interpolations

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icreate_attendence/GetX%20Controllers/TasksController.dart';
import 'package:icreate_attendence/GetX%20Controllers/updateCheck.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';

class FirebaseRequests extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //
  Future<void> currentUserData() async {
    final User? user = auth.currentUser;
    try {
      await firestore
          .collection("User Information")
          .doc(user?.uid)
          .get()
          .then((value) {
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
            Get.find<SignInUp>().adminAcc = false;
          } else {
            Get.find<SignInUp>().adminAcc = true;
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