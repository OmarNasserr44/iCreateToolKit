// ignore_for_file: prefer_const_constructors

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreate_attendence/Colors/Colors.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';
import 'package:icreate_attendence/Widgets_/CustText.dart';
import 'package:icreate_attendence/Widgets_/IconInsideCircle.dart';

class CustTextField extends StatefulWidget {
  CustTextField({
    Key? key,
    required this.label,
    required this.hint,
    this.date = false,
    required this.onChanged,
    required this.onEditingComplete,
    required this.validator,
    this.validate = false,
    this.inputType = TextInputType.text,
    this.pass = false,
    this.maxLength = 20,
    this.mileStone = false,
  });

  final String label;
  final String hint;
  final bool date;
  final ValueChanged<String?>? onChanged;
  final VoidCallback onEditingComplete;
  final String validator;
  final bool validate;
  final TextInputType inputType;
  final bool pass;
  final int maxLength;
  final bool mileStone;

  @override
  State<CustTextField> createState() => _CustTextFieldState();
}

class _CustTextFieldState extends State<CustTextField> {
  SignInUp signInUp = Get.find<SignInUp>();

  final _text = TextEditingController();
  bool valid = false;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(
          height: screenSize.height / 11,
          width: widget.mileStone
              ? screenSize.width / 1.6
              : widget.date
                  ? screenSize.width / 1.3
                  : screenSize.width / 1.1,
          child: widget.date
              ? DateTimePicker(
                  type: DateTimePickerType.date,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2100),
                  dateLabelText: "Date",
                  style: TextStyle(
                      color: mainTextColor, fontWeight: FontWeight.bold),
                  timePickerEntryModeInput: false,
                  onChanged: widget.onChanged,
                )
              : TextFormField(
                  maxLength: widget.maxLength,
                  obscureText: widget.pass,
                  keyboardType: widget.inputType,
                  controller: _text,
                  decoration: InputDecoration(
                    errorText: widget.validate ? "${widget.validator}" : null,
                    hintText: widget.hint,
                    hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: screenSize.width / 25),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainTextColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    label: CustText(
                      text: widget.label,
                      fontSize: screenSize.width / 15,
                      bold: false,
                      color: Colors.grey,
                    ),
                  ),
                  onChanged: widget.onChanged,
                  onEditingComplete: widget.onEditingComplete,
                ),
        ),
        widget.date
            ? IconInsideCircle(
                newTask: true,
              )
            : Container(),
      ],
    );
  }
}
