import 'package:flutter/material.dart';

Widget inputStyle({
  IconData? prefixIcon,
  String? hintText,
}) {
  return TextField(
    decoration: InputDecoration(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      prefixIcon: Icon(prefixIcon), 
      hintText: hintText,
    ),
  );
}
