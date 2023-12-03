import 'package:flutter/material.dart';

Widget inputStyle({
  IconData? prefixIcon,
  String? hintText, 
  void Function(dynamic value)? onChanged, // Make onChanged optional
  required TextEditingController controller, // Make controller required
}) {
  return TextField(
    onChanged: onChanged, // Assign onChanged callback if provided
    controller: controller, // Assign controller
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
