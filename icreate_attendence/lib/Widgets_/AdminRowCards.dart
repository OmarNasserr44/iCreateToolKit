import 'package:flutter/material.dart';

class AdminRowCards extends StatelessWidget {
  final Widget card1;
  final Widget card2;
  final bool twoCards;

  AdminRowCards(
      {required this.card1, required this.card2, required this.twoCards});
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: screenSize.height / 4.5,
          width: screenSize.width / 1.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              card1,
              SizedBox(
                width: screenSize.width / 15,
              ),
              twoCards ? card2 : Container(),
            ],
          ),
        ),
        SizedBox(
          height: screenSize.height / 50,
        ),
      ],
    );
  }
}
