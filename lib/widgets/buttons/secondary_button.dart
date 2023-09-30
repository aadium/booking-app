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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
        backgroundColor: Colors.white,
        side: BorderSide(width: 2, color: Colors.black),
        textStyle: const TextStyle(fontSize: 17, color: Colors.black),
        disabledBackgroundColor: Colors.black12,
        padding: const EdgeInsets.all(17.0),
      ),
      onPressed:
          isLoading ? null : onPressed, // Disable button when isLoading is true
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isLoading)
            Center(
              child: SizedBox(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                    color: Colors
                        .black),
              ),
            )// Show CircularProgressIndicator when isLoading is true
          else
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
        ],
      ),
    );
  }
}
