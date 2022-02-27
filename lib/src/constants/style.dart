import 'package:flutter/material.dart';

const Color mainColor = Color(0xFF119faa);
const Color secondColor = Color(0xFF297FBA);

InputDecoration generalInputDecoration(
    {required String labelText, String? hintText}) {
  return InputDecoration(
    label: Text(labelText),
    hintText: hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

class MyColor extends MaterialStateColor {
  static const int _defaultColor = 0xFF119faa;

  const MyColor() : super(_defaultColor);

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return Colors.white;
      //main color
    }
    return Colors.red;
    //second color
  }
}
