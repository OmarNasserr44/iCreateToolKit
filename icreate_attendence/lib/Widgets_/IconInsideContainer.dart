import 'package:flutter/material.dart';

class IconInsideContainer extends StatelessWidget {
  IconInsideContainer({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height / 18,
      width: screenSize.width / 8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
