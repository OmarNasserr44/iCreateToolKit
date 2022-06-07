import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/Colors/Colors.dart';
import 'package:icreate_attendence/GetX%20Controllers/NewTaskController.dart';
import 'package:icreate_attendence/GetX%20Controllers/TasksController.dart';
import 'package:icreate_attendence/Requests/FirebaseRequests.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';
import 'package:icreate_attendence/Screens/NavMainBar.dart';
import 'package:icreate_attendence/Screens/SignUpScreen.dart';
import 'package:icreate_attendence/Widgets_/Button.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';
import 'package:icreate_attendence/Widgets_/CustTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GetX Controllers/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  SignInUp signInUp = Get.find<SignInUp>();
  FirebaseRequests firebaseRequests = Get.find<FirebaseRequests>();
  UserCredential? userCredential;

  bool validate() {
    bool valid = false;
    if (signInUp.email == "") {
      setState(() {
        signInUp.validationError[0] = true;
      });
    } else {
      setState(() {
        signInUp.validationError[0] = false;
        log("HERE1");
      });
    }

    if (signInUp.password == "") {
      signInUp.validationError[3] = true;
    } else {
      signInUp.validationError[3] = false;
      log("HERE2");
    }

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

    if (signInUp.validationError[0] || signInUp.validationError[3]) {
      log("HERE");
      valid = true;
    } else {
      valid = false;
    }
    log("$valid");
    return valid;
  }

  @override
  void initState() {
    super.initState();
    signInUp.email = "";
    signInUp.password = "";
    signInUp.validationError[0] = false;
    signInUp.validationError[3] = false;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: screenSize.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenSize.height / 4,
                ),
                SizedBox(
                  width: screenSize.width / 1.1,
                  height: screenSize.height / 20,
                  child:
                      CustText(text: "Sign In", fontSize: screenSize.width / 8),
                ),
                SizedBox(
                  height: screenSize.height / 20,
                ),
                SizedBox(
                  width: screenSize.width / 1.1,
                  child: CustTextField(
                    maxLength: 30,
                    validator: signInUp.validType[0]
                        ? "E-mail must contain @iCreate.vip"
                        : "Invalid E-mail format",
                    label: "E-mail",
                    hint: "Enter your e-mail",
                    validate: signInUp.validationError[0],
                    onChanged: (changed) {
                      signInUp.email = changed!;
                    },
                    onEditingComplete: () {},
                  ),
                ),
                SizedBox(
                  height: screenSize.height / 30,
                ),
                SizedBox(
                  width: screenSize.width / 1.1,
                  child: CustTextField(
                    maxLength: 20,
                    pass: true,
                    validate: signInUp.validationError[3],
                    validator: "Password can't be less than 8 characters",
                    label: "Password",
                    hint: "Enter your Password",
                    onChanged: (changed) {
                      signInUp.password = changed!;
                    },
                    onEditingComplete: () {},
                  ),
                ),
                SizedBox(
                  height: screenSize.height / 20,
                ),
                Container(
                  height: screenSize.height / 10,
                  width: screenSize.width / 1.2,
                  child: Column(
                    children: [
                      CustText(
                        text: "you don't have an account?",
                        fontSize: screenSize.width / 25,
                        bold: false,
                        color: Colors.grey,
                      ),
                      MaterialButton(
                        onPressed: () {
                          Get.to(() => SignUpScreen());
                        },
                        child: SizedBox(
                          height: screenSize.height / 20,
                          width: screenSize.width / 5,
                          child: Center(
                            child: CustText(
                              text: "Sign UP",
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
                  height: screenSize.height / 30,
                ),
                CustButton(
                  width: screenSize.width / 1.3,
                  text: "Sign In",
                  onTap: () async {
                    await Get.find<SharedPreferencesController>()
                        .checkInternet();
                    if (Get.find<SharedPreferencesController>().hasInternet) {
                      signInUp.showAlertDialog(context);
                      bool cont = validate();
                      if (!cont) {
                        try {
                          try {
                            userCredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: signInUp.email,
                              password: signInUp.password,
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              log('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              log('Wrong password provided for that user.');
                            }
                          }
                          if (userCredential != null) {
                            String emailTemp = signInUp.email;
                            String passTemp = signInUp.password;
                            await firebaseRequests.currentUserData();
                            await Get.find<TasksController>().getUserTasks();
                            if (signInUp.adminAcc) {
                              Get.find<NewTaskController>().getFieldDataQuery(
                                  "User Information", "ID", "Name");
                            }
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('email', emailTemp);
                            prefs.setString('password', passTemp);
                            log("preff ${prefs.get('password')}");
                            log("TASKS ${Get.find<TasksController>().tasks}");
                            Navigator.pop(context);
                            Navigator.pop(context);
                            // Get.find<ControllerGetX>().fromGuest = false;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NavMainBottom()));
                          } else {
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: mainTextColor,
                              content: Text(
                                "There is no registered account with this credentials\nPlease sign up first",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.width / 20),
                              ),
                            ));
                          }
                        } on Exception catch (e) {
                          log('Failed to Log In $e');
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
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
