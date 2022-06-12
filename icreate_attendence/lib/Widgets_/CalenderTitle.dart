import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:icreate_attendence/GetX%20Controllers/TasksController.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';

class CalenderTitle extends StatelessWidget {
  const CalenderTitle({
    required this.tasksController,
  });

  final TasksController tasksController;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SizedBox(
        height: screenSize.height / 13,
        width: screenSize.width / 1.1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustText(text: "Today", fontSize: screenSize.width / 10),
            Text(
              "${tasksController.productivity}, ${Get.find<SignInUp>().name}",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ));
  }
}
