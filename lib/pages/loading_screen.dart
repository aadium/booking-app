import 'package:booking_app/widgets/loaders/loader_2.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              child: Center(
                child: Loader2(),
              ),
            )
          ],
        ),
      ),
    );
  }
}