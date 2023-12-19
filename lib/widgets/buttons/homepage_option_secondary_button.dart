import 'package:flutter/material.dart';

class HomepageOptionSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const HomepageOptionSecondaryButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: Color.fromRGBO(235, 74, 95, 1),
        disabledBackgroundColor: Color.fromRGBO(255, 116, 134, 1),
        padding: const EdgeInsets.all(20.0),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
