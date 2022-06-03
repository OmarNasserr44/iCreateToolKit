// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/GetX%20Controllers/TasksController.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';
import 'package:icreate_attendence/Widgets_/Button.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';

import '../GetX Controllers/shared_preferences.dart';

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
              ),
              SizedBox(
                height: screenSize.height / 25,
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
                  onTap: () {
                    log("${tasksController.tasksProgress[date][title][0]}");
                    Get.find<TasksController>()
                        .taskDone(date, title, context, screenSize);
                  },
                  width: screenSize.width / 1.2)
            ],
          ),
        ),
      ),
    );
  }
}
