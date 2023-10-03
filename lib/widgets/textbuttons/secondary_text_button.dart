import 'package:flutter/material.dart';

class SecondaryTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SecondaryTextButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: const ButtonStyle(
          foregroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(235, 74, 95, 1)),
          overlayColor: MaterialStatePropertyAll<Color>(
              Color.fromRGBO(235, 74, 95, 0.11))),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
