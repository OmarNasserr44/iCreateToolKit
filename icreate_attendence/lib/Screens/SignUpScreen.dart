import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/Colors/Colors.dart';
import 'package:icreate_attendence/GetX%20Controllers/TasksController.dart';
import 'package:icreate_attendence/GetX%20Controllers/updateCheck.dart';
import 'package:icreate_attendence/Requests/FirebaseRequests.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';
import 'package:icreate_attendence/Screens/NavMainBar.dart';
import 'package:icreate_attendence/Widgets_/Button.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';
import 'package:icreate_attendence/Widgets_/CustTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GetX Controllers/AdminsController.dart';
import '../GetX Controllers/DoneHistory.dart';
import '../GetX Controllers/NewTaskController.dart';
import '../GetX Controllers/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignInUp signInUp = Get.find<SignInUp>();
  FirebaseRequests firebaseRequests = Get.find<FirebaseRequests>();
  final _auth = FirebaseAuth.instance;

  bool validate() {
    bool valid = false;
    if (signInUp.email == "") {
      setState(() {
        signInUp.validationError[0] = true;
        signInUp.validType[0] = false;
      });
    } else {
      setState(() {
        signInUp.validationError[0] = false;
      });
    }
    if (signInUp.name == "") {
      signInUp.validationError[1] = true;
    } else {
      signInUp.validationError[1] = false;
    }
    if (signInUp.title == "") {
      signInUp.validationError[4] = true;
    } else {
      signInUp.validationError[4] = false;
    }
    if (signInUp.phoneNo.length < 11) {
      signInUp.validationError[2] = true;
    } else {
      signInUp.validationError[2] = false;
    }
    if (signInUp.password.length < 8) {
      signInUp.validationError[3] = true;
    } else {
      signInUp.validationError[3] = false;
    }
    //
    //
    if (!signInUp.email.contains("@iCreate.vip")) {
      if (signInUp.email == "") {
        signInUp.validationError[0] = true;
        signInUp.validType[0] = false;
      } else {
        signInUp.validationError[0] = true;
        signInUp.validType[0] = true;
      }
    } else {
      signInUp.validationError[0] = false;
      signInUp.validType[0] = true;
    }
    if (signInUp.email.contains("@iCreate.vip")) {
      if (signInUp.email.length < 13) {
        signInUp.validationError[0] = true;
        signInUp.validType[0] = false;
      }
    }

    //
    //

    if (signInUp.validationError[0] ||
        !signInUp.email.contains("@iCreate.vip") ||
        signInUp.validationError[1] ||
        signInUp.validationError[2] ||
        signInUp.validationError[3]) {
      valid = true;
    } else {
      valid = false;
    }
    return valid;
  }

  @override
  void initState() {
    super.initState();
    signInUp.email = "";
    signInUp.name = "";
    signInUp.phoneNo = "";
    signInUp.password = "";
    signInUp.title = "";
    signInUp.validationError[0] = false;
    signInUp.validationError[1] = false;
    signInUp.validationError[2] = false;
    signInUp.validationError[3] = false;
    signInUp.validationError[4] = false;
  }

  dynamic onSignUpTimeOut() {
    Navigator.pop(context);

    return Get.find<SharedPreferencesController>().showAlertDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: screenSize.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenSize.height / 12,
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
                    width: screenSize.width / 1.1,
                    height: screenSize.height / 20,
                    child: CustText(
                        text: "Create an account",
                        fontSize: screenSize.width / 10),
                  ),
                  SizedBox(
                    height: screenSize.height / 20,
                  ),
                  SizedBox(
                    width: screenSize.width / 1.1,
                    child: CustTextField(
                      maxLength: 30,
                      validate: signInUp.validationError[0],
                      validator: signInUp.validType[0]
                          ? "E-mail must contain @iCreate.vip"
                          : "Invalid E-mail format",
                      label: "E-mail",
                      hint: "Enter your e-mail",
                      onChanged: (changed) {
                        signInUp.email = changed!;
                      },
                      onEditingComplete: () {},
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height / 100,
                  ),
                  SizedBox(
                    width: screenSize.width / 1.1,
                    child: CustTextField(
                      validate: signInUp.validationError[1],
                      validator: "Name can't be blank",
                      label: "Name",
                      hint: "Enter your Name",
                      onChanged: (changed) {
                        signInUp.name = changed!;
                      },
                      onEditingComplete: () {},
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height / 100,
                  ),
                  SizedBox(
                    width: screenSize.width / 1.1,
                    child: CustTextField(
                      validate: signInUp.validationError[4],
                      validator: "job title can't be blank",
                      label: "job Title",
                      hint: "Enter your job title",
                      onChanged: (changed) {
                        signInUp.title = changed!;
                      },
                      onEditingComplete: () {},
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height / 100,
                  ),
                  SizedBox(
                    width: screenSize.width / 1.1,
                    child: CustTextField(
                      maxLength: 15,
                      validate: signInUp.validationError[2],
                      validator: signInUp.validType[2]
                          ? "Phone number can't be blank"
                          : "Phone number can't be less than 15 digits",
                      label: "Phone Number",
                      hint: "Enter your phone number",
                      inputType: TextInputType.number,
                      onChanged: (changed) {
                        signInUp.phoneNo = changed!;
                      },
                      onEditingComplete: () {},
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height / 100,
                  ),
                  SizedBox(
                    width: screenSize.width / 1.1,
                    child: CustTextField(
                      pass: true,
                      validate: signInUp.validationError[3],
                      validator: "Password can't be less than 8 characters",
                      label: "Password",
                      hint: "Enter your Password",
                      inputType: TextInputType.visiblePassword,
                      onChanged: (changed) {
                        signInUp.password = changed!;
                      },
                      onEditingComplete: () {},
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height / 50,
                  ),
                  Container(
                    height: screenSize.height / 10,
                    width: screenSize.width / 1.2,
                    child: Column(
                      children: [
                        CustText(
                          text: "already have an account",
                          fontSize: screenSize.width / 25,
                          bold: false,
                          color: Colors.grey,
                        ),
                        MaterialButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: SizedBox(
                            height: screenSize.height / 20,
                            width: screenSize.width / 5,
                            child: Center(
                              child: CustText(
                                text: "Sign in",
                                fontSize: screenSize.width / 25,
                                bold: false,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height / 80,
                  ),
                  CustButton(
                      width: screenSize.width / 1.3,
                      text: "Sign up",
                      onTap: () async {
                        await Get.find<SharedPreferencesController>()
                            .checkInternet();
                        if (Get.find<SharedPreferencesController>()
                            .hasInternet) {
                          signInUp.showAlertDialog(context);
                          bool cont = validate();
                          if (!cont) {
                            try {
                              UserCredential newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: signInUp.email,
                                      password: signInUp.password);
                              Get.find<UpdateCheck>().currentStatus = "offline";
                              await firebaseRequests.generateID();
                              await firebaseRequests.updateIDs();
                              Get.find<TasksController>().tasks = {};
                              Get.find<UpdateCheck>().days = {};
                              await signInUp.inputData();
                              await firebaseRequests.currentUserData();
                              await firebaseRequests.getDoneTasks();
                              await Get.find<TasksController>().getUserTasks();
                              await Get.find<AdminController>().getAdminTasks();
                              await Get.find<DoneTasksHistory>()
                                  .getDoneHistory();
                              // SharedPreferences prefs =
                              //     await SharedPreferences.getInstance();
                              // String doneName = '${signInUp.name}Done';
                              // prefs.setInt(doneName, 0);
                              // prefs.setString('month',
                              //     Get.find<TasksController>().month.toString());
                              if (Get.find<SignInUp>().adminAcc.value) {
                                Get.find<AdminController>().getAdminTasks();
                                Get.find<NewTaskController>().usersNames = [""];
                                await Get.find<NewTaskController>()
                                    .getFieldDataQuery(
                                        "User Information", "ID", "Name");
                              }
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Get.to(() => NavMainBottom());
                            } on Exception catch (e) {
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: mainTextColor,
                                content: Text(
                                  "You already have an account\n Please go to Sign In Screen",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenSize.width / 20),
                                ),
                              ));
                            }
                          } else {
                            Get.back();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: mainTextColor,
                              content: Text(
                                "PLease enter the required attributes correctly",
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
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
