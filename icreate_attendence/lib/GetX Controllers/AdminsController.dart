import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/Widgets_/AdminRowCards.dart';
import 'package:icreate_attendence/Widgets_/Card.dart';

import '../Widgets_/CustText.dart';
import '../Widgets_/TwoCardsRow.dart';
import 'NewTaskController.dart';
import 'TasksController.dart';

class AdminController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TasksController tasksController = Get.find<TasksController>();
  Map<dynamic, dynamic> adminTasks = {}.obs;
  //
  RxList<Widget> adminCards = RxList();
  //
  void updateAdminCards() {
    var temp = Get.find<AdminController>().setAdminCards();

    ///
    List<Widget> rowCards = [];
    List<Widget> tempRowCards = [];
    for (int i = 0; i < temp.length; i++) {
      tempRowCards.add(temp[i]);
      if (tempRowCards.length % 2 == 0) {
        rowCards.add(AdminRowCards(
            card1: tempRowCards[0], card2: tempRowCards[1], twoCards: true));
        tempRowCards = [];
      }
    }
    if (tempRowCards.length == 1) {
      rowCards.add(AdminRowCards(
          card1: tempRowCards[0], card2: Container(), twoCards: false));
    }
    Get.find<AdminController>().adminCards.value = rowCards;
    //     Get.find<AdminController>()
    //         .setAdminRow(temp);
    Get.find<AdminController>().adminCards.refresh();
  }

  Future<void> getAdminTasks() async {
    Get.find<AdminController>().adminTasks = {};
    try {
      await firestore
          .collection("Admin Tasks")
          .doc("admin tasks")
          .get()
          .then((value) {
        if (!value.exists) {
          log("something went Wrong");
        }
        if (value.exists) {
          Map<String, dynamic>? data = value.data();
          Get.find<AdminController>().adminTasks = data?['admin tasks'];
        }
      });
    } on Exception catch (e) {
      log("FAILED $e");
    }
  }

  Future<void> updateAdminTasks() async {
    try {
      await firestore.collection("Admin Tasks").doc("admin tasks").update({
        "admin tasks": Get.find<AdminController>().adminTasks,
      }).then((value) => log("Admin Tasks Recorded successfully"));
    } on Exception catch (e) {
      log('ERROR IN UPDATING ADMIN DATA $e');
    }
  }

  void updateAdminData() {
    //
    /// admin tasks map will be different from tasks map
    /// the admin map will be a map of employees' names, which is a map of dates
    /// adminTasks{
    ///   employee's name:{
    ///     date:{
    ///       tasks titles:[],
    ///       tasks desc:[],
    ///       tasks start times:[],
    ///       tasks end times:[],
    ///       tasks milestones:{
    ///         task name:[] milestones of the task
    ///       },
    ///       tasks progress:{
    ///         task name:[] progress of the task
    ///       },
    ///
    ///     }
    ///   }
    /// }
    //
    if (!Get.find<AdminController>()
        .adminTasks
        .keys
        .contains(Get.find<NewTaskController>().implementInUser.value)) {
      Get.find<AdminController>()
          .adminTasks[Get.find<NewTaskController>().implementInUser.value] = {};
    }
    if (!Get.find<AdminController>()
        .adminTasks[Get.find<NewTaskController>().implementInUser.value]
        .keys
        .contains(tasksController.trackDate)) {
      Get.find<AdminController>()
              .adminTasks[Get.find<NewTaskController>().implementInUser.value]
          [tasksController.trackDate] = {};
      Get.find<AdminController>()
              .adminTasks[Get.find<NewTaskController>().implementInUser.value]
          [tasksController.trackDate]['Tasks Titles'] = [""];
      Get.find<AdminController>()
              .adminTasks[Get.find<NewTaskController>().implementInUser.value]
          [tasksController.trackDate]['Tasks Description'] = [""];
      Get.find<AdminController>()
              .adminTasks[Get.find<NewTaskController>().implementInUser.value]
          [tasksController.trackDate]['Tasks Start Times'] = [""];
      Get.find<AdminController>()
              .adminTasks[Get.find<NewTaskController>().implementInUser.value]
          [tasksController.trackDate]['Tasks End Times'] = [""];
      Get.find<AdminController>()
              .adminTasks[Get.find<NewTaskController>().implementInUser.value]
          [tasksController.trackDate]['Milestones'] = {};
      Get.find<AdminController>()
              .adminTasks[Get.find<NewTaskController>().implementInUser.value]
          [tasksController.trackDate]['tasks progress'] = {};
    }

    tasksController.updateArray(
        Get.find<AdminController>()
                .adminTasks[Get.find<NewTaskController>().implementInUser.value]
            [tasksController.trackDate]['Tasks Titles'],
        tasksController.trackTitle);
    //
    tasksController.updateArray(
        Get.find<AdminController>()
                .adminTasks[Get.find<NewTaskController>().implementInUser.value]
            [tasksController.trackDate]['Tasks Description'],
        tasksController.trackDesc);
    //
    tasksController.updateArray(
        Get.find<AdminController>()
                .adminTasks[Get.find<NewTaskController>().implementInUser.value]
            [tasksController.trackDate]['Tasks Start Times'],
        tasksController.trackStart);
    //
    tasksController.updateArray(
        Get.find<AdminController>()
                .adminTasks[Get.find<NewTaskController>().implementInUser.value]
            [tasksController.trackDate]['Tasks End Times'],
        tasksController.trackEnd);
    //
    List<String> miles = [];
    for (int i = 0; i < tasksController.mileStonesString.length; i++) {
      miles.add(tasksController.mileStonesString[i]);
    }
    if (Get.find<AdminController>()
                .adminTasks[Get.find<NewTaskController>().implementInUser.value]
            [tasksController.trackDate]['Milestones'] ==
        null) {
      Get.find<AdminController>()
              .adminTasks[Get.find<NewTaskController>().implementInUser.value]
          [tasksController.trackDate]['Milestones'] = {};
      Get.find<AdminController>().adminTasks[Get.find<NewTaskController>()
              .implementInUser
              .value][tasksController.trackDate]['Milestones']
          [tasksController.trackTitle] = miles;
      log("new mile ${Get.find<AdminController>().adminTasks[Get.find<NewTaskController>().implementInUser.value][tasksController.trackDate]['Milestones'][tasksController.trackTitle]}");
    } else {
      Get.find<AdminController>().adminTasks[Get.find<NewTaskController>()
              .implementInUser
              .value][tasksController.trackDate]['Milestones']
          [tasksController.trackTitle] = miles;
    }
    List<bool> adminEmployeeProgress = [];
    for (int i = 0; i < tasksController.mileStonesString.length; i++) {
      adminEmployeeProgress.add(false);
    }
    if (Get.find<AdminController>()
                .adminTasks[Get.find<NewTaskController>().implementInUser.value]
            [tasksController.trackDate]['tasks progress'] ==
        null) {
      Get.find<AdminController>()
              .adminTasks[Get.find<NewTaskController>().implementInUser.value]
          [tasksController.trackDate]['tasks progress'] = {};
      Get.find<AdminController>().adminTasks[Get.find<NewTaskController>()
              .implementInUser
              .value][tasksController.trackDate]['tasks progress']
          [tasksController.trackTitle] = adminEmployeeProgress;
    } else {
      Get.find<AdminController>().adminTasks[Get.find<NewTaskController>()
              .implementInUser
              .value][tasksController.trackDate]['tasks progress']
          [tasksController.trackTitle] = adminEmployeeProgress;
    }
  }

