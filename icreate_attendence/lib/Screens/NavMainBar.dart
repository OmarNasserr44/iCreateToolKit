// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:icreate_attendence/Screens/Calender.dart';
import 'package:icreate_attendence/Screens/CreateNewTask.dart';
import 'package:icreate_attendence/Screens/HomePage.dart';
import 'package:icreate_attendence/Screens/Settings.dart';
import 'package:icreate_attendence/Screens/ProfileScreen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class NavMainBottom extends StatefulWidget {
  @override
  State<NavMainBottom> createState() => _NavMainBottomState();
}

class _NavMainBottomState extends State<NavMainBottom> {
  var _currentIndex = 2;
  List<Widget> screens = <Widget>[
    ProfileScreen(),
    Calender(),
    HomePage(),
    CreateNewTaskScreen(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: screens.elementAt(_currentIndex),
      ),
      bottomNavigationBar: SizedBox(
        height: screenSize.height / 17,
        child: SalomonBottomBar(
          itemPadding: EdgeInsets.all(5),
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            SalomonBottomBarItem(
              icon: SizedBox(
                  width: screenSize.width / 8, child: Icon(Icons.person)),
              title: Text("Profile"),
              selectedColor: Colors.blue[900],
            ),
            SalomonBottomBarItem(
              icon: SizedBox(
                  width: screenSize.width / 8,
                  child: Icon(Icons.calendar_today)),
              title: Text("Calender"),
              selectedColor: Colors.blue[900],
            ),
            SalomonBottomBarItem(
              icon: SizedBox(
                  width: screenSize.width / 8, child: Icon(Icons.home)),
              title: Text("Home"),
              selectedColor: Colors.blue[900],
            ),
            SalomonBottomBarItem(
              icon: SizedBox(
                  width: screenSize.width / 8,
                  child: Icon(Icons.add_to_photos_rounded)),
              title: Text("New Task"),
              selectedColor: Colors.blue[900],
            ),
            SalomonBottomBarItem(
              icon: SizedBox(
                  width: screenSize.width / 8, child: Icon(Icons.settings)),
              title: Text("Settings"),
              selectedColor: Colors.blue[900],
            ),
          ],
        ),
      ),
    );
  }
}
