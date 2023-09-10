// ignore_for_file: use_build_context_synchronously

import 'package:booking_app/constants.dart';
import 'package:booking_app/homepage.dart';
import 'package:booking_app/widgets/textboxes/password_box.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _villaNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black87,
        title: const Center(child: Text('Sign In')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: CustomTextFieldWController(
                  controller: _villaNumberController,
                  labelText: 'Villa Number',
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: CustomPasswordField(
                  controller: _passwordController,
                ),
              ),
              const SizedBox(height: 16.0),
              FractionallySizedBox(
                widthFactor: 1,
                child: PrimaryButton(
                  onPressed: () => _signIn(context),
                  text: 'Sign In',
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signIn(BuildContext context) async {
    int villaNumber = int.tryParse(_villaNumberController.text.trim()) ?? 0;
    String password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      // Query Firestore to check if the villa number and password combination exists in "villa_users"
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection(firestoreVillaUsersCollection)
          .where('Villa_num', isEqualTo: villaNumber)
          .where('Password', isEqualTo: password)
          .get();

      if (snapshot.docs.isNotEmpty) {
        List<dynamic> userMaps =
          snapshot.docs.first.data()['userMaps'];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      villa_num: villaNumber,
                      userData: userMaps,
                    )));
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Credentials'),
              content: Text('The villa number or password is incorrect.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      debugPrint('Error during sign-in: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
