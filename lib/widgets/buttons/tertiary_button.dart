import 'package:flutter/material.dart';

class TertiaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final child;

  const TertiaryButton(
      {required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Color.fromRGBO(219, 226, 230, 1),
        textStyle: const TextStyle(fontSize: 17, color: Colors.black),
        padding: const EdgeInsets.all(17.0),
        elevation: 0
      ),
      onPressed: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [child],
      ),
    );
  }
}
