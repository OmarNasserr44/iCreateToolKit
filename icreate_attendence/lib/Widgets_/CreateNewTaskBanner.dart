import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/Widgets_/Banner.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';
import 'package:icreate_attendence/Widgets_/CustTextField.dart';

import '../GetX Controllers/TasksController.dart';

class NewTaskBanner extends StatelessWidget {
  TasksController tasksController = Get.find<TasksController>();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return MainBanner(
      height: screenSize.height / 2.5,
      home: false,
      childWidget: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenSize.height / 20,
            ),
            SizedBox(
              width: screenSize.width / 1.1,
              height: screenSize.height / 20,
              child: CustText(
                  text: "Create New Task", fontSize: screenSize.width / 10),
            ),
            SizedBox(
              height: screenSize.height / 4,
              width: screenSize.width / 1.1,
              child: Column(
                children: [
                  SizedBox(
                    height: screenSize.height / 30,
                  ),
                  CustTextField(
                    label: 'Title',
                    hint: 'Enter Task Title',
                    validator: "Title",
                    onChanged: (changed) {
                      tasksController.trackTitle = changed!;
                    },
                    onEditingComplete: () {},
                  ),
                  SizedBox(
                    height: screenSize.height / 30,
                  ),
                  CustTextField(
                    validator: "Date",
                    label: 'Date',
                    hint: 'Enter Task Title',
                    date: true,
                    onChanged: (changed) {
                      tasksController.trackDate = changed!;
                      log(changed);
                    },
                    onEditingComplete: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
