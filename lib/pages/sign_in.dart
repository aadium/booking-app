// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, library_private_types_in_public_api

import 'package:booking_app/functions/sign_functions.dart';
import 'package:booking_app/home_screen.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
import 'package:booking_app/widgets/textboxes/password_box.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool _isLoading = false;
  dynamic signInResult;
  dynamic signFunctions = SignFunctions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(219, 226, 230, 1),
              borderRadius: BorderRadius.all(Radius.circular(30)),
              border: Border.fromBorderSide(
                  BorderSide(color: Color.fromRGBO(42, 54, 59, 1), width: 3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30.0),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 50,
                      color: Color.fromRGBO(42, 54, 59, 1),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomTextFieldWController(
                    controller: _emailIdController,
                    labelText: 'Email I.D.',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomPasswordField(
                    controller: _passwordController,
                  ),
                ),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: PrimaryButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        var user = await signFunctions.signIn(
                            _emailIdController.text, _passwordController.text);
                        if (user != null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(user: user, pageIndex: 0,)));
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Invalid Credentials'),
                                content: Text(
                                    'The email address or password is incorrect.'),
                                actions: [
                                  PrimaryTextButton(
                                    text: 'OK',
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      text: 'Sign In',
                      isLoading: _isLoading,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
