import 'package:flutter/material.dart';
import 'package:icreate_attendence/Colors/Colors.dart';

class MainBanner extends StatelessWidget {
  final Widget childWidget;
  final double height;
  final bool home;
  MainBanner(
      {Key? key,
      required this.childWidget,
      required this.height,
      this.home = true});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: home ? screenSize.height / 4.435 : height,
      width: screenSize.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: screenSize.width / 52,
            blurRadius: screenSize.width / 52,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        color: bannerColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(screenSize.width / 10),
          bottomRight: Radius.circular(screenSize.width / 10),
        ),
      ),
      child: childWidget,
    );
  }
}
