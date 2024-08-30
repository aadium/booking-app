// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, library_private_types_in_public_api

import 'dart:convert';

import 'package:booking_app/functions/sign_functions.dart';
import 'package:booking_app/pages/admin/admin_home_screen.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
import 'package:booking_app/widgets/textboxes/password_box.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:booking_app/widgets/textbuttons/secondary_text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../home_screen.dart';
import '../widgets/textboxes/text_box_wcontroller_numeric.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SignFunctions signFunctions = SignFunctions();
  final auth = FirebaseAuth.instance;
  bool _isLoading = false;
  dynamic signInResult;

  Future<void> sendRegisterRequest(villaNumController, nameController,
      phoneNumberController, emailController) async {
    if (villaNumController.text.isEmpty ||
        nameController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        emailController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all the fields to proceed.'),
            actions: [
              PrimaryTextButton(
                text: 'OK',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    try {
      await signFunctions.registerRequest(villaNumController, nameController,
          phoneNumberController, emailController);
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Request Sent'),
            content: Text(
                'Your request has been sent. You will receive an email once your account is created.'),
            actions: [
              PrimaryTextButton(
                text: 'OK',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              PrimaryTextButton(
                text: 'OK',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30.0),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Welcome',
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
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 20.0),
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
                                _emailIdController.text,
                                _passwordController.text);
                            if (user != null) {
                              var jwt = await user.getIdToken();
                              var apiUserResponse = await http.get(
                                  Uri.parse(
                                      '${adminServerUrl}api/auth/getUser/${user.uid}'),
                                  headers: {'Authorization': 'Bearer $jwt'});
                              var userRole = jsonDecode(
                                  apiUserResponse.body)['customClaims']['role'];
                              if (userRole == 'admin') {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdminHomeScreen(
                                              pageIndex: 0,
                                            )));
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                              user: user,
                                              pageIndex: 0,
                                            )));
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
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController nameController =
                          TextEditingController();
                      TextEditingController villaNumController =
                          TextEditingController();
                      TextEditingController phoneNumberController =
                          TextEditingController();
                      TextEditingController emailController =
                          TextEditingController();
                      return AlertDialog(
                        title: Text('Enter your details'),
                        content: SingleChildScrollView(
                          child: IntrinsicHeight(
                            child: Column(
                              children: [
                                CustomNumericTextFieldWController(
                                  labelText: 'Enter villa number',
                                  controller: villaNumController,
                                ),
                                CustomTextFieldWController(
                                  labelText: 'Enter name',
                                  controller: nameController,
                                ),
                                CustomNumericTextFieldWController(
                                  labelText: 'Enter phone number',
                                  controller: phoneNumberController,
                                ),
                                CustomTextFieldWController(
                                  labelText: 'Enter email ID',
                                  controller: emailController,
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          PrimaryTextButton(
                            text: 'Send Request',
                            onPressed: () async {
                              sendRegisterRequest(
                                  villaNumController,
                                  nameController,
                                  phoneNumberController,
                                  emailController);
                            },
                          ),
                          SecondaryTextButton(
                            text: 'Cancel',
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'New user?',
                      style: TextStyle(
                        color: Color.fromRGBO(42, 54, 59, 1),
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      'Register here',
                      style: TextStyle(
                        color: Color.fromRGBO(42, 54, 59, 1),
                        fontSize: 17,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
