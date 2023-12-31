import 'package:flutter/material.dart';

class ViewBookingsDateButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  const ViewBookingsDateButton({
    required this.text,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: ContinuousRectangleBorder(),
        backgroundColor: Colors.white,
        side: BorderSide(width: 2, color: Color.fromRGBO(42, 54, 59, 1)),
        textStyle: const TextStyle(fontSize: 17, color: Color.fromRGBO(42, 54, 59, 1)),
        padding: const EdgeInsets.all(17.0),
        elevation: 0,
      ),
      onPressed:
          isLoading ? null : onPressed, // Disable button when isLoading is true
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isLoading)
            CircularProgressIndicator(
                color: Colors
                    .black) // Show CircularProgressIndicator when isLoading is true
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
