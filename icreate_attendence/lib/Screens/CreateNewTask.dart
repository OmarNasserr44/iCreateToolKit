// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/GetX%20Controllers/NewTaskController.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';
import 'package:icreate_attendence/Widgets_/Button.dart';
import 'package:icreate_attendence/Widgets_/CreateNewTaskBanner.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';
import 'package:icreate_attendence/Widgets_/CustTextField.dart';

import '../Colors/Colors.dart';
import '../GetX Controllers/TasksController.dart';
import '../GetX Controllers/shared_preferences.dart';
import '../Widgets_/Milestone.dart';
import '../Widgets_/PickTimeBelowBanner.dart';

class CreateNewTaskScreen extends StatelessWidget {
  TasksController tasksController = Get.find<TasksController>();
  SignInUp signInUp = Get.find<SignInUp>();
  NewTaskController newTaskController = Get.find<NewTaskController>();

  List<Widget> mileStones = [];
  List<Widget> setMileStones(Size screenSize) {
    mileStones = [];
    for (int i = 0; i < tasksController.mileStonesString.length; i++) {
      mileStones.add(Row(
        children: [
          Milestone(milestone: tasksController.mileStonesString[i]),
          GestureDetector(
            onTap: () {
              mileStones.remove(mileStones[i]);
              tasksController.mileStonesString
                  .remove(tasksController.mileStonesString[i]);
              tasksController.mileStonesString.refresh();
            },
            child: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ));
    }
    return mileStones.isEmpty
        ? [
            Center(
              child: CustText(
                text: "No milestones",
                fontSize: screenSize.width / 15,
              ),
            )
          ]
        : mileStones;
  }

  String trackMilestonesChanges = "";

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              NewTaskBanner(),
              SizedBox(
                height: screenSize.height / 40,
              ),
              PickTimeBelowBanner(tasksController: tasksController),
              SizedBox(height: screenSize.height / 50),
              SizedBox(
                height: screenSize.height / 40,
                width: screenSize.width / 1.2,
                child: CustText(
                  text: "Description",
                  fontSize: screenSize.width / 20,
                ),
              ),
              Container(
                height: screenSize.height / 6,
                width: screenSize.width / 1.1,
                color: Color(0xffeeeeee),
                padding: EdgeInsets.all(screenSize.width / 36),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    child: SizedBox(
                      height: screenSize.height / 7,
                      child: TextField(
                        maxLength: 100,
                        maxLines: 50,
                        onChanged: (changed) {
                          tasksController.trackDesc = changed;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Task Description',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.height / 40,
              ),
              signInUp.adminAcc
                  ? SizedBox(
                      height: screenSize.height / 15,
                      width: screenSize.width / 1.5,
                      child: Obx(
                        () => DropdownButton<String>(
                          hint: Get.find<NewTaskController>()
                                      .implementInUser
                                      .value ==
                                  ""
                              ? CustText(
                                  text: "Employees",
                                  fontSize: screenSize.width / 15)
                              : CustText(
                                  text: Get.find<NewTaskController>()
                                      .implementInUser
                                      .value,
                                  fontSize: screenSize.width / 15),
                          items: Get.find<NewTaskController>()
                              .usersNames
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: CustText(
                                fontSize: screenSize.width / 15,
                                text: value,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            Get.find<NewTaskController>()
                                .implementInUser
                                .value = value!;
                            Get.find<NewTaskController>()
                                .implementInUser
                                .refresh();
                            Get.find<NewTaskController>().selectedUserIndex =
                                Get.find<NewTaskController>()
                                    .usersNames
                                    .indexOf(Get.find<NewTaskController>()
                                        .implementInUser
                                        .value);
                            Get.find<NewTaskController>().userDocument =
                                Get.find<NewTaskController>().usersList[
                                    Get.find<NewTaskController>()
                                        .selectedUserIndex];
                          },
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: signInUp.adminAcc
                    ? screenSize.height / 40
                    : screenSize.height / 30,
              ),
              Container(
                height: screenSize.height / 10,
                width: screenSize.width / 1.1,
                child: Column(
                  children: [
                    Container(
                      height: screenSize.height / 10,
                      width: screenSize.width / 1.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustTextField(
                            hint: 'Enter Milestone',
                            mileStone: true,
                            validator: '',
                            onChanged: (String? value) {
                              tasksController.trackMilestone = value!;
                            },
                            onEditingComplete: () {},
                            label: 'Milestone',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              CustButton(
                  text: "Add Milestone",
                  onTap: () {
                    if (tasksController.trackMilestone == "") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: mainTextColor,
                        content: Text(
                          "Please add a Milestone first",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenSize.width / 20),
                        ),
                      ));
                    } else {
                      if (!tasksController.mileStonesString
                          .contains(tasksController.trackMilestone)) {
                        if (tasksController.mileStonesString.length == 0) {
                          tasksController.mileStonesString
                              .add(tasksController.trackMilestone);
                        } else if (tasksController.mileStonesString[0] == "") {
                          tasksController.mileStonesString[0] =
                              tasksController.trackMilestone;
                        } else {
                          tasksController.mileStonesString
                              .add(tasksController.trackMilestone);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: mainTextColor,
                          content: Text(
                            "This Milestone already exist",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenSize.width / 20),
                          ),
                        ));
                      }
                      tasksController.mileStonesString.refresh();

                      tasksController.addMilestoneTapped.value = true;
                    }
                    tasksController.addMilestoneTapped.refresh();
                    log("${tasksController.mileStonesString}");
                  },
                  width: screenSize.width / 1.5),
              SizedBox(
                height: screenSize.height / 50,
              ),
              Obx(
                () => Container(
                  height: screenSize.height / 7,
                  width: screenSize.width / 1.1,
                  child: !tasksController.addMilestoneTapped.value
                      ? Center(
                          child: CustText(
                            text: "No milestones",
                            fontSize: screenSize.width / 15,
                          ),
                        )
                      : SizedBox(
                          height: screenSize.height / 10,
                          width: screenSize.width / 1.1,
                          child: ListView(children: setMileStones(screenSize)),
                        ),
                ),
              ),
              SizedBox(height: screenSize.height / 25),
              CustButton(
                  text: "Create Task",
                  width: screenSize.width / 1.3,
                  onTap: () async {
                    await Get.find<SharedPreferencesController>()
                        .checkInternet();
                    if (Get.find<SharedPreferencesController>().hasInternet) {
                      if (tasksController.trackTitle.isNotEmpty &&
                          tasksController.trackDesc.isNotEmpty &&
                          tasksController.trackDate.isNotEmpty &&
                          tasksController.trackStart.isNotEmpty &&
                          tasksController.trackEnd.isNotEmpty &&
                          tasksController.addMilestoneTapped.value &&
                          tasksController.mileStonesString.isNotEmpty) {
                        //
                        signInUp.showAlertDialog(context);

                        if (Get.find<NewTaskController>().userDocument == "") {
                          Get.find<NewTaskController>().newTask();
                          await tasksController.createNewTask(
                              Get.find<TasksController>().trackDate);
                        } else {
                          await newTaskController
                              .getEmployeeTask(newTaskController.userDocument);
                          log("employee tasks ${newTaskController.employeeTasks}");
                          //
                          //function to insert new task in the employee tasks
                          newTaskController.updateEmployeeData();
                          //
                          //function to update the selected employee in firebase
                          newTaskController.updateEmployeeTasks(
                              newTaskController.userDocument);
                          newTaskController.implementInUser.value = "";
                          newTaskController.implementInUser.refresh();
                        }
                        //

                        //pass selected user doc, to apply the changes on the selected user file

                        tasksController.mileStonesString.clear();
                        log("SEE ${tasksController.mileStonesString}");
                        // tasksController.mileStonePerTitle = {};
                        // tasksController.progressPerTitle = {};
                        tasksController.mileStonesString.refresh();
                        tasksController.trackMilestone = "";

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: mainTextColor,
                          content: Text(
                            "Task was created successfully",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenSize.width / 20),
                          ),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: mainTextColor,
                          content: Text(
                            "Please fill all the required fields to create the task",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenSize.width / 20),
                          ),
                        ));
                      }
                    } else {
                      Get.find<SharedPreferencesController>()
                          .showAlertDialog(context);
                    }
                  }),
              SizedBox(
                height: screenSize.height / 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
