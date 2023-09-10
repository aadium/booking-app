import 'package:flutter/material.dart';

class CustomNumericTextFieldWController extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  CustomNumericTextFieldWController({required this.controller, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                },
      controller: controller,
      keyboardType: TextInputType.number,
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
