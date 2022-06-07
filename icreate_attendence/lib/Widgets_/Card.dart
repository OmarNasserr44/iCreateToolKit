import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icreate_attendence/Screens/TaskCardDetails.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'CustText.dart';

class CustCard extends StatelessWidget {
  CustCard(
      {required this.mainText,
      // required this.secText,
      required this.color,
      required this.percent,
      required this.desc,
      required this.milestones,
      required this.date});

  final String mainText;
  final String desc;
  // final String secText;
  final Color color;
  final double percent;
  final List<String> milestones;
  final String date;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Get.to(() => TaskCardDetails(
              desc: desc,
              date: date,
              milestones: milestones,
              title: mainText,
            ));
      },
      child: Container(
        height: screenSize.height / 4,
        width: screenSize.width / 2.8,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 30,
              lineWidth: 5,
              percent: percent,
              progressColor: Colors.white,
              backgroundColor: Colors.transparent.withOpacity(0.05),
              center: Text(
                "${num.parse(percent.toStringAsFixed(2)) * 100}%",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: screenSize.height / 100,
            ),
            Container(
              height: screenSize.height / 22,
              width: screenSize.width / 3.5,
              // color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustText(
                    text: mainText,
                    fontSize: screenSize.width / 25,
                    color: Colors.white,
                    fontType: GoogleFonts.aBeeZee,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenSize.height / 90,
            ),
            CustText(
              text: date,
              fontSize: screenSize.width / 40,
              color: Colors.white,
              fontType: GoogleFonts.aBeeZee,
            )
          ],
        ),
      ),
    );
  }
}
