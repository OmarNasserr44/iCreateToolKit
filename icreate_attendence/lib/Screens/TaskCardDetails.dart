// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/GetX%20Controllers/AdminsController.dart';
import 'package:icreate_attendence/GetX%20Controllers/TasksController.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';
import 'package:icreate_attendence/Widgets_/Button.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';

import '../Colors/Colors.dart';
import '../GetX Controllers/GoogleSheets.dart';
import '../GetX Controllers/shared_preferences.dart';
import '../GetX Controllers/updateCheck.dart';

class TaskCardDetails extends StatelessWidget {
  TaskCardDetails(
      {required this.desc,
      required this.milestones,
      required this.date,
      required this.title});

  final String desc;
  final List<String> milestones;
  final String date;
  final String title;
  TasksController tasksController = Get.find<TasksController>();

  List<Widget> milestoneList = [];
  List<List<bool>> milestoneCheck = [];
  List<Widget> milestoneFunc(Size screenSize) {
    milestoneList = [];
    milestoneCheck.add(tasksController.tasksProgress[date][title]);
    for (int i = 0; i < milestones.length; i++) {
      //
      milestoneList.add(
        SizedBox(
          height: screenSize.height / 20,
          width: screenSize.width / 1.3,
          child: Row(
            children: [
              SizedBox(
                width: screenSize.width / 36,
              ),
              Obx(
                () => Checkbox(
                  fillColor: MaterialStateProperty.all<Color>(Colors.blue),
                  onChanged: (bool? value) {
                    tasksController.tasksProgress[date][title][i] = value;
                    tasksController.tasksProgress.refresh();
                    if (Get.find<AdminController>().adminTasks.isNotEmpty) {
                      if (Get.find<AdminController>()
                          .adminTasks
                          .containsKey(Get.find<SignInUp>().name)) {
                        if (Get.find<AdminController>()
                            .adminTasks[Get.find<SignInUp>().name]
                            .containsKey(date)) {
                          if (Get.find<AdminController>()
                              .adminTasks[Get.find<SignInUp>().name][date]
                                  ['tasks progress']
                              .containsKey(title)) {
                            Get.find<AdminController>()
                                    .adminTasks[Get.find<SignInUp>().name][date]
                                ['tasks progress'][title][i] = value;
                          }
                        }
                      }
                    }
                  },
                  value: Get.find<TasksController>().tasksProgress[date] == null
                      ? false
                      : Get.find<TasksController>().tasksProgress[date][title]
                          [i],
                ),
              ),
              SizedBox(
                width: screenSize.width / 40,
              ),
              CustText(text: milestones[i], fontSize: screenSize.width / 15)
            ],
          ),
        ),
      );
    }
    return milestoneList;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: screenSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screenSize.height / 10,
                child: Row(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Get.back();
                      },
                      minWidth: screenSize.width / 18,
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: screenSize.width / 13,
                        color: mainTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.height / 20,
                width: screenSize.width / 1.1,
                child: CustText(
                  text: 'Task Details',
                  fontSize: screenSize.width / 10,
                ),
              ),
              SizedBox(
                height: screenSize.height / 20,
              ),
              SizedBox(
                height: screenSize.height / 22,
                width: screenSize.width / 1.1,
                child: CustText(
                  text: 'Description',
                  fontSize: screenSize.width / 13,
                ),
              ),
              SizedBox(
                height: screenSize.height / 5,
                width: screenSize.width / 1.1,
                child: Text(desc,
                    style: TextStyle(fontSize: screenSize.width / 15)),
              ),
              SizedBox(
                height: screenSize.height / 27,
                width: screenSize.width / 1.1,
                child: CustText(
                  text: 'Milestones',
                  fontSize: screenSize.width / 13,
                ),
              ),
              SizedBox(
                height: screenSize.height / 4,
                width: screenSize.width / 1.1,
                child: ListView(
                  children: milestoneFunc(screenSize),
                ),
              ),
              SizedBox(
                height: screenSize.height / 40,
              ),
              CustButton(
                  text: "Confirm Milestones",
                  onTap: () async {
                    await Get.find<SharedPreferencesController>()
                        .checkInternet();
                    if (Get.find<SharedPreferencesController>().hasInternet) {
                      Get.find<SignInUp>().showAlertDialog(context);
                      tasksController.updateCardsRow();
                      tasksController.setPercent();
                      await Get.find<TasksController>().createNewTask(date);
                      await Get.find<AdminController>().updateAdminTasks();
                      Navigator.pop(context);
                    } else {
                      Get.find<SharedPreferencesController>()
                          .showAlertDialog(context);
                    }
                  },
                  width: screenSize.width / 1.2),
              SizedBox(
                height: screenSize.height / 30,
              ),
              CustButton(
                  text: "Done",
                  onTap: () async {
                    String tempMile = "";
                    for (int i = 0; i < milestones.length; i++) {
                      tempMile = "$tempMile ${milestones[i]}";
                    }
                    Get.find<TasksController>()
                        .taskDone(date, title, context, screenSize);

                    ///
                    ///
                    if (Get.find<AdminController>().adminTasks.isNotEmpty) {
                      if (Get.find<AdminController>()
                          .adminTasks
                          .containsKey(Get.find<SignInUp>().name)) {
                        if (Get.find<AdminController>()
                            .adminTasks[Get.find<SignInUp>().name]
                            .containsKey(date)) {
                          if (Get.find<AdminController>()
                              .adminTasks[Get.find<SignInUp>().name][date]
                                  ['tasks progress']
                              .containsKey(title)) {
                            int index = Get.find<AdminController>()
                                .adminTasks[Get.find<SignInUp>().name][date]
                                    ['Tasks Titles']
                                .indexOf(title);
                            Get.find<AdminController>()
                                .adminTasks[Get.find<SignInUp>().name][date]
                                    ['Milestones']
                                .remove(title);
                            Get.find<AdminController>()
                                .adminTasks[Get.find<SignInUp>().name][date]
                                    ['tasks progress']
                                .remove(title);
                            Get.find<AdminController>()
                                .adminTasks[Get.find<SignInUp>().name][date]
                                    ['Tasks Description']
                                .removeAt(index);
                            Get.find<AdminController>()
                                .adminTasks[Get.find<SignInUp>().name][date]
                                    ['Tasks Titles']
                                .remove(title);
                            Get.find<AdminController>()
                                .adminTasks[Get.find<SignInUp>().name][date]
                                    ['Tasks Start Times']
                                .removeAt(index);
                            Get.find<AdminController>()
                                .adminTasks[Get.find<SignInUp>().name][date]
                                    ['Tasks End Times']
                                .removeAt(index);
                            log("lenn ${Get.find<AdminController>().adminTasks[Get.find<SignInUp>().name][date]['Milestones']}");
                            if (Get.find<AdminController>()
                                .adminTasks[Get.find<SignInUp>().name][date]
                                    ['Milestones']
                                .isEmpty) {
                              log("IS EMPTY");
                              Get.find<AdminController>()
                                  .adminTasks[Get.find<SignInUp>().name]
                                  .remove(date);
                            }
                            if (Get.find<AdminController>()
                                .adminTasks[Get.find<SignInUp>().name]
                                .isEmpty) {
                              Get.find<AdminController>()
                                  .adminTasks
                                  .remove(Get.find<SignInUp>().name);
                            }
                            log("ADMIN TASKS ${Get.find<AdminController>().adminTasks}");
                            Get.find<AdminController>().updateAdminCards();
                            Get.find<AdminController>().updateAdminTasks();
                          }
                        }
                      }
                    }

                    ///

                    ///
                    if (Get.find<TasksController>().publishTaskToGsheets) {
                      final user = {
                        "task assigned date": date.toString(),
                        "name": Get.find<SignInUp>().name.toString(),
                        "task's title": title.toString(),
                        "task's milestones": tempMile.toString(),
                        "task's done time":
                            Get.find<UpdateCheck>().currentTime.toString(),
                      };

                      await GoogleSheetsController.insertHistory([user]);
                    }
                  },
                  width: screenSize.width / 1.2)
            ],
          ),
        ),
      ),
    );
  }
}
