// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/Colors/Colors.dart';
import 'package:icreate_attendence/GetX%20Controllers/AdminsController.dart';
import 'package:icreate_attendence/GetX%20Controllers/DoneHistory.dart';
import 'package:icreate_attendence/GetX%20Controllers/Push_Notification.dart';
import 'package:icreate_attendence/GetX%20Controllers/TasksController.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';
import 'package:icreate_attendence/Screens/AdminTasksScreen.dart';
import '../GetX Controllers/NewTaskController.dart';
import '../GetX Controllers/shared_preferences.dart';
import '../Requests/FirebaseRequests.dart';
import '../Widgets_/AdminRowCards.dart';
import '../Widgets_/AvatarAndProgressPercent.dart';
import '../Widgets_/Banner.dart';
import '../Widgets_/Card.dart';
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
  // PushNotification pushNotification = Get.find<PushNotification>();

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
    // if (signInUp.adminAcc) {
    //   pushNotification.getFCM().getToken().then((token) {
    //     FirebaseFirestore.instance
    //         .collection('tokens')
    //         .doc(Get.find<FirebaseRequests>().userDoc)
    //         .set({
    //       'token': token,
    //     });
    //   });
    // }
    tasksController.incInProgress();
    tasksController.incToDo();
    super.initState();
  }

  FirebaseRequests firebaseRequests = Get.find<FirebaseRequests>();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            MainBanner(
              home: true,
              height: 0,
              childWidget: Column(
                children: [
                  SizedBox(
                    height: screenSize.height / 25,
                  ),
                  SizedBox(
                    height: screenSize.height / 6,
                    width: screenSize.width / 1.2,
                    child: Row(
                      children: [
                        SizedBox(
                          height: screenSize.height / 6,
                          width: screenSize.width / 3,
                          child: AvatarAndProgressPercent(
                            imgPath: "Assets/Images/avatarPNG.png",
                          ),
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
                          width: screenSize.width / 1.1,
                          child: Row(
                            children: [
                              SizedBox(
                                height: screenSize.height / 30,
                                width: screenSize.width / 4.2,
                                child: CustText(
                                  text: "My Tasks",
                                  fontSize: screenSize.width / 14,
                                ),
                              ),
                              SizedBox(
                                width: screenSize.width / 5,
                                child: MaterialButton(
                                  onPressed: () async {
                                    await Get.find<
                                            SharedPreferencesController>()
                                        .checkInternet();
                                    signInUp.showAlertDialog(context);
                                    if (Get.find<SharedPreferencesController>()
                                        .hasInternet) {
                                      await firebaseRequests.currentUserData();
                                      await firebaseRequests.getDoneTasks();
                                      await Get.find<TasksController>()
                                          .getUserTasks();
                                      await Get.find<AdminController>()
                                          .getAdminTasks();
                                      await Get.find<DoneTasksHistory>()
                                          .getDoneHistory();

                                      if (signInUp.adminAcc.value) {
                                        Get.find<NewTaskController>()
                                            .usersNames = [""];
                                        Get.find<NewTaskController>()
                                            .getFieldDataQuery(
                                                "User Information",
                                                "ID",
                                                "Name");
                                      }
                                      Get.find<TasksController>()
                                              .cardsRow
                                              .value =
                                          await Get.find<TasksController>()
                                              .setCards();
                                      Get.find<TasksController>()
                                          .cardsRow
                                          .refresh();
                                      tasksController.incInProgress();
                                      tasksController.incToDo();
                                    }
                                    Navigator.pop(context);
                                  },
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.refresh,
                                    size: screenSize.width / 13,
                                    color: mainTextColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenSize.width / 20,
                              ),
                              Obx(
                                () => SizedBox(
                                  child: signInUp.adminAcc.value
                                      ? MaterialButton(
                                          onPressed: () {
                                            ///////
                                            Get.find<AdminController>()
                                                .updateAdminCards();
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdminTasks()));
                                          },
                                          padding: EdgeInsets.zero,
                                          color: Colors.grey[200],
                                          minWidth: screenSize.width / 3.3,
                                          child: CustText(
                                              text: "Admin Tasks",
                                              fontSize: screenSize.width / 14),
                                        )
                                      : Container(),
                                ),
                              )
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
