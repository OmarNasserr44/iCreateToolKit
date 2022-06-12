import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/GetX%20Controllers/TasksController.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';

class NewTaskController extends GetxController {
  TasksController tasksController = Get.find<TasksController>();
  SignInUp signInUp = Get.find<SignInUp>();
  //
  //
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<String> usersList = [];
  List<String> usersNames = [""].obs;
  List<dynamic> usersIDs = [""].obs;

  RxString implementInUser = ""
      .obs; //to get the selected employee name in the dropdown menu in CreateNewTask screen
  //--
  int selectedUserIndex =
      0.obs(); //get the index of the selected employee to get his document ID
  //---
  String userDocument =
      "".obs(); //save the document ID to apply the change in the selected user

  Future<void> fieldDataQuery(String collection, QueryDocumentSnapshot doc,
      String fieldRequired1, String fieldRequired2) async {
    try {
      await firestore.collection(collection).doc(doc.id).get().then((value) {
        if (!value.exists) {
          log("something went Wrong");
        }
        if (value.exists) {
          Map<String, dynamic>? data = value.data();
          if (Get.find<NewTaskController>().usersIDs[0] == "") {
            Get.find<NewTaskController>().usersIDs[0] =
                data?[fieldRequired1].toString();
          } else {
            Get.find<NewTaskController>()
                .usersIDs
                .add(data?[fieldRequired1].toString());
          }
          if (Get.find<NewTaskController>().usersNames[0] == "") {
            Get.find<NewTaskController>().usersNames[0] = data?[fieldRequired2];
          } else {
            Get.find<NewTaskController>().usersNames.add(data?[fieldRequired2]);
          }
        }
      });
    } on Exception catch (e) {
      log("FAILED $e");
    }
  }

  Future<void> getFieldDataQuery(
      String collection, String fieldRequired1, String fieldRequired2) async {
    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection(collection)
        .where(fieldRequired1, isGreaterThan: 0)
        .get();

    for (int i = 0; i < querySnap.size; i++) {
      QueryDocumentSnapshot doc = querySnap.docs[i];
      DocumentReference docRef = doc.reference;
      Get.find<NewTaskController>().usersList.add(docRef.id);

      await Get.find<NewTaskController>()
          .fieldDataQuery(collection, doc, fieldRequired1, fieldRequired2);
    }
  }

  //
  //
  void newTask() {
    bool titleExists = false;
    bool date =
        tasksController.stringTasksKeys.contains(tasksController.trackDate);
    int index = 0;
    if (date) {
      index =
          tasksController.stringTasksKeys.indexOf(tasksController.trackDate);
    } else {
      if (tasksController.stringTasksKeys[0] == "") {
        tasksController.stringTasksKeys[0] = tasksController.trackDate;
        if (Get.find<TasksController>().tasksTitle.isEmpty) {
          Get.find<TasksController>().tasksTitle.add([""]);
          Get.find<TasksController>().tasksDesc.add([""]);
          Get.find<TasksController>().tasksTimesStart.add([""]);
          Get.find<TasksController>().tasksTimesEnd.add([""]);
        }
      } else {
        tasksController.stringTasksKeys.add(tasksController.trackDate);
        index =
            tasksController.stringTasksKeys.indexOf(tasksController.trackDate);
        Get.find<TasksController>().tasksTitle.add([""]);
        Get.find<TasksController>().tasksDesc.add([""]);
        Get.find<TasksController>().tasksTimesStart.add([""]);
        Get.find<TasksController>().tasksTimesEnd.add([""]);
        // tasksController.updateOneTask(tasksController.trackDate);
      }
    }
    //
    //
    if (tasksController.tasksTitle[index][0] == "") {
      tasksController.tasksTitle[index][0] = tasksController.trackTitle;
    } else {
      if (!tasksController.tasks[tasksController.trackDate]["Tasks Titles"]
          .contains(tasksController.trackTitle)) {
        tasksController.tasksTitle[index].add(tasksController.trackTitle);
        titleExists = false;
      } else {
        titleExists = true;
      }
    }
    //
    if (tasksController.tasksDesc[index][0] == "") {
      tasksController.tasksDesc[index][0] = tasksController.trackDesc;
    } else {
      if (!titleExists) {
        tasksController.tasksDesc[index].add(tasksController.trackDesc);
      } else {
        tasksController.tasksDesc[index][tasksController
            .tasks[tasksController.trackDate]["Tasks Titles"]
            .indexOf(tasksController.trackTitle)] = tasksController.trackDesc;
      }
    }
    //
    if (tasksController.tasksDate[0] == "") {
      tasksController.tasksDate[0] = tasksController.trackDate;
    } else {
      tasksController.tasksDate.add(tasksController.trackDate);
    }
    //
    if (tasksController.tasksTimesStart[index][0] == "") {
      tasksController.tasksTimesStart[index][0] = tasksController.trackStart;
    } else {
      if (!titleExists) {
        tasksController.tasksTimesStart[index].add(tasksController.trackStart);
      } else {
        tasksController.tasksTimesStart[index][tasksController
            .tasks[tasksController.trackDate]["Tasks Titles"]
            .indexOf(tasksController.trackTitle)] = tasksController.trackStart;
      }
    }
    //
    if (tasksController.tasksTimesEnd[index][0] == "") {
      tasksController.tasksTimesEnd[index][0] = tasksController.trackEnd;
    } else {
      if (!titleExists) {
        tasksController.tasksTimesEnd[index].add(tasksController.trackEnd);
      } else {
        tasksController.tasksTimesEnd[index][tasksController
            .tasks[tasksController.trackDate]["Tasks Titles"]
            .indexOf(tasksController.trackTitle)] = tasksController.trackEnd;
      }
    }
    //
    //Assign every milestone to the task title, then assign the title with its milestones
    //to the date
    //therefore if we have multiple tasks with the same name but in different days
    //there will be no conflict
    //but if a task with the same title exists in a specific day this task will be updated
    //with the new requirements
    //

    List<String> miles = [];
    log("len tasksController.mileStonesString.length");
    for (int i = 0; i < tasksController.mileStonesString.length; i++) {
      miles.add(tasksController.mileStonesString[i]);
    }
    Map<String, dynamic> milestonePerTitle = {};
    milestonePerTitle[tasksController.trackTitle] = miles;

    //
    if (tasksController.milestonesMap[tasksController.trackDate] == null) {
      tasksController.milestonesMap[tasksController.trackDate] =
          milestonePerTitle;
    } else {
      tasksController.milestonesMap[tasksController.trackDate]
          [tasksController.trackTitle] = miles;
    }
    //
    //Assign a bool for every milestone so we can track the progress of tasks
    //has the same structure as the milestoneMap
    //{date:{title:[bool,bool,..]},date2:{title:...}}
    //taskProgress[date][title][task index] to get bool of a specific task
    //
    List<bool> progress = [];
    for (int i = 0; i < tasksController.mileStonesString.length; i++) {
      progress.add(false);
    }
    Map<String, dynamic> progressPerTitle = {};
    progressPerTitle[tasksController.trackTitle] = progress;

    if (tasksController.tasksProgress[tasksController.trackDate] == null) {
      tasksController.tasksProgress[tasksController.trackDate] =
          progressPerTitle;
    } else {
      tasksController.tasksProgress[tasksController.trackDate]
          [tasksController.trackTitle] = progress;
    }
  }
  //
  //

