import 'package:flutter/material.dart';

class Loader2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: CircularProgressIndicator(
        color: Color.fromRGBO(42, 54, 59, 1),
        strokeWidth: 10,
        strokeCap: StrokeCap.round,
      ),
    );
  }
}