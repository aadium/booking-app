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
          foregroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(42, 54, 59, 1),),
          overlayColor: MaterialStatePropertyAll<Color>(
              Color.fromRGBO(42, 54, 59, 0.11),)),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
