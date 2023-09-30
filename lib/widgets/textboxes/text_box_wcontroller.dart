import 'package:flutter/material.dart';

class CustomTextFieldWController extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  CustomTextFieldWController(
      {required this.controller, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: controller,
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
