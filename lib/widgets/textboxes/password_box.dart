import 'package:flutter/material.dart';

class CustomPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText = 'Password';
  CustomPasswordField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: labelText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        labelStyle: TextStyle(color: Colors.black),
      ),
    );
  }
}
