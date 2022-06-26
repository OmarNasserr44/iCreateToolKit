import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:icreate_attendence/GetX%20Controllers/NewTaskController.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';

import '../Colors/Colors.dart';
import '../GetX Controllers/TasksController.dart';
import 'IconInsideContainer.dart';

class IconAndTasks extends StatelessWidget {
  IconAndTasks({
    required this.tasksController,
    required this.mainText,
    required this.secText,
    required this.icons,
    required this.color,
  });

  final TasksController tasksController;
  final String mainText;
  final String secText;
  final IconData icons;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconInsideContainer(color: color, icon: icons),
          SizedBox(
            width: screenSize.width / 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustText(
                text: "$mainText",
                fontSize: screenSize.width / 18,
                bold: false,
              ),
              CustText(
                bold: false,
                text: "$secText",
                fontSize: screenSize.width / 25,
                color: titleColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
