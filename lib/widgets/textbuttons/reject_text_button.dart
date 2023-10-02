import 'package:flutter/material.dart';

class RejectTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const RejectTextButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: const ButtonStyle(
          foregroundColor: MaterialStatePropertyAll<Color>(Colors.red),
          overlayColor: MaterialStatePropertyAll<Color>(
              Color.fromRGBO(244, 67, 54, 0.11))),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
