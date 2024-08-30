import 'package:flutter/material.dart';

class AdminVillasCard extends StatelessWidget {
  final VoidCallback onPressed;
  final child;

  const AdminVillasCard({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(25),
          color: Color.fromRGBO(219, 226, 230, 1),
        ),
        child: Center(
          child: child
        ),
      ),
    );
  }
}
