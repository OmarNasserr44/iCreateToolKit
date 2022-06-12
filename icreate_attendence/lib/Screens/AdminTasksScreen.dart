import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:icreate_attendence/GetX%20Controllers/AdminsController.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';

import '../Colors/Colors.dart';

class AdminTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: screenSize.height / 15,
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
              height: screenSize.height / 40,
            ),
            Center(
              child: SizedBox(
                height: screenSize.height / 15,
                width: screenSize.width / 1.1,
                child:
                    CustText(text: "All tasks", fontSize: screenSize.width / 9),
              ),
            ),
            SizedBox(
              height: screenSize.height / 1.3,
              width: screenSize.width / 1.1,
              child: Obx(
                () => ListView(
                  children: Get.find<AdminController>().adminCards.isNotEmpty
                      ? Get.find<AdminController>().adminCards
                      : [
                          Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              CustText(
                                  text: "No Active projects", fontSize: 20),
                            ],
                          )
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
