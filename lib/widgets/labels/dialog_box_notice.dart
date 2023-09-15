import 'package:flutter/material.dart';

class DialogBoxNotice extends StatelessWidget {
  final String labelText;
  DialogBoxNotice({required this.labelText});

  @override
  Widget build(BuildContext context) {
    return Text(
      labelText,
      style: TextStyle(
        fontSize: 15,
        color: Color.fromRGBO(145, 0, 0, 1)
      )
    );
  }
}
