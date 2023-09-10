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
              Color.fromARGB(255, 236, 206, 204))),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
