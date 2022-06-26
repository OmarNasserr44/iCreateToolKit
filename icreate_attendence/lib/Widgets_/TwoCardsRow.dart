import 'package:flutter/material.dart';
import 'package:icreate_attendence/Widgets_/Card.dart';

class TwoCardsRow extends StatelessWidget {
  const TwoCardsRow(
      {required this.mainText1,
      required this.mainText2,
      // required this.secText1,
      // required this.secText2,
      required this.color1,
      required this.color2,
      required this.percent1,
      required this.percent2,
      this.twoCards = true,
      required this.desc1,
      required this.desc2,
      required this.milestones1,
      required this.milestones2,
      required this.date1,
      required this.date2});

  final String mainText1;
  final String mainText2;
  // final String secText1;
  // final String secText2;
  final Color color1;
  final Color color2;
  final double percent1;
  final double percent2;
  final bool twoCards;
  final String desc1;
  final String desc2;
  final List<String> milestones1;
  final List<String> milestones2;
  final String date1;
  final String date2;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: screenSize.height / 4.5,
          width: screenSize.width / 1.1,
          child: Row(
            children: [
              CustCard(
                date: date1,
                mainText: mainText1,
                desc: desc1,
                milestones: milestones1,
                // secText: secText1,
                color: color1,
                percent: percent1,
              ),
              SizedBox(
                width: screenSize.width / 15,
              ),
              twoCards
                  ? CustCard(
                      date: date2,
                      milestones: milestones2,
                      mainText: mainText2,
                      desc: desc2,
                      // secText: secText2,
                      color: color2,
                      percent: percent2,
                    )
                  : Container(),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
        SizedBox(
          height: screenSize.height / 50,
        ),
      ],
    );
  }
}
