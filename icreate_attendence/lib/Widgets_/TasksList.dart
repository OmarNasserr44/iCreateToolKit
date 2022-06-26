// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/GetX%20Controllers/AdminsController.dart';
import 'package:icreate_attendence/GetX%20Controllers/DoneHistory.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';
import 'package:icreate_attendence/Screens/DoneTasksScreen.dart';
import '../Colors/Colors.dart';
import '../GetX Controllers/TasksController.dart';
import 'IconAndTasks.dart';

class TasksList extends StatelessWidget {
  TasksList({
    required this.tasksController,
  });

  final TasksController tasksController;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height / 4.46,
      width: screenSize.width / 1.1,
      child: Column(
        children: [
          Obx(
            () => IconAndTasks(
              tasksController: tasksController,
              mainText: 'To Do',
              secText: '${tasksController.toDo} Tasks now',
              icons: Icons.alarm,
              color: progressColor,
            ),
          ),
          SizedBox(
            height: screenSize.height / 50,
          ),
          Obx(
            () => IconAndTasks(
              tasksController: tasksController,
              mainText: 'In Progress',
              secText: '${tasksController.inProgress} Tasks now',
              icons: Icons.pause_circle_filled,
              color: const Color(0xFFeec085),
            ),
          ),
          SizedBox(
            height: screenSize.height / 50,
          ),
          Obx(
            () => GestureDetector(
              onTap: () {
                if (Get.find<SignInUp>().adminAcc.value) {
                  Get.find<DoneTasksHistory>().updateDoneCards();
                  // Get.find<AdminController>().updateAdminCards();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DoneTasks()));
                }
              },
              child: IconAndTasks(
                tasksController: tasksController,
                mainText: 'Done',
                secText: '${tasksController.doneTasks} Tasks',
                icons: Icons.done,
                color: const Color(0xFF6e87dc),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
