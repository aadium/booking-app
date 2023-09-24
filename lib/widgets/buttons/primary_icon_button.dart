import 'package:flutter/material.dart';

class PrimaryIconButton extends StatelessWidget {
  final IconData iconData;
  final bool isLoading;
  final VoidCallback onPressed;

  const PrimaryIconButton({
    required this.iconData,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 19),
        backgroundColor: Colors.black87,
        disabledBackgroundColor: Colors.black54,
        padding: const EdgeInsets.all(20.0),
      ),
      onPressed: isLoading ? null : onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isLoading)
            CircularProgressIndicator(color: Colors.white)
          else
            Icon(
              iconData,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}
