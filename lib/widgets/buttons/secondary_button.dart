import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  const SecondaryButton({
    required this.text,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.5)
        ),
        backgroundColor: Colors.white,
        side: BorderSide(
          width: 2,
          color: Colors.black87
        ),
        textStyle: const TextStyle(
          fontSize: 17, color: Colors.black87, fontWeight: FontWeight.bold
        ),
        disabledBackgroundColor: Colors.black12,
        disabledForegroundColor: Colors.black45,
        padding: const EdgeInsets.all(18.0),
      ),
      onPressed: isLoading ? null : onPressed, // Disable button when isLoading is true
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isLoading)
            CircularProgressIndicator(color: Colors.black87) // Show CircularProgressIndicator when isLoading is true
          else
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87),
            ),
        ],
      ),
    );
  }
}
