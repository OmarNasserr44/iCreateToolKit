import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Colors/Colors.dart';

class CustText extends StatelessWidget {
  CustText(
      {required this.text,
      this.fontType = GoogleFonts.bebasNeue,
      required this.fontSize,
      this.bold = true,
      this.color = mainTextColor});

  final fontType;
  final String text;
  final double fontSize;
  final bool bold;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Text(
      text,
      style: fontType(
          textStyle: TextStyle(
              color: color,
              fontSize: fontSize,
              overflow: TextOverflow.ellipsis,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
    );
  }
}
