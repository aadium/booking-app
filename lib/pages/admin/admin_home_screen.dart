import 'package:booking_app/functions/sign_functions.dart';
import 'package:booking_app/pages/sign_in.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final signFunctions = SignFunctions();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Admin Home',
            ),
            PrimaryTextButton(
              onPressed: () async {
                await signFunctions.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SignInPage()),
                  (route) => false,
                );
              },
              text: ('Sign Out')
            )
          ],
        )
      ),
    );
  }
}