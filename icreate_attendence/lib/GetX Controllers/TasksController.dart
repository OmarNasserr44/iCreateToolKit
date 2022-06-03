// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Colors/Colors.dart';
import '../Requests/SignInUpFirebase.dart';
import '../Widgets_/CustText.dart';
import '../Widgets_/DayHours.dart';
import '../Widgets_/TwoCardsRow.dart';

class TasksController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxInt toDo = 0.obs;
  RxInt inProgress = 0.obs;
  RxInt doneTasks = 0.obs;
  String productivity = "Productive Day".obs();
  String trackTitle = "".obs();
  String trackDesc = "".obs();
  String trackDate = DateTime.now().toString().substring(0, 10).obs().obs();
  String trackStart = "".obs();
  String trackEnd = "".obs();
  //
  //
  RxInt profileTasksIndex = 0.obs;
  void incTaskIndex() => profileTasksIndex++;
  void decTaskIndex() => profileTasksIndex--;
  //

  void incToDo() {
    int count = 0;
    for (int i = 0; i < Get.find<TasksController>().tasksTitle.length; i++) {
      for (int j = 0;
          j < Get.find<TasksController>().tasksTitle[i].length;
          j++) {
        if (Get.find<TasksController>().tasksTitle[i][j] != "") {
          count++;
        }
      }
    }
    Get.find<TasksController>().toDo.value = count;
    log("COUNT $count");
    Get.find<TasksController>().toDo.refresh();
  }

  void incInProgress() {
    int count = 0;
    int index = -1;
    if (Get.find<TasksController>()
        .stringTasksKeys
        .contains(Get.find<SignInUp>().todayDate)) {
      index = Get.find<TasksController>()
          .stringTasksKeys
          .indexOf(Get.find<SignInUp>().todayDate);
    }
    if (index != -1) {
      for (int i = 0;
          i < Get.find<TasksController>().tasksTitle[index].length;
          i++) {
        if (Get.find<TasksController>().tasksTitle[index][i] != "") {
          count++;
        }
      }
      Get.find<TasksController>().inProgress.value = count;
      Get.find<TasksController>().inProgress.refresh();
    } else {
      Get.find<TasksController>().inProgress.value = 0;
      Get.find<TasksController>().inProgress.refresh();
    }
  }

  void incDone() {
    Get.find<TasksController>().doneTasks++;
    Get.find<TasksController>().doneTasks.refresh();
  }

  //
  int year = DateTime.now().year;
  int month = DateTime.now().month.obs();
  // int month = 7;
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  // //
  Map<dynamic, dynamic> tasks = {}.obs();
  Map<dynamic, dynamic> task = {}.obs();

  //
  //

  List<Color> colors = [
    Color(0xFFeec085),
    Colors.blue[900]!,
    Colors.red,
    Colors.orange
  ];
  RxList<Widget> cardsRow = RxList();
  void updateCardsRow() {
    Get.find<TasksController>().cardsRow.value =
        Get.find<TasksController>().setCards();
    Get.find<TasksController>().cardsRow.refresh();
  }

  List<Widget> setCards() {
    int count = 0;
    List<Widget> tempCards = [];
    List<String> texts = [];
    List<String> desc = [];
    Map<String, String> date = {};
    Map<String, dynamic> percentage = {};
    List<List<String>> milestonesTemp = [];
    List<int> colors2 = [];
    //
    //use this in if condition if you want to show today's tasks at the draggable sheet
    //Get.find<TasksController>()
    //             .milestonesMap[Get.find<TasksController>().trackDate]
    //
    if (Get.find<TasksController>().milestonesMap.isNotEmpty) {
      //
      //loop over each date
      //
      for (int i = 0;
          i < Get.find<TasksController>().stringTasksKeys.length;
          i++) {
        //
        //loop over each milestone in each title inside specified date
        //this will store milestone in each title
        //
        for (int j = 0;
            j <
                Get.find<TasksController>()
                    .milestonesMap[
                        Get.find<TasksController>().stringTasksKeys[i]]
                    .length;
            j++) {
          milestonesTemp.add(Get.find<TasksController>()
                  .milestonesMap[Get.find<TasksController>().stringTasksKeys[i]]
              [Get.find<TasksController>().tasksTitle[i][j]]);
        }
        //
        //loop over each title in a specified date to store date of each title
        //this will be used in card widget to update the right task progress
        //as we can use progress of each title by calling the tasksProgress map which needs
        //the date to access desired titles
        //
        for (int k = 0;
            k <
                Get.find<TasksController>()
                    .tasks[Get.find<TasksController>().stringTasksKeys[i]]
                        ["Tasks Titles"]
                    .length;
            k++) {
          //
          date[Get.find<TasksController>()
                      .tasks[Get.find<TasksController>().stringTasksKeys[i]]
                  ["Tasks Titles"][k]] =
              Get.find<TasksController>().stringTasksKeys[i];

          //
          //loop over milestones (task progress values) of a specified task and count every true value
          //then divide by the milestones length to get percent of done milestones of a
          //specified task, then assign that percentage to the task title
          //
          double tempPercent = 0;
          int trueCount = 0;
          for (int z = 0;
              z <
                  Get.find<TasksController>()
                      .tasksProgress[
                          Get.find<TasksController>().stringTasksKeys[i]][
                          Get.find<TasksController>().tasks[
                              Get.find<TasksController>()
                                  .stringTasksKeys[i]]["Tasks Titles"][k]]
                      .length;
              z++) {
            if (Get.find<TasksController>().tasksProgress[
                        Get.find<TasksController>().stringTasksKeys[i]][
                    Get.find<TasksController>().tasks[
                            Get.find<TasksController>().stringTasksKeys[i]]
                        ["Tasks Titles"][k]][z] ==
                true) {
              trueCount = trueCount + 1;
            }
          }
          tempPercent = trueCount /
              Get.find<TasksController>()
                  .tasksProgress[Get.find<TasksController>().stringTasksKeys[i]]
                      [Get.find<TasksController>().tasks[
                              Get.find<TasksController>().stringTasksKeys[i]]
                          ["Tasks Titles"][k]]
                  .length;
          //
          percentage[Get.find<TasksController>()
                  .tasks[Get.find<TasksController>().stringTasksKeys[i]]
              ["Tasks Titles"][k]] = tempPercent;
        }
      }
      for (int i = 0; i < Get.find<TasksController>().tasksTitle.length; i++) {
        for (int j = 0;
            j < Get.find<TasksController>().tasksTitle[i].length;
            j++) {
          //
          if (count == 4) {
            count = 0;
          }
          colors2.add(count);
          count = count + 1;
          texts.add(Get.find<TasksController>().tasksTitle[i][j]);
          desc.add(Get.find<TasksController>().tasksDesc[i][j]);
          if (count % 2 == 0) {
            tempCards.add(TwoCardsRow(
              mainText1: texts[0],
              mainText2: texts[1],
              date1: date[texts[0]]!,
              date2: date[texts[1]]!,
              desc1: desc[0],
              desc2: desc[1],
              color1: Get.find<TasksController>().colors[colors2[0]],
              color2: Get.find<TasksController>().colors[colors2[1]],
              percent1: percentage[texts[0]],
              percent2: percentage[texts[1]],
              milestones2: milestonesTemp[1],
              milestones1: milestonesTemp[0],
            ));
            colors2 = [];
            texts = [];
            desc = [];
            milestonesTemp.remove(milestonesTemp[0]);
            milestonesTemp.remove(milestonesTemp[0]);
          }
        }
      }
      if (texts.length == 1) {
        tempCards.add(TwoCardsRow(
          mainText1: texts[0],
          mainText2: "", //hidden card
          date1: date[texts[0]]!,
          date2: "", //hidden card
          desc1: desc[0],
          desc2: "", //hidden card
          color1: Get.find<TasksController>().colors[colors2[0]],
          color2: Colors.blue, //hidden card
          percent1: percentage[texts[0]],
          percent2: 0.3, //hidden card
          twoCards: false, //shows only first card
          milestones2: milestonesTemp[0],
          milestones1: milestonesTemp[0], //hidden card
        ));
        milestonesTemp.remove(milestonesTemp[0]);
      }
    } else {
      tempCards.add(Column(
        children: [
          SizedBox(
            height: 30,
          ),
          CustText(text: "No Active projects", fontSize: 20),
        ],
      ));
    }
    return tempCards;
  }
  //

  //
  List<dynamic> tasksKeys = [].obs();
  List<String> stringTasksKeys = [""].obs();
  //

  List<List<String>> tasksTimesStart = [
    [""]
  ].obs();
  List<List<String>> tasksTimesEnd = [
    [""]
  ].obs();
  List<String> tasksDate = [""].obs();
  List<List<String>> tasksTitle = [
    [""]
  ].obs();
  List<List<String>> tasksDesc = [
    [""]
  ].obs();

  List<Color> tasksColors = [
    const Color(0xFFfae5ca),
    const Color(0xFFd7e3fb),
    const Color(0xFFf7d4d4)
  ];

  //
  Future<void> createNewTask(String date) async {
    updateOneTask(date);
    Get.find<TasksController>().tasks[date] = Get.find<TasksController>().task;
    try {
      final User? user = auth.currentUser;
      await firestore.collection("Tasks").doc(user?.uid).update({
        "Tasks": tasks,
      }).then((value) => log("Tasks Recorded successfully"));
    } on Exception catch (e) {
      log('ERROR IN INPUT DATA $e');
    }
  }

  Future<void> updateTasks() async {
    try {
      final User? user = auth.currentUser;
      await firestore.collection("Tasks").doc(user?.uid).update({
        "Tasks": tasks,
      }).then((value) => log("Tasks Recorded successfully"));
    } on Exception catch (e) {
      log('ERROR IN INPUT DATA $e');
    }
  }

  //
  void updateOneTask(String date) {
    int index = 0;
    if (!Get.find<TasksController>().stringTasksKeys.contains(date)) {
      index = 0;
    } else {
      index = Get.find<TasksController>().stringTasksKeys.indexOf(date);
    }
    Get.find<TasksController>().task = {
      "Tasks Titles": Get.find<TasksController>().tasksTitle[index],
      "Tasks Description": Get.find<TasksController>().tasksDesc[index],
      "Tasks Start Times": Get.find<TasksController>().tasksTimesStart[index],
      "Tasks End Times": Get.find<TasksController>().tasksTimesEnd[index],
      "Milestones": Get.find<TasksController>().milestonesMap[date],
      "tasks progress": Get.find<TasksController>().tasksProgress[date],
    };
  }

  void taskDone(
      String date, String title, BuildContext context, Size screenSize) {
    int index = 0;
    int dayIndex = 0;
    dayIndex = Get.find<TasksController>().stringTasksKeys.indexOf(date);
    //
    List<bool> checkDone = [];
    for (int i = 0;
        i < Get.find<TasksController>().tasksProgress[date][title].length;
        i++) {
      if (Get.find<TasksController>().tasksProgress[date][title][i]) {
        checkDone.add(true);
      }
    }
    //
    //if user has reached all the milestones then remove that task
    //
    if (checkDone.length ==
        Get.find<TasksController>().tasksProgress[date][title].length) {
      //
      index = Get.find<TasksController>().tasksTitle[dayIndex].indexOf(title);
      //
      //remove task details at tasksTitle, tasksDesc, tasksTimeStart, tasksTimeEnd, milestoneMap,
      //tasksProgress arrays
      //
      Get.find<TasksController>().tasksTitle[dayIndex].removeAt(index);
      Get.find<TasksController>().tasksDesc[dayIndex].removeAt(index);
      Get.find<TasksController>().tasksTimesStart[dayIndex].removeAt(index);
      Get.find<TasksController>().tasksTimesEnd[dayIndex].removeAt(index);
      //
      Get.find<TasksController>().milestonesMap[date].remove(title);
      Get.find<TasksController>().tasksProgress[date].remove(title);
      //

      //
      //if after deleting task's details that day has no more tasks
      //
      if (Get.find<TasksController>().milestonesMap[date].isEmpty) {
        //
        //remove that day data from all the arrays
        //and delete that day from the tasks array because it has no more tasks
        //as well as from the array containing all keys of the tasks
        //
        Get.find<TasksController>().tasksTitle.removeAt(dayIndex);
        Get.find<TasksController>().tasksDesc.removeAt(dayIndex);
        Get.find<TasksController>().tasksTimesStart.removeAt(dayIndex);
        Get.find<TasksController>().tasksTimesEnd.removeAt(dayIndex);
        //
        Get.find<TasksController>().milestonesMap.remove(date);
        Get.find<TasksController>().tasksProgress.remove(date);
        Get.find<TasksController>().tasks.remove(date);

        Get.find<TasksController>().stringTasksKeys.removeAt(dayIndex);
        //
        //if after deleting that task the tasks array left empty then we input new empty
        //data similar to a new signed up user to not miss with the database structure
        //
        if (Get.find<TasksController>().tasks.isEmpty) {
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
          Get.find<TasksController>().milestonesMap.clear();
          Get.find<TasksController>().tasksProgress.clear();
          Get.find<TasksController>().cardsRow.clear();
          Get.find<TasksController>().cardsRow.value =
              Get.find<TasksController>().setCards();
          // Get.find<TasksController>().cardsRow.add(Column(
          //       children: [
          //         SizedBox(
          //           height: 30,
          //         ),
          //         CustText(text: "No Active projects", fontSize: 20),
          //       ],
          //     ));
          Get.find<SignInUp>().inputTasksWhenEmpty();
          Get.find<TasksController>().tasksKeys =
              Get.find<TasksController>().tasks.keys.toList();
          Get.back();
        }
        //
        //if the tasks wasn't empty then update the tasks array with the left tasks
        //
        else {
          Get.find<TasksController>().cardsRow.value =
              Get.find<TasksController>().setCards();
          Get.find<TasksController>().tasksKeys =
              Get.find<TasksController>().tasks.keys.toList();
          Get.find<TasksController>().updateTasks();
        }
      }
      //
      //if after deleting the task that day still containing tasks, then update that day's tasks
      //
      else {
        Get.find<TasksController>().cardsRow.value =
            Get.find<TasksController>().setCards();

        Get.find<TasksController>().createNewTask(date);
      }
      Get.find<TasksController>().incToDo();
      Get.find<TasksController>().incInProgress();
      Get.find<TasksController>().incDone();
      Get.back();

      //
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: mainTextColor,
        content: Text(
          "You haven't reached all the milestones for $title \n${checkDone.length} milestones was reached out of ${Get.find<TasksController>().tasksProgress[date][title].length}",
          style:
              TextStyle(color: Colors.white, fontSize: screenSize.width / 20),
        ),
      ));
    }
  }

  List<dynamic> updateArray(List<dynamic> updatedList, String insert) {
    if (updatedList[0] == "" || updatedList.isEmpty) {
      updatedList[0] = insert;
    } else {
      updatedList.add(insert);
    }
    return updatedList;
  }

