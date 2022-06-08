import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/Colors/Colors.dart';
import 'package:icreate_attendence/GetX%20Controllers/TasksController.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AvatarAndProgressPercent extends StatelessWidget {
  AvatarAndProgressPercent({
    required this.imgPath,
  });
  TasksController tasksController = TasksController();

  final String imgPath;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return SizedBox(
      height: screenSize.height / 7.5,
      width: screenSize.width / 3,
      child: Center(
        child: Obx(
          () => CircularPercentIndicator(
            radius: screenSize.width / 7.2,
            lineWidth: screenSize.width / 50,
            percent: Get.find<TasksController>().setPercent(),
            progressColor: progressColor,
            backgroundColor: progressBackgroundColor,
            circularStrokeCap: CircularStrokeCap.round,
            center: SizedBox(
                height: screenSize.height / 9.8,
                width: screenSize.width / 4.8,
                child: Image.asset(
                  imgPath,
                )),
          ),
        ),
      ),
    );
  }
}
