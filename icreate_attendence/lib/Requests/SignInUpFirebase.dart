// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:icreate_attendence/GetX%20Controllers/updateCheck.dart';

import '../GetX Controllers/TasksController.dart';
import '../GetX Controllers/shared_preferences.dart';

class SignInUp extends GetxController {
  List<bool> validationError = [
    false, //email
    false, //name
    false, //phoneNo
    false, //password
    false, //title
  ].obs();

  List<bool> validType = [
    false, //email
    false, //name
    false, //phoneNo
    false, //password
    false, //title
  ];
  //
  String admin = 'not admin'.obs();
  RxBool adminAcc = false.obs;
  //
  String name = ''.obs();
  String title = ''.obs();
  String phoneNo = ''.obs();
  String email = ''.obs();
  String password = ''.obs();
  int id = 0.obs();

  bool newUserCreated = false.obs();
  String logInErrorMsg = "".obs();

  UpdateCheck updateCheck = Get.find<UpdateCheck>();
  String todayDate = DateTime.now().toString().substring(0, 10).obs();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void deleteUser() async {
    var user = FirebaseAuth.instance.currentUser;
    await user?.delete();
    FirebaseFirestore.instance
        .collection("User Information")
        .where("Email", isEqualTo: Get.find<SignInUp>().email)
        .get()
        .then((value) {
      for (var element in value.docs) {
        FirebaseFirestore.instance
            .collection("User Information")
            .doc(element.id)
            .delete()
            .then((value) {
          log("Success!");
        });
      }
    });
  }

  void inputTasksWhenEmpty() async {
    final User? user = auth.currentUser;
    try {
      Get.find<TasksController>().updateOneTask(Get.find<SignInUp>().todayDate);
      Get.find<TasksController>()
          .stringTasksKeys
          .add(Get.find<SignInUp>().todayDate);
      Get.find<TasksController>().tasks[Get.find<SignInUp>().todayDate] =
          Get.find<TasksController>().task;
      //
      await firestore.collection("Tasks").doc(user?.uid).set({
        "Tasks": Get.find<TasksController>().tasks,
      }).then((value) => log("Tasks Recorded successfully"));
    } on Exception catch (e) {
      log('ERROR IN INPUT DATA $e');
    }
  }

  Future<void> inputData() async {
    final User? user = auth.currentUser;

    try {
      await firestore.collection("User Information").doc(user?.uid).set({
        "Name": Get.find<SignInUp>().name,
        "Title": Get.find<SignInUp>().title,
        "Email": Get.find<SignInUp>().email,
        "Phone Number": Get.find<SignInUp>().phoneNo,
        "Password": Get.find<SignInUp>().password,
        "ID": Get.find<SignInUp>().id,
        "admin": "not admin",
      });
    } on Exception catch (e) {
      log('ERROR IN INPUT DATA $e');
    }
    try {
      Get.find<TasksController>().tasks = {};
      Get.find<TasksController>().milestonesMap = {};
      Get.find<TasksController>().tasksProgress.clear();
      Get.find<TasksController>().tasksTitle = [
        [""]
      ];
      Get.find<TasksController>().tasksDesc = [
        [""]
      ];
      Get.find<TasksController>().tasksTimesStart = [
        [""]
      ];
      Get.find<TasksController>().tasksTimesEnd = [
        [""]
      ];
      // Get.find<TasksController>().updateOneTask(Get.find<SignInUp>().todayDate);
      // Get.find<TasksController>().tasks[Get.find<SignInUp>().todayDate] =
      //     Get.find<TasksController>().task;
      //
      await firestore.collection("Tasks").doc(user?.uid).set({
        "Tasks": Get.find<TasksController>().tasks,
      }).then((value) => log("Tasks Recorded successfully"));
    } on Exception catch (e) {
      log('ERROR IN INPUT DATA $e');
    }
    try {
      updateCheck.day = {
        "available": updateCheck.available,
        "away": updateCheck.away,
        "shift hours": updateCheck.shiftHours,
        "total away time": updateCheck.totalAwayHours,
        "total working time": updateCheck.totalWorkingHours,
        "offline": updateCheck.offline,
      };
      updateCheck.days[Get.find<SignInUp>().todayDate] = updateCheck.day;
      await firestore.collection("Adherence").doc(user?.uid).set({
        "days": updateCheck.days,
        "current status": updateCheck.currentStatus,
      }).then((value) => log("Adherence was created successfully"));
    } on Exception catch (e) {
      log('ERROR IN INPUT DATA $e');
    }
    try {
      await firestore.collection("Done Tasks").doc(user?.uid).set({
        "done tasks": Get.find<SharedPreferencesController>().dateTasksDone,
      }).then((value) => log("Adherence was created successfully"));
    } on Exception catch (e) {
      log('ERROR IN INPUT DATA $e');
    }
  }

  Future<bool> logIn() async {
    bool loggedIn = false;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: Get.find<SignInUp>().email,
        password: Get.find<SignInUp>().password,
      );
      loggedIn = true;
    } on FirebaseAuthException catch (e) {
      loggedIn = false;
      if (e.code == 'user-not-found') {
        Get.find<SignInUp>().logInErrorMsg = 'user-not-found';
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.find<SignInUp>().logInErrorMsg = 'wrong-password';
        log('Wrong password provided for that user.');
      }
    }
    return loggedIn;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                "Loading",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              )),
        ],
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