//
  RxDouble percent = 0.0.obs;
  double setPercent() {
    Get.find<TasksController>().percent.value =
        Get.find<TasksController>().totalPercent();
    Get.find<TasksController>().percent.refresh();
    return Get.find<TasksController>().percent.value;
  }

  double totalPercent() {
    double percent = 0;
    int trueCount = 0;
    int totalMilestones = 0;
    //
    if (Get.find<TasksController>()
                .tasks[Get.find<TasksController>().tasksKeys[0].toString()]
            ["Milestones"] !=
        null) {
      for (int i = 0;
          i < Get.find<TasksController>().stringTasksKeys.length;
          i++) {
        for (int j = 0;
            j <
                Get.find<TasksController>()
                    .milestonesMap[
                        Get.find<TasksController>().stringTasksKeys[i]]
                    .length;
            j++) {
          for (int k = 0;
              k <
                  Get.find<TasksController>()
                      .tasks[Get.find<TasksController>().stringTasksKeys[i]]
                          ["Tasks Titles"]
                      .length;
              k++) {
            totalMilestones = totalMilestones +
                int.parse(Get.find<TasksController>()
                    .tasksProgress[Get.find<TasksController>()
                        .stringTasksKeys[i]][Get.find<TasksController>().tasks[
                            Get.find<TasksController>().stringTasksKeys[i]]
                        ["Tasks Titles"][k]]
                    .length
                    .toString());
            for (int z = 0;
                z <
                    Get.find<TasksController>()
                        .tasksProgress[
                            Get.find<TasksController>().stringTasksKeys[i]][
                            Get.find<TasksController>().tasks[
                                Get.find<TasksController>()
                                    .stringTasksKeys[i]]["Tasks Titles"][k]]
                        .length;
                z++) {
              //
              if (Get.find<TasksController>().tasksProgress[
                          Get.find<TasksController>().stringTasksKeys[i]][
                      Get.find<TasksController>().tasks[
                              Get.find<TasksController>().stringTasksKeys[i]]
                          ["Tasks Titles"][k]][z] ==
                  true) {
                trueCount = trueCount + 1;
              }
            }
          }
        }
        percent = trueCount / totalMilestones;
      }
    } else {
      percent = 0.001;
    }
    return percent;
  }

  //
