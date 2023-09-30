import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  const PrimaryButton({
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
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: Colors.black,
        disabledBackgroundColor: Colors.black54,
        padding: const EdgeInsets.all(20.0),
      ),
      onPressed:
          isLoading ? null : onPressed, // Disable button when isLoading is true
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isLoading)
            CircularProgressIndicator(
                color: Colors
                    .white) // Show CircularProgressIndicator when isLoading is true
          else
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
