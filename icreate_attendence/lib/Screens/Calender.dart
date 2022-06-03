// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/GetX%20Controllers/TasksController.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';
import 'package:icreate_attendence/Widgets_/CalenderTitle.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';
import 'package:icreate_attendence/Widgets_/Week.dart';

class Calender extends StatelessWidget {
  TasksController tasksController = Get.find<TasksController>();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Column(
            children: [
              SizedBox(height: screenSize.height / 30),
              CalenderTitle(tasksController: tasksController),
              SizedBox(height: screenSize.height / 30),
              SizedBox(
                  width: screenSize.width / 1.1,
                  child: CustText(
                      text:
                          "${tasksController.months[tasksController.month - 1]}, ${tasksController.year}",
                      fontSize: screenSize.width / 15)),
              SizedBox(height: screenSize.height / 40),
              Week(),
              SizedBox(
                height: screenSize.height / 80,
              ),
              SizedBox(
                height: screenSize.height / 1.6,
                width: screenSize.width / 1.1,
                // color: Colors.red,
                child: ListView(
                  children: tasksController
                      .setAllDayHours(Get.find<SignInUp>().todayDate)
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
