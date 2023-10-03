import 'package:flutter/material.dart';

class SecondaryIconButton extends StatelessWidget {
  final IconData iconData;
  final bool isLoading;
  final VoidCallback onPressed;

  const SecondaryIconButton({
    required this.iconData,
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
        textStyle: const TextStyle(fontSize: 19),
        backgroundColor: Color.fromRGBO(235, 74, 95, 1),
        disabledBackgroundColor: Color.fromRGBO(255, 116, 134, 1),
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
