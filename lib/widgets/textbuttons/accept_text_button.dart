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
              Color.fromRGBO(76, 175, 79, 0.11))),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
