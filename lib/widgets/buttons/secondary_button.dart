import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  SecondaryButton(
      {required this.text, this.isLoading = false, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 15),
        backgroundColor: Colors.white70,
        disabledBackgroundColor: Colors.white54,
        padding: const EdgeInsets.all(15.0),
      ),
      onPressed: onPressed,
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.black87,)
          : Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.black87),
            ),
    );
  }
}
