import 'package:flutter/material.dart';

// A function that returns a customized TextField widget.
Widget inputStyle({
  IconData? prefixIcon, // Optional prefix icon for the text field.
  String? hintText, // Optional hint text for the text field.
  void Function(dynamic value)? onChanged, // Optional onChanged callback.
  required TextEditingController controller, // Required text controller for the text field.
}) {
  return TextField(
    onChanged: onChanged, // Assigns the onChanged callback, if provided.
    controller: controller, // Sets the controller for managing text input.
    decoration: InputDecoration(
      filled: true, // Enables the fill color for the text field.
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners for the text field.
        borderSide: BorderSide.none, // No border side, for a cleaner look.
      ),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null, // Adds a prefix icon if provided.
      hintText: hintText, // Displays hint text if provided.
    ),
  );
}
