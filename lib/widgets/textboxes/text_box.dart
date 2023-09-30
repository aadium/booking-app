import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  CustomTextField({required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
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
