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
        SizedBox(
            width: screenSize.width / 1.5,
            child: CustText(
              text: milestone,
              fontSize: screenSize.width / 17,
              mileStone: true,
            )),
        // SizedBox(),
        SizedBox(
          height: screenSize.height / 20,
        ),
      ],
    );
  }
}
