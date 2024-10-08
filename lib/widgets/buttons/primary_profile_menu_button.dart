import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrimaryProfileMenuButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final IconData icon;
  final VoidCallback onPressed;

  const PrimaryProfileMenuButton({
    required this.text,
    this.isLoading = false,
    required this.onPressed, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 20),
          backgroundColor: Color.fromRGBO(219, 226, 230, 1),
          padding: const EdgeInsets.all(16.0),
        ),
        onPressed: onPressed,
        child: Table(
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: FixedColumnWidth(20),
            2: IntrinsicColumnWidth(),
          },
          children: [
            TableRow(children: [
              TableCell(child: FaIcon(icon, color: Color.fromRGBO(42, 54, 59, 1),)),
              TableCell(child: SizedBox()),
              TableCell(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color.fromRGBO(42, 54, 59, 1)),
                ),
              )
            ]),
          ],
        ));
  }
}
