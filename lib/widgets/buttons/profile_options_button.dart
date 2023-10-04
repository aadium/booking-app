import 'package:flutter/material.dart';

class ProfileOptionsButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  const ProfileOptionsButton({
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
        textStyle: const TextStyle(fontSize: 25),
        backgroundColor: Color.fromRGBO(219, 226, 230, 1),
        padding: const EdgeInsets.all(25.0),
      ),
      onPressed: onPressed,
      child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Color.fromRGBO(42, 54, 59, 1)),
            ),
    );
  }
}
