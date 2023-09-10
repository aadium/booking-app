import 'package:flutter/material.dart';

class NoWifiConnectionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No WiFi Connection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Please connect to WiFi to use this app.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // You can add logic to navigate to WiFi settings here
              },
              child: Text('Open WiFi Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
