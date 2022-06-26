// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:icreate_attendence/Colors/Colors.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';

class DayAndNumber extends StatelessWidget {
  final String day;
  final String monthDay;
  final Color dayColor;
  final Color monthDayColor;

  // ignore: prefer_const_constructors_in_immutables
  DayAndNumber(
      {required this.day,
      required this.monthDay,
      this.dayColor = Colors.grey,
      this.monthDayColor = mainTextColor});
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(right: screenSize.width / 15),
      child: Column(
        children: [
          CustText(
            text: day,
            fontSize: screenSize.width / 20,
            bold: false,
            color: dayColor,
          ),
          CustText(
            text: monthDay,
            fontSize: screenSize.width / 35,
            bold: false,
            color: monthDayColor,
          ),
        ],
      ),
    );
  }
}
