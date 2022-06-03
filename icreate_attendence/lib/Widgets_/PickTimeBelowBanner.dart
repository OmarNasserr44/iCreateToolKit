import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import '../Colors/Colors.dart';
import '../GetX Controllers/TasksController.dart';

class PickTimeBelowBanner extends StatelessWidget {
  const PickTimeBelowBanner({
    Key? key,
    required this.tasksController,
  }) : super(key: key);

  final TasksController tasksController;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return SizedBox(
        height: screenSize.height / 15,
        width: screenSize.width / 1.3,
        child: Row(
          children: [
            SizedBox(
              height: screenSize.height / 18,
              width: screenSize.width / 3,
              child: DateTimePicker(
                type: DateTimePickerType.time,
                timeLabelText: "Start Time",
                style: TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width / 25),
                timePickerEntryModeInput: false,
                onChanged: (changed) {
                  tasksController.trackStart = changed;
                  log(changed);
                },
              ),
            ),
            SizedBox(
              width: screenSize.width / 10,
            ),
            SizedBox(
              height: screenSize.height / 18,
              width: screenSize.width / 3,
              child: DateTimePicker(
                type: DateTimePickerType.time,
                timeLabelText: "End Time",
                style: TextStyle(
                    color: mainTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width / 25),
                timePickerEntryModeInput: false,
                onChanged: (changed) {
                  tasksController.trackEnd = changed;
                  log(changed);
                },
              ),
            ),
          ],
        ));
  }
}
