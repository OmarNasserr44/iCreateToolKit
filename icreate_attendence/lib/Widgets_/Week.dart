import 'dart:developer';
import 'package:icreate_attendence/Colors/Colors.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:icreate_attendence/Widgets_/DayAndNumber.dart';

class Week extends StatefulWidget {
  @override
  State<Week> createState() => _WeekState();
}

class _WeekState extends State<Week> {
  List<Widget> daysAndNumber = [];
  @override
  void initState() {
    setDayAndMonthDay();
    super.initState();
  }

  void setDayAndMonthDay() {
    var time = DateTime.now();
    Map days = {
      'Sunday': 'Sun',
      'Monday': 'Mon',
      'Tuesday': 'Tue',
      'Wednesday': 'Wed',
      'Thursday': 'Thu',
      'Friday': 'Fri',
      'Saturday': 'Sat'
    };
    List<String> d = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    List<String> d2 = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];

    // Map daysN = {
    //   'Sunday': 0,
    //   'Monday': 1,
    //   'Tuesday': 2,
    //   'Wednesday': 3,
    //   'Thursday': 4,
    //   'Friday': 5,
    //   'Saturday': 6,
    // };

    var day = DateFormat('EEEE').format(time);

    for (int i = 0; i < 7; i++) {
      if (day.toString() == d2[i]) {
        daysAndNumber.add(DayAndNumber(
          day: d[i],
          monthDay: '',
          dayColor: Colors.red,
        ));
      } else {
        daysAndNumber.add(DayAndNumber(day: d[i], monthDay: ''));
      }
    }

    //
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height / 19,
      width: screenSize.width / 1.1,
      child: Row(
        children: daysAndNumber
        // GestureDetector(
        //   onTap: () {
        //     setDayAndMonthDay();
        //   },
        //   child: Container(
        //     color: Colors.red,
        //     height: 20,
        //     width: 20,
        //   ),
        // )
        ,
      ),
    );
  }
}
