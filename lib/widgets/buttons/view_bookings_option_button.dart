import 'package:flutter/material.dart';

class ViewBookingsOptionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final child;

  const ViewBookingsOptionButton({
    required this.onPressed,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        side: BorderSide(width: 2, color: Colors.black87),
        textStyle: const TextStyle(fontSize: 17, color: Colors.black87),
        disabledBackgroundColor: Colors.black12,
        padding: const EdgeInsets.all(17.0),
      ),
      onPressed: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          child
        ],
      ),
    );
  }
}
