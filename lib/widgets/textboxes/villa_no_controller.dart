import 'package:flutter/material.dart';

class CustomVillaNoWController extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  CustomVillaNoWController({required this.controller, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: Color.fromRGBO(42, 54, 59, 1),
            width: 2,
          ),
        ),
        child: TextField(
          textAlign: TextAlign.center,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          style: const TextStyle(fontSize: 30),
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none,
            labelStyle: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
