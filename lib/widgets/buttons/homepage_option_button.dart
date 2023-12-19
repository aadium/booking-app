import 'package:flutter/material.dart';

class HomepageOptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const HomepageOptionButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 22),
        backgroundColor: Color.fromRGBO(42, 54, 59, 1),
        disabledBackgroundColor: Color.fromRGBO(77, 91, 97, 1),
        padding: const EdgeInsets.all(22.0),
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