  Map<dynamic, dynamic> employeeTasks = {}.obs();
  List<dynamic> employeeKeys = [].obs();

  Future<void> getEmployeeTask(String docID) async {
    try {
      await firestore.collection("Tasks").doc(docID).get().then((value) {
        if (!value.exists) {
          log("something went Wrong");
        }
        if (value.exists) {
          Map<String, dynamic>? data = value.data();
          Get.find<NewTaskController>().employeeTasks = data?['Tasks'];
          Get.find<NewTaskController>().employeeKeys =
              Get.find<NewTaskController>().employeeTasks.keys.toList();
          log("employeeTasks ${Get.find<NewTaskController>().employeeTasks}");
          log("employeeTasksKeys ${Get.find<NewTaskController>().employeeKeys}");
        }
      });
    } on Exception catch (e) {
      log("get employee task failed $e");
    }
  }

  Future<void> updateEmployeeTasks(String userID) async {
    try {
      await firestore.collection("Tasks").doc(userID).update({
        "Tasks": Get.find<NewTaskController>().employeeTasks,
      }).then((value) => log("Employee Tasks Recorded successfully"));
    } on Exception catch (e) {
      log('ERROR IN INPUT DATA $e');
    }
  }

  void updateEmployeeData() {
    //
    if (!Get.find<NewTaskController>()
        .employeeTasks
        .keys
        .contains(tasksController.trackDate)) {
      Get.find<NewTaskController>().employeeTasks[tasksController.trackDate] =
          {};
      Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
          ['Tasks Titles'] = [""];
      Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
          ['Tasks Description'] = [""];
      Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
          ['Tasks Start Times'] = [""];
      Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
          ['Tasks End Times'] = [""];
      Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
          ['Milestones'] = {};
      Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
          ['tasks progress'] = {};
    }

    tasksController.updateArray(
        Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
            ['Tasks Titles'],
        tasksController.trackTitle);
    //
    tasksController.updateArray(
        Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
            ['Tasks Description'],
        tasksController.trackDesc);
    //
    tasksController.updateArray(
        Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
            ['Tasks Start Times'],
        tasksController.trackStart);
    //
    tasksController.updateArray(
        Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
            ['Tasks End Times'],
        tasksController.trackEnd);
    //
    if (Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
            ['Milestones'] ==
        null) {
      Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
          ['Milestones'] = {};
      Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
              ['Milestones'][tasksController.trackTitle] =
          tasksController.mileStonesString.value;
    } else {
      Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
              ['Milestones'][tasksController.trackTitle] =
          tasksController.mileStonesString.value;
    }
    List<bool> employeeProgress = [];
    for (int i = 0; i < tasksController.mileStonesString.length; i++) {
      employeeProgress.add(false);
    }
    if (Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
            ['tasks progress'] ==
        null) {
      Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
          ['tasks progress'] = {};
      Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
          ['tasks progress'][tasksController.trackTitle] = employeeProgress;
    } else {
      Get.find<NewTaskController>().employeeTasks[tasksController.trackDate]
          ['tasks progress'][tasksController.trackTitle] = employeeProgress;
    }
  }
//
//
}
