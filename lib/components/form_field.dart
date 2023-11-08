
import 'package:flutter/material.dart';

Widget buildTextFormField(TextEditingController controller, String labelText) {
  return SizedBox(
    height: 45,
    width: double.infinity, // Takes the full width available
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    ),
  );
}
