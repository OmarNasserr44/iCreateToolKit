import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/GetX%20Controllers/AdminsController.dart';
import 'package:icreate_attendence/GetX%20Controllers/updateCheck.dart';

import '../Requests/SignInUpFirebase.dart';
import '../Widgets_/AdminRowCards.dart';
import '../Widgets_/Card.dart';
import '../Widgets_/CustText.dart';
import 'TasksController.dart';

class DoneTasksHistory extends GetxController {
  Map<dynamic, dynamic> doneHistory = {}.obs();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
//
  RxList<Widget> doneCards = RxList();

  //
  String todayDate = DateTime.now().toString().substring(0, 10).obs().obs();
  //
  Future<void> getDoneHistory() async {
    Get.find<DoneTasksHistory>().doneHistory = {};
    try {
      await firestore
          .collection("Done History")
          .doc("done history")
          .get()
          .then((value) {
        if (!value.exists) {
          log("something went Wrong");
        }
        if (value.exists) {
          Map<String, dynamic>? data = value.data();
          Get.find<DoneTasksHistory>().doneHistory = data?['history'];
          log("DONE HIST ${Get.find<DoneTasksHistory>().doneHistory}");
        }
      });
    } on Exception catch (e) {
      log("FAILED $e");
    }
  }

  //
  Future<void> updateDoneTasks() async {
    try {
      await firestore.collection("Done History").doc("done history").update({
        "history": Get.find<DoneTasksHistory>().doneHistory,
      }).then((value) => log("DoneHistory Recorded successfully"));
    } on Exception catch (e) {
      log('ERROR IN UPDATING DoneHistory DATA $e');
    }
  }

  //
  //
  void initDoneHistory() {
    Get.find<DoneTasksHistory>()
            .doneHistory[Get.find<DoneTasksHistory>().todayDate]
        [Get.find<SignInUp>().name] = {};
    Get.find<DoneTasksHistory>()
            .doneHistory[Get.find<DoneTasksHistory>().todayDate]
        [Get.find<SignInUp>().name]["Tasks Titles"] = [];
    Get.find<DoneTasksHistory>()
            .doneHistory[Get.find<DoneTasksHistory>().todayDate]
        [Get.find<SignInUp>().name]["Tasks Desc"] = [];
    Get.find<DoneTasksHistory>()
            .doneHistory[Get.find<DoneTasksHistory>().todayDate]
        [Get.find<SignInUp>().name]["Tasks Start Times"] = [];
    Get.find<DoneTasksHistory>()
            .doneHistory[Get.find<DoneTasksHistory>().todayDate]
        [Get.find<SignInUp>().name]["Tasks End Times"] = [];
    Get.find<DoneTasksHistory>()
            .doneHistory[Get.find<DoneTasksHistory>().todayDate]
        [Get.find<SignInUp>().name]["Tasks Dates"] = [];
    Get.find<DoneTasksHistory>()
            .doneHistory[Get.find<DoneTasksHistory>().todayDate]
        [Get.find<SignInUp>().name]["Milestones"] = {};
  }

