import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final bool isActive;
  final VoidCallback onPressed;

  const DeleteButton({
    required this.text,
    required this.isActive,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 19),
        backgroundColor: Colors.red,
        disabledBackgroundColor: Colors.grey,
        padding: const EdgeInsets.all(20.0),
        elevation: 0,
      ),
      
      onPressed: isActive ? isLoading ? null : onPressed : null, // Disable button when isLoading is true
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isLoading)
            CircularProgressIndicator(color: Colors.white) // Show CircularProgressIndicator when isLoading is true
          else
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            ),
        ],
      ),
    );
  }
}
