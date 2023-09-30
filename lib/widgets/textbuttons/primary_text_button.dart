import 'package:flutter/material.dart';

class PrimaryTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryTextButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: const ButtonStyle(
          foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
          overlayColor: MaterialStatePropertyAll<Color>(
              Color.fromARGB(255, 225, 225, 225))),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