  ///
  ///
  Future<void> updateDoneHistory(
      String date, String title, String desc, List<String> milestones) async {
    Get.find<DoneTasksHistory>().doneHistory.clear();
    await Get.find<DoneTasksHistory>().getDoneHistory();
    if (Get.find<AdminController>()
        .adminTasks
        .containsKey(Get.find<SignInUp>().name)) {
      if (Get.find<AdminController>()
          .adminTasks[Get.find<SignInUp>().name]
          .containsKey(date)) {
        if (Get.find<AdminController>()
            .adminTasks[Get.find<SignInUp>().name][date]['tasks progress']
            .containsKey(title)) {
          bool initDoneTasks = false;
          if (Get.find<DoneTasksHistory>().doneHistory.isEmpty) {
            Get.find<DoneTasksHistory>()
                .doneHistory[Get.find<DoneTasksHistory>().todayDate] = {};
            initDoneTasks = true;
          }
          if (Get.find<DoneTasksHistory>()
                  .doneHistory
                  .keys
                  .toList()[0]
                  .toString() !=
              Get.find<DoneTasksHistory>().todayDate) {
            Get.find<DoneTasksHistory>().doneHistory.clear();
            Get.find<DoneTasksHistory>()
                .doneHistory[Get.find<DoneTasksHistory>().todayDate] = {};
            initDoneTasks = true;
          }
          if (initDoneTasks) {
            initDoneHistory();

            ///
            ///
          } else if (!initDoneTasks) {
            List<String> namesDone = List<String>.from(
                Get.find<DoneTasksHistory>()
                    .doneHistory[Get.find<DoneTasksHistory>().todayDate]
                    .keys);
            if (!namesDone.contains(Get.find<SignInUp>().name)) {
              initDoneHistory();
            }
          }

          ///
          ///
          log("SEE DONE ${Get.find<DoneTasksHistory>().doneHistory}");
          int index = Get.find<AdminController>()
              .adminTasks[Get.find<SignInUp>().name][date]['Tasks Titles']
              .indexOf(title);
          Get.find<DoneTasksHistory>()
              .doneHistory[Get.find<DoneTasksHistory>().todayDate]
                  [Get.find<SignInUp>().name]["Tasks Titles"]
              .add(title);
          Get.find<DoneTasksHistory>()
              .doneHistory[Get.find<DoneTasksHistory>().todayDate]
                  [Get.find<SignInUp>().name]["Tasks Dates"]
              .add(date);
          Get.find<DoneTasksHistory>()
              .doneHistory[Get.find<DoneTasksHistory>().todayDate]
                  [Get.find<SignInUp>().name]["Tasks Desc"]
              .add(desc);
          Get.find<DoneTasksHistory>()
              .doneHistory[Get.find<DoneTasksHistory>().todayDate]
                  [Get.find<SignInUp>().name]["Tasks Start Times"]
              .add(Get.find<AdminController>()
                      .adminTasks[Get.find<SignInUp>().name][date]
                  ['Tasks Start Times'][index]);
          Get.find<DoneTasksHistory>()
              .doneHistory[Get.find<DoneTasksHistory>().todayDate]
                  [Get.find<SignInUp>().name]["Tasks End Times"]
              .add(Get.find<AdminController>()
                      .adminTasks[Get.find<SignInUp>().name][date]
                  ['Tasks End Times'][index]);
          Get.find<DoneTasksHistory>()
                  .doneHistory[Get.find<DoneTasksHistory>().todayDate]
              [Get.find<SignInUp>().name]["Milestones"][title] = milestones;
          //
          log("DONE HISTORY ${Get.find<DoneTasksHistory>().doneHistory}");
        }
      }
      await Get.find<DoneTasksHistory>().updateDoneTasks();
    }
  }

  //
//
  ///
  ///
  ///
  void updateDoneCards() {
    var temp = Get.find<DoneTasksHistory>().setDoneCards();

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
    Get.find<DoneTasksHistory>().doneCards.value = rowCards;
    //     Get.find<AdminController>()
    //         .setAdminRow(temp);
    Get.find<DoneTasksHistory>().doneCards.refresh();
  }

  ///
  ///
  List<Widget> setDoneCards() {
    int count = 0;
    List<Widget> tempCards = [];
    if (Get.find<DoneTasksHistory>().doneHistory.isNotEmpty) {
      if (Get.find<DoneTasksHistory>()
              .doneHistory[Get.find<UpdateCheck>().todayDate] !=
          null) {
        List<dynamic> namesKeys = Get.find<DoneTasksHistory>()
            .doneHistory[Get.find<UpdateCheck>().todayDate]
            .keys
            .toList();
        //
        for (int i = 0; i < namesKeys.length; i++) {
          //
          //
          for (int k = 0;
              k <
                  Get.find<DoneTasksHistory>()
                      .doneHistory[Get.find<UpdateCheck>().todayDate]
                          [namesKeys[i].toString()]['Tasks Titles']
                      .length;
              k++) {
            //
            if (count == 4) {
              count = 0;
            }
            tempCards.add(CustCard(
              fromDoneTasks: true,
              mainText: Get.find<DoneTasksHistory>()
                  .doneHistory[Get.find<UpdateCheck>().todayDate]
                      [namesKeys[i].toString()]['Tasks Titles'][k]
                  .toString(),
              color: Get.find<TasksController>().colors[count],
              percent: 1,
              desc: Get.find<DoneTasksHistory>()
                  .doneHistory[Get.find<UpdateCheck>().todayDate]
                      [namesKeys[i].toString()]['Tasks Desc'][k]
                  .toString(),
              milestones: List<String>.from(Get.find<DoneTasksHistory>()
                          .doneHistory[Get.find<UpdateCheck>().todayDate]
                      [namesKeys[i].toString()]['Milestones'][
                  Get.find<DoneTasksHistory>()
                          .doneHistory[Get.find<UpdateCheck>().todayDate]
                      [namesKeys[i].toString()]['Tasks Titles'][k]]),
              date: Get.find<DoneTasksHistory>()
                  .doneHistory[Get.find<UpdateCheck>().todayDate]
                      [namesKeys[i].toString()]['Tasks Dates'][k]
                  .toString(),
              admin: true,
              name: namesKeys[i].toString(),
            ));

            //
            count++;
          }
        }
      } else {
        Get.find<DoneTasksHistory>().doneHistory.clear();
      }
    } else {
      tempCards.add(Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          CustText(text: "No Done Tasks Today", fontSize: 20),
        ],
      ));
    }
    return tempCards;
  }
}
