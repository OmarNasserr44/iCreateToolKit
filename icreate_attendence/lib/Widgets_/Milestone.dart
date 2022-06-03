import 'package:flutter/material.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';

class Milestone extends StatelessWidget {
  Milestone({required this.milestone});

  final String milestone;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Row(
      children: [
        Icon(
          Icons.check_box,
          size: screenSize.width / 10,
          color: Colors.blue,
        ),
        SizedBox(
          width: screenSize.width / 20,
        ),
        CustText(text: milestone, fontSize: screenSize.width / 15),
        // SizedBox(),
        SizedBox(
          height: screenSize.height / 20,
        ),
      ],
    );
  }
}
