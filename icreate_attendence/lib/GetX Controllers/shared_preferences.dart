import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';

class SharedPreferencesController extends GetxController {
  //
  String sharedEmail = "".obs();
  String sharedPassword = "".obs();

  //
  bool hasInternet = false.obs();

  _onTimeOut() {
    log("checked Internet done");
  }

  Future<void> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 3), onTimeout: _onTimeOut());
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Get.find<SharedPreferencesController>().hasInternet = true;
      }
    } on SocketException catch (_) {
      Get.find<SharedPreferencesController>().hasInternet = false;
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 10,
        child: Row(
          children: [
            Center(
                child: CustText(
                    text: "No Internet Access",
                    fontSize: MediaQuery.of(context).size.width / 10)),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
