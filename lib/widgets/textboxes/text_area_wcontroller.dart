import 'package:flutter/material.dart';

class CustomTextAreaWController extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int maxLines;
  CustomTextAreaWController(
      {required this.controller, required this.labelText, required this.maxLines});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                },
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black87),
        ),
        labelStyle: TextStyle(color: Colors.black87),
      ),
    );
  }
}
