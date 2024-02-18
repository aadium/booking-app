// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, library_private_types_in_public_api

import 'package:booking_app/functions/sign_functions.dart';
import 'package:booking_app/pages/admin/admin_home_screen.dart';
import 'package:booking_app/pages/sign_in.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
import 'package:booking_app/widgets/buttons/secondary_button.dart';
import 'package:booking_app/widgets/textboxes/password_box.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminSignInPage extends StatefulWidget {
  const AdminSignInPage({super.key});

  @override
  _AdminSignInPageState createState() => _AdminSignInPageState();
}

class _AdminSignInPageState extends State<AdminSignInPage> {
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
              color: Color.fromRGBO(255, 216, 221, 1),
              borderRadius: BorderRadius.all(Radius.circular(30)),
              border: Border.fromBorderSide(
                  BorderSide(color: Color.fromRGBO(235, 74, 95, 1), width: 3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30.0),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Admin Sign In',
                    style: TextStyle(
                      fontSize: 40,
                      color: Color.fromRGBO(235, 74, 95, 1),
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
                    child: SecondaryButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        var user = await signFunctions.signIn(
                            _emailIdController.text, _passwordController.text);
                        var api_user_response = await http.get(Uri.parse(
                            'http://192.168.0.114:3001/api/auth/getUser/${user.uid}'));
                        var user_role =
                            jsonDecode(api_user_response.body)['customClaims']
                                ['role'];
                        if (user != null) {
                          if (user_role == 'admin') {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminHomeScreen(
                                          pageIndex: 0,
                                        )));
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
                                      onPressed: () {
                                        auth.signOut();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
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
                                    onPressed: () {
                                      auth.signOut();
                                      Navigator.of(context).pop();
                                    },
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
      bottomSheet: Container(
        height: 70,
        color: const Color.fromRGBO(235, 74, 95, 1),
        child: Center(
          child: GestureDetector(
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage())),
            child: Text(
              'Sign in as User',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      )
    );
  }
}
