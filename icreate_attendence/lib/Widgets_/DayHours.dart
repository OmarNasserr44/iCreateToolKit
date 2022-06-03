// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';
import 'package:icreate_attendence/Widgets_/NameAndTitleInBanner.dart';

class DayHours extends StatelessWidget {
  final String hour;
  final String endHour;
  final Color color;
  final String title;
  final String desc;
  DayHours(
      {required this.hour,
      required this.endHour,
      required this.color,
      required this.title,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Row(
      children: [
        Container(
          width: screenSize.width / 12,
          height: screenSize.height / 8,
          child: Column(
            children: [
              Column(
                children: [
                  CustText(
                    text: hour,
                    fontSize: screenSize.width / 25,
                    bold: false,
                    color: Colors.grey,
                  ),
                  SizedBox(height: screenSize.height / 12.5),
                  CustText(
                    text: endHour,
                    fontSize: screenSize.width / 25,
                    bold: false,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: screenSize.height / 8,
          width: screenSize.width / 1.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: screenSize.height / 9,
                width: screenSize.width / 1.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenSize.width / 7),
                  color: color,
                ),
                child: SizedBox(
                  height: screenSize.height / 10,
                  width: screenSize.width / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustText(
                        text: title,
                        fontSize: screenSize.width / 15,
                      ),
                      SizedBox(
                        height: screenSize.height / 19,
                        width: screenSize.width / 1.8,
                        child: CustText(
                          bold: false,
                          text: desc,
                          fontSize: screenSize.width / 25,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// #d7e3fb
// #f7d4d4
