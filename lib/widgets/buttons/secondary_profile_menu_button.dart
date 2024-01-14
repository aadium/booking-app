import 'package:flutter/material.dart';

class SecondaryPrimaryProfileMenuButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  const SecondaryPrimaryProfileMenuButton({
    required this.text,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
        textStyle: const TextStyle(fontSize: 21),
        backgroundColor: Color.fromRGBO(255, 216, 221, 1),
        padding: const EdgeInsets.all(23.0),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Color.fromRGBO(232, 74, 95, 1), fontSize: 25),
      ),
    );
  }
}
