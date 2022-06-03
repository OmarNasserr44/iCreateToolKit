import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/Colors/Colors.dart';

import '../GetX Controllers/shared_preferences.dart';

class CustButton extends StatelessWidget {
  CustButton({
    required this.text,
    required this.onTap,
    this.color = mainTextColor,
    required this.width,
  });

  final String text;
  final VoidCallback onTap;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height / 15,
      width: width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(32)),
      ),
      child: MaterialButton(
        onPressed: onTap,
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontSize: screenSize.width / 15,
              fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
