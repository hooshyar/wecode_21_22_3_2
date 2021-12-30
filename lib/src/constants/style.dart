import 'package:flutter/material.dart';

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
