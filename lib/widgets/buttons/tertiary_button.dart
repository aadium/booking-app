import 'package:flutter/material.dart';

class TertiaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final child;

  const TertiaryButton({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        color: Color.fromRGBO(219, 226, 230, 1),
      ),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(left: 10, right: 10, top: 10), child: child),
          TextButton(
              onPressed: onPressed,
              child: Text('Click for more details',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromRGBO(42, 54, 59, 1))))
        ],
      ),
    );
  }
}
