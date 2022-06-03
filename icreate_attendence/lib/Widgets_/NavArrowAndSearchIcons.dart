// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../Colors/Colors.dart';

class NavArrowAndSearchIcons extends StatelessWidget {
  final VoidCallback onTap;
  const NavArrowAndSearchIcons({required this.onTap});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width / 1.1,
      height: screenSize.height / 15,
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Icon(
              Icons.menu,
              size: screenSize.width / 12,
              color: iconsColor,
            ),
          ),
          SizedBox(
            width: screenSize.width / 1.4,
          ),
        ],
      ),
    );
  }
}
