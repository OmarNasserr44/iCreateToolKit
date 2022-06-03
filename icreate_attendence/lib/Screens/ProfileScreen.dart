// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unrelated_type_equality_checks

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/Colors/Colors.dart';
import 'package:icreate_attendence/GetX%20Controllers/TasksController.dart';
import 'package:icreate_attendence/Requests/FirebaseRequests.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';
import 'package:icreate_attendence/Widgets_/Banner.dart';
import '../Widgets_/AvatarAndProgressPercent.dart';
import '../Widgets_/NameAndTitleInBanner.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //
  //
  TasksController tasksController = Get.find<TasksController>();
  //
  SignInUp firebaseController = Get.find<SignInUp>();

  //
  FirebaseRequests firebaseRequests = Get.find<FirebaseRequests>();
  //
  int maxLen = 0;
  Color color1 = Colors.white;
  Color color2 = Colors.white;

  @override
  void initState() {
    maxLen = Get.find<TasksController>().stringTasksKeys.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          MainBanner(
            childWidget: Column(
              children: [
                SizedBox(
                  height: screenSize.height / 25,
                ),
                // NavArrowAndSearchIcons(
                //   onTap: () {
                //     _scaffoldKey.currentState?.openDrawer();
                //   },
                // ),
                SizedBox(
                  height: screenSize.height / 7,
                  width: screenSize.width / 1.2,
                  child: Row(
                    children: [
                      AvatarAndProgressPercent(
                        imgPath: "Assets/Images/avatarPNG.png",
                      ),
                      NameAndTitleInBanner(
                        title: firebaseController.title,
                        name: firebaseController.name,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            height: screenSize.height / 4,
            home: false,
          ),
          SizedBox(
            height: screenSize.height / 20,
          ),
          Container(
            height: screenSize.height / 15,
            width: screenSize.width / 1.3,
            decoration: BoxDecoration(
                color: mainTextColor, borderRadius: BorderRadius.circular(32)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenSize.width / 8,
                  child: Center(
                    child: MaterialButton(
                        onPressed: () {
                          if (tasksController.profileTasksIndex > 0) {
                            setState(() {
                              color2 = Colors.white;
                            });
                            tasksController.decTaskIndex();
                            tasksController.profileTasksIndex.refresh();
                          } else if (tasksController.profileTasksIndex == 0) {
                            setState(() {
                              color1 = Colors.grey;
                            });
                          }
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: color1,
                        )),
                  ),
                ),
                Container(
                    height: screenSize.height / 20,
                    width: screenSize.width / 2,
                    // color: Colors.green,
                    child: Center(
                      child: Obx(() => Text(
                            tasksController.stringTasksKeys[int.parse(
                                "${tasksController.profileTasksIndex}")],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenSize.width / 17),
                          )),
                    )),
                SizedBox(
                  width: screenSize.width / 8,
                  child: MaterialButton(
                      onPressed: () {
                        if (tasksController.profileTasksIndex < maxLen - 1) {
                          if (tasksController.profileTasksIndex > 0) {
                            setState(() {
                              color1 = Colors.white;
                            });
                          }
                          tasksController.incTaskIndex();
                          tasksController.profileTasksIndex.refresh();
                        } else if (tasksController.profileTasksIndex ==
                            maxLen - 1) {
                          setState(() {
                            color2 = Colors.grey;
                          });
                        }
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: color2,
                      )),
                )
              ],
            ),
          ),
          SizedBox(
            height: screenSize.height / 50,
          ),
          Container(
            height: screenSize.height / 1.96,
            width: screenSize.width / 1.1,
            child: Obx(
              () => ListView(
                children: tasksController.setAllDayHours(
                    tasksController.stringTasksKeys[
                        int.parse("${tasksController.profileTasksIndex}")]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
