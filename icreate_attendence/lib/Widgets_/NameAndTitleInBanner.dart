import 'package:flutter/material.dart';
import 'package:icreate_attendence/Colors/Colors.dart';
import 'package:icreate_attendence/Screens/HomePage.dart';

import 'CustText.dart';

class NameAndTitleInBanner extends StatelessWidget {
  final String name;
  final String title;

  const NameAndTitleInBanner(
      {Key? key, required this.name, required this.title});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return SizedBox(
      height: screenSize.height / 9,
      width: screenSize.width / 2,
      child: Column(
        children: [
          SizedBox(
            height: screenSize.height / 40,
          ),
          CustText(
            text: name,
            fontSize: screenSize.width / 10,
          ),
          CustText(
            bold: false,
            text: title,
            fontSize: screenSize.width / 25,
            color: titleColor,
          ),
        ],
      ),
    );
  }
}
