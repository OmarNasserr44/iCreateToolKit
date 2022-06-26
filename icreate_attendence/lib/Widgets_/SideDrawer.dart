// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 40.0,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        })),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'PROFILE',
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50.0,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'CALENDER',
                    style:
                        TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'HOME',
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50.0,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'NEW TASK',
                    style:
                        TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'SETTINGS',
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'LOG OUT',
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
