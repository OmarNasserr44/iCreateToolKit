// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/GetX%20Controllers/Push_Notification.dart';
import 'package:icreate_attendence/GetX%20Controllers/TasksController.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';
import '../Requests/FirebaseRequests.dart';
import '../Widgets_/AvatarAndProgressPercent.dart';
import '../Widgets_/Banner.dart';
import '../Widgets_/CustText.dart';
import '../Widgets_/DraggableSheet.dart';
import '../Widgets_/NameAndTitleInBanner.dart';
import '../Widgets_/SideDrawer.dart';
import '../Widgets_/TasksList.dart';
import '../Widgets_/TwoCardsRow.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SignInUp signInUp = Get.find<SignInUp>();
  PushNotification pushNotification = Get.find<PushNotification>();

  TasksController tasksController = Get.find<TasksController>();

  @override
  void initState() {
    //
    () async {
      Get.find<TasksController>().cardsRow.value =
          await Get.find<TasksController>().setCards();
      Get.find<TasksController>().cardsRow.refresh();
    }();
    // tasksController.setPercent();
    if (signInUp.adminAcc) {
      pushNotification.getFCM().getToken().then((token) {
        FirebaseFirestore.instance
            .collection('tokens')
            .doc(Get.find<FirebaseRequests>().userDoc)
            .set({
          'token': token,
        });
      });
    }
    tasksController.incInProgress();
    tasksController.incToDo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            MainBanner(
              height: 0,
              childWidget: Column(
                children: [
                  SizedBox(
                    height: screenSize.height / 25,
                  ),
                  SizedBox(
                    height: screenSize.height / 7,
                    width: screenSize.width / 1.2,
                    child: Row(
                      children: [
                        AvatarAndProgressPercent(
                          imgPath: "Assets/Images/avatarPNG.png",
                        ),
                        NameAndTitleInBanner(
                          title: signInUp.title,
                          name: signInUp.name,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenSize.height / 45,
            ),
            SizedBox(
              height: screenSize.height / 1.545,
              width: screenSize.width,
              child: Stack(
                children: [
                  SizedBox(
                    height: screenSize.height / 2.5,
                    width: screenSize.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenSize.height / 14,
                          width: screenSize.width / 1.2,
                          child: Row(
                            children: [
                              CustText(
                                text: "My Tasks",
                                fontSize: screenSize.width / 14,
                              ),
                              SizedBox(
                                width: screenSize.width / 2.1,
                              ),
                              // IconInsideCircle(
                              //   newTask: false,
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenSize.height / 55,
                        ),
                        TasksList(tasksController: tasksController),
                        SizedBox(
                          height: screenSize.height / 40,
                        ),
                        SizedBox(
                          height: screenSize.height / 30,
                          width: screenSize.width / 1.2,
                          child: CustText(
                            text: "Active Projects",
                            fontSize: screenSize.width / 14,
                          ),
                        ),
                        SizedBox(
                          height: screenSize.height / 40,
                        ),
                      ],
                    ),
                  ),
                  DraggableSheet(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
