import 'package:flutter/material.dart';

class AcceptTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AcceptTextButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: const ButtonStyle(
          foregroundColor: MaterialStatePropertyAll<Color>(Colors.green),
          overlayColor: MaterialStatePropertyAll<Color>(
              Color.fromARGB(255, 201, 243, 203))),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
