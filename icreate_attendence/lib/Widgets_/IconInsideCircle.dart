import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/Screens/Calender.dart';
import 'package:icreate_attendence/Widgets_/IconInsideContainer.dart';

import '../Colors/Colors.dart';
import '../GetX Controllers/TasksController.dart';

class IconInsideCircle extends StatelessWidget {
  final bool newTask;
  TasksController tasksController = Get.find<TasksController>();

  IconInsideCircle({Key? key, required this.newTask}) : super(key: key);

  Widget datee() {
    return DateTimePicker(
      type: DateTimePickerType.date,
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
      dateLabelText: "Date",
      style: TextStyle(color: mainTextColor, fontWeight: FontWeight.bold),
      timePickerEntryModeInput: false,
      onChanged: (changed) {
        tasksController.tasksDate.add(changed);
        log("${tasksController.tasksDate}");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(32)),
      child: MaterialButton(
        onPressed: () {
          // log("Pressed");
          // datee();
        },
        minWidth: 0,
        height: 0,
        padding: EdgeInsets.zero,
        child: IconInsideContainer(
          color: Color(0xFF559193),
          icon: Icons.calendar_today,
        ),
      ),
    );
  }
}
