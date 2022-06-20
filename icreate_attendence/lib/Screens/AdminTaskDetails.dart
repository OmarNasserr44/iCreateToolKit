import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/GetX%20Controllers/AdminsController.dart';

import '../Colors/Colors.dart';
import '../GetX Controllers/shared_preferences.dart';
import '../Requests/SignInUpFirebase.dart';
import '../Widgets_/Button.dart';
import '../Widgets_/CustText.dart';

class AdminTaskDetails extends StatelessWidget {
  AdminTaskDetails(
      {required this.desc,
      required this.milestones,
      required this.date,
      required this.title,
      required this.name,
      this.fromDoneTasks = false});

  final String desc;
  final List<String> milestones;
  final String date;
  final String title;
  final String name;
  final bool fromDoneTasks;

  AdminController adminController = Get.find<AdminController>();

  List<Widget> milestoneList = [];
  List<Widget> milestoneFunc(Size screenSize) {
    milestoneList = [];
    for (int i = 0; i < milestones.length; i++) {
      //
      milestoneList.add(
        SizedBox(
          height: screenSize.height / 15,
          width: screenSize.width / 1.3,
          child: Row(
            children: [
              SizedBox(
                width: screenSize.width / 36,
              ),
              Checkbox(
                fillColor: MaterialStateProperty.all<Color>(Colors.blue),
                onChanged: (bool? value) {
                  fromDoneTasks
                      ? log("from Done Tasks")
                      : Get.find<AdminController>().adminTasks[name][date]
                          ['tasks progress'][title][i] = value;
                },
                value: fromDoneTasks
                    ? true
                    : Get.find<AdminController>().adminTasks[name][date]
                        ['tasks progress'][title][i],
              ),
              SizedBox(
                width: screenSize.width / 40,
              ),
              SizedBox(
                  width: screenSize.width / 1.5,
                  child: CustText(
                    text: milestones[i],
                    fontSize: screenSize.width / 18,
                    mileStone: true,
                    bold: false,
                  ))
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
                child: Row(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Get.back();
                      },
                      minWidth: screenSize.width / 18,
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: screenSize.width / 13,
                        color: mainTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.height / 20,
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
                height: screenSize.height / 15,
                width: screenSize.width / 1.1,
                child: CustText(
                  text: name,
                  fontSize: screenSize.width / 11,
                ),
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
                height: screenSize.height / 40,
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
            ],
          ),
        ),
      ),
    );
  }
}
