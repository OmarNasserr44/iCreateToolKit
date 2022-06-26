// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../GetX Controllers/TasksController.dart';

class DraggableSheet extends StatelessWidget {
  TasksController tasksController = Get.find<TasksController>();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return DraggableScrollableSheet(
        initialChildSize: 0.42,
        maxChildSize: 0.9,
        minChildSize: 0.42,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            height: screenSize.height,
            width: screenSize.width,
            decoration: BoxDecoration(
                border: Border.all(color: (Colors.grey[200])!),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenSize.width / 10),
                  topRight: Radius.circular(screenSize.width / 10),
                )),
            child: ListView.builder(
                controller: scrollController,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Obx(
                    () => Column(
                      children: tasksController.cardsRow,
                    ),
                  );
                }),
          );
        });
  }
}