//

  List<Widget> setAdminCards() {
    int count = 0;
    List<Widget> tempCards = [];
    List<int> colors2 = [];
    if (Get.find<AdminController>().adminTasks.isNotEmpty) {
      List<dynamic> namesKeys =
          Get.find<AdminController>().adminTasks.keys.toList();
      //
      for (int i = 0; i < namesKeys.length; i++) {
        List<dynamic> datesKeys = Get.find<AdminController>()
            .adminTasks[namesKeys[i].toString()]
            .keys
            .toList();
        //
        for (int j = 0; j < datesKeys.length; j++) {
          //
          for (int k = 0;
              k <
                  Get.find<AdminController>()
                      .adminTasks[namesKeys[i].toString()]
                          [datesKeys[j].toString()]['Tasks Titles']
                      .length;
              k++) {
            //
            if (count == 4) {
              count = 0;
            }

            double percent = 0;
            int totalTrue = 0;
            int totalCount = 0;
            for (int z = 0;
                z <
                    Get.find<AdminController>()
                        .adminTasks[namesKeys[i].toString()]
                            [datesKeys[j].toString()]['tasks progress'][
                            Get.find<AdminController>()
                                .adminTasks[namesKeys[i].toString()]
                                    [datesKeys[j].toString()]['Tasks Titles'][k]
                                .toString()]
                        .length;
                z++) {
              //
              totalCount++;
              if (Get.find<AdminController>()
                              .adminTasks[namesKeys[i].toString()]
                          [datesKeys[j].toString()]['tasks progress'][
                      Get.find<AdminController>()
                          .adminTasks[namesKeys[i].toString()]
                              [datesKeys[j].toString()]['Tasks Titles'][k]
                          .toString()][z] ==
                  true) {
                totalTrue++;
              }
              percent = totalTrue / totalCount;
            }

            tempCards.add(CustCard(
              mainText: Get.find<AdminController>()
                  .adminTasks[namesKeys[i].toString()][datesKeys[j].toString()]
                      ['Tasks Titles'][k]
                  .toString(),
              color: Get.find<TasksController>().colors[count],
              percent: percent,
              desc: Get.find<AdminController>()
                  .adminTasks[namesKeys[i].toString()][datesKeys[j].toString()]
                      ['Tasks Description'][k]
                  .toString(),
              milestones: List<String>.from(Get.find<AdminController>()
                          .adminTasks[namesKeys[i].toString()]
                      [datesKeys[j].toString()]['Milestones'][
                  Get.find<AdminController>()
                          .adminTasks[namesKeys[i].toString()]
                      [datesKeys[j].toString()]['Tasks Titles'][k]]),
              date: datesKeys[j].toString(),
              admin: true,
              name: namesKeys[i].toString(),
            ));

            //
            count++;
          }
        }
      }
    } else {
      tempCards.add(Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          CustText(text: "No Active projects", fontSize: 20),
        ],
      ));
    }
    return tempCards;
  }

  List<Widget> setAdminRow(List<Widget> cards) {
    List<Widget> rowCards = [];
    List<Widget> tempRowCards = [];
    for (int i = 0; i < cards.length; i++) {
      tempRowCards.add(cards[i]);
      if (i % 2 == 0) {
        rowCards.add(AdminRowCards(
            card1: tempRowCards[0], card2: tempRowCards[1], twoCards: true));
        tempRowCards = [];
      }
    }
    if (tempRowCards.length == 1) {
      rowCards.add(AdminRowCards(
          card1: tempRowCards[0], card2: Container(), twoCards: false));
    }
    return rowCards;
  }
  //
}