//
  Future<void> getUserTasks() async {
    final User? user = auth.currentUser;
    Map<dynamic, dynamic> tempMilestone = {};
    Map<dynamic, dynamic> tempProgressBool = {};
    try {
      await firestore.collection("Tasks").doc(user?.uid).get().then((value) {
        if (!value.exists) {
          log("something went Wrong");
        }
        if (value.exists) {
          Map<String, dynamic>? data = value.data();
          Get.find<TasksController>().tasks = data?['Tasks'];
        }
        Get.find<TasksController>().tasksKeys =
            Get.find<TasksController>().tasks.keys.toList();
        if (Get.find<TasksController>()
                    .tasks[Get.find<TasksController>().tasksKeys[0].toString()]
                ["Milestones"] !=
            null) {
          for (int i = 0;
              i < Get.find<TasksController>().tasksKeys.length - 1;
              i++) {
            Get.find<TasksController>().tasksTitle.add([""]);
            Get.find<TasksController>().tasksDesc.add([""]);
            Get.find<TasksController>().tasksTimesStart.add([""]);
            Get.find<TasksController>().tasksTimesEnd.add([""]);
            // Get.find<TasksController>().milestonesMap.add([""]);
          }
          for (int i = 0;
              i < Get.find<TasksController>().tasksKeys.length;
              i++) {
            //
            //
            if (Get.find<TasksController>().stringTasksKeys[0] == "") {
              Get.find<TasksController>().stringTasksKeys[0] =
                  Get.find<TasksController>().tasksKeys[i].toString();
            } else {
              Get.find<TasksController>()
                  .stringTasksKeys
                  .add(Get.find<TasksController>().tasksKeys[i].toString());
            }
            //
            var a = Get.find<TasksController>()
                    .tasks[Get.find<TasksController>().stringTasksKeys[i]]
                ["Tasks Titles"];

            for (int j = 0;
                j <
                    Get.find<TasksController>()
                        .tasks[Get.find<TasksController>().stringTasksKeys[i]]
                            ["Tasks Titles"]
                        .length;
                j++) {
              if (Get.find<TasksController>().tasksTitle[i][0] == "") {
                Get.find<TasksController>().tasksTitle[i][j] = Get.find<
                        TasksController>()
                    .tasks[Get.find<TasksController>().tasksKeys[i].toString()]
                        ["Tasks Titles"][j]
                    .toString();
              } else {
                Get.find<TasksController>().tasksTitle[i].add(
                    Get.find<TasksController>().tasks[
                            Get.find<TasksController>().tasksKeys[i].toString()]
                        ["Tasks Titles"][j]);
              }

              if (Get.find<TasksController>().tasksDesc[i][0] == "") {
                Get.find<TasksController>().tasksDesc[i][0] = Get.find<
                        TasksController>()
                    .tasks[Get.find<TasksController>().tasksKeys[i].toString()]
                        ["Tasks Description"][j]
                    .toString();
              } else {
                Get.find<TasksController>().tasksDesc[i].add(
                    Get.find<TasksController>().tasks[
                            Get.find<TasksController>().tasksKeys[i].toString()]
                        ["Tasks Description"][j]);
              }

              if (Get.find<TasksController>().tasksTimesStart[i][0] == "") {
                Get.find<TasksController>().tasksTimesStart[i][0] = Get.find<
                        TasksController>()
                    .tasks[Get.find<TasksController>().tasksKeys[i].toString()]
                        ["Tasks Start Times"][j]
                    .toString();
              } else {
                Get.find<TasksController>().tasksTimesStart[i].add(
                    Get.find<TasksController>().tasks[
                            Get.find<TasksController>().tasksKeys[i].toString()]
                        ["Tasks Start Times"][j]);
              }

              if (Get.find<TasksController>().tasksTimesEnd[i][0] == "") {
                Get.find<TasksController>().tasksTimesEnd[i][0] = Get.find<
                        TasksController>()
                    .tasks[Get.find<TasksController>().tasksKeys[i].toString()]
                        ["Tasks End Times"][j]
                    .toString();
              } else {
                Get.find<TasksController>().tasksTimesEnd[i].add(
                    Get.find<TasksController>().tasks[
                            Get.find<TasksController>().tasksKeys[i].toString()]
                        ["Tasks End Times"][j]);
              }
              List<String> milestonesRetrieved = [];

              if (Get.find<TasksController>().tasks[Get.find<TasksController>()
                      .tasksKeys[i]
                      .toString()]["Milestones"] !=
                  null) {
                for (int k = 0;
                    k <
                        Get.find<TasksController>()
                            .tasks[Get.find<TasksController>()
                                    .tasksKeys[i]
                                    .toString()]["Milestones"][
                                Get.find<TasksController>()
                                    .tasks[Get.find<TasksController>()
                                        .tasksKeys[i]
                                        .toString()]["Tasks Titles"][j]
                                    .toString()]
                            .length;
                    k++) {
                  milestonesRetrieved.add(Get.find<TasksController>().tasks[
                      Get.find<TasksController>()
                          .tasksKeys[i]
                          .toString()]["Milestones"][Get.find<TasksController>()
                      .tasks[Get.find<TasksController>()
                          .tasksKeys[i]
                          .toString()]["Tasks Titles"][j]
                      .toString()][k]);
                }
                //
                tempMilestone[Get.find<TasksController>()
                    .tasks[Get.find<TasksController>().tasksKeys[i].toString()]
                        ["Tasks Titles"][j]
                    .toString()] = milestonesRetrieved;
                //
                Get.find<TasksController>().milestonesMap[
                        Get.find<TasksController>().stringTasksKeys[i]] =
                    tempMilestone;
              }
              List<bool> progressBoolRet = [];

              if (Get.find<TasksController>().tasks[Get.find<TasksController>()
                      .tasksKeys[i]
                      .toString()]["tasks progress"] !=
                  null) {
                for (int k = 0;
                    k <
                        Get.find<TasksController>()
                            .tasks[Get.find<TasksController>()
                                    .tasksKeys[i]
                                    .toString()]["tasks progress"][
                                Get.find<TasksController>()
                                    .tasks[Get.find<TasksController>()
                                        .tasksKeys[i]
                                        .toString()]["Tasks Titles"][j]
                                    .toString()]
                            .length;
                    k++) {
                  progressBoolRet.add(Get.find<TasksController>().tasks[
                          Get.find<TasksController>()
                              .tasksKeys[i]
                              .toString()]["tasks progress"][
                      Get.find<TasksController>()
                          .tasks[Get.find<TasksController>()
                              .tasksKeys[i]
                              .toString()]["Tasks Titles"][j]
                          .toString()][k]);
                }

                tempProgressBool[Get.find<TasksController>()
                    .tasks[Get.find<TasksController>().tasksKeys[i].toString()]
                        ["Tasks Titles"][j]
                    .toString()] = progressBoolRet;
                //
                Get.find<TasksController>().tasksProgress[
                        Get.find<TasksController>().stringTasksKeys[i]] =
                    tempProgressBool;
              }
            }
            tempMilestone = {};
            tempProgressBool = {};
          }
        }
        log("Title ${Get.find<TasksController>().tasksTitle}");
        log("Desc ${Get.find<TasksController>().tasksDesc}");
        log("Times Start ${Get.find<TasksController>().tasksTimesStart}");
        log("Times End ${Get.find<TasksController>().tasksTimesEnd}");
        log("Keys ${Get.find<TasksController>().tasksKeys}");
        log("String Keys ${Get.find<TasksController>().stringTasksKeys}");
        log("Milestone ${Get.find<TasksController>().milestonesMap}");
        log("tasks progress ${Get.find<TasksController>().tasksProgress}");
      });
    } on Exception catch (e) {
      log("FAILED $e");
    }
  }

  //
  RxList<Widget> hoursAndTimeList = <Widget>[].obs;

  //

  List<Widget> setAllDayHours(String date) {
    hoursAndTimeList = <Widget>[].obs;
    int tasksLen = 0;
    if (Get.find<TasksController>()
                .tasks[Get.find<TasksController>().tasksKeys[0].toString()]
            ["Milestones"] !=
        null) {
      if (Get.find<TasksController>().stringTasksKeys.contains(date)) {
        int count = 0;
        tasksLen =
            Get.find<TasksController>().tasks[date]["Tasks Titles"].length;

        int indexOfDay =
            Get.find<TasksController>().stringTasksKeys.indexOf(date);
        if (tasksLen > 0) {
          for (int i = 0;
              i < Get.find<TasksController>().tasksTitle[indexOfDay].length;
              i++) {
            if (count > 2) {
              count = 0;
            }
            hoursAndTimeList.add(DayHours(
              hour: Get.find<TasksController>().tasksTimesStart[indexOfDay][i],
              endHour: Get.find<TasksController>().tasksTimesEnd[indexOfDay][i],
              color: Get.find<TasksController>().tasksColors[count],
              title: Get.find<TasksController>().tasksTitle[indexOfDay][i],
              desc: Get.find<TasksController>().tasksDesc[indexOfDay][i],
            ));
            count = count + 1;
          }
        }
      } else {
        tasksLen = 0;
      }
    } else {
      return [Center(child: CustText(text: "No Pending Tasks", fontSize: 20))];
    }
    return tasksLen < 1
        ? [Center(child: CustText(text: "No Tasks Today", fontSize: 20))]
        : hoursAndTimeList;
  }

  //
//
  Map<dynamic, dynamic> milestonesMap = {}.obs();
  RxList<String> mileStonesString = [""].obs;
  Map<dynamic, dynamic> mileStonePerTitle = {}.obs();
  String trackMilestone = "".obs();
  RxBool addMilestoneTapped = false.obs;
  //
  //
  RxMap tasksProgress = RxMap();
  bool returnTasksProgress(String date, String title, int i) {
    return Get.find<TasksController>().tasksProgress[date]
        ? Get.find<TasksController>().tasksProgress[date][title][i]
        : false;
  }

  Map<dynamic, dynamic> progressPerTitle = {}.obs();
}
