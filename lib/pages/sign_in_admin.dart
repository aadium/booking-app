// ignore_for_file: use_build_context_synchronously

import 'package:booking_app/functions/sign_functions.dart';
import 'package:booking_app/pages/homepage.dart';
import 'package:booking_app/pages/sign_in.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
import 'package:booking_app/widgets/textboxes/password_box.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller_numeric.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatefulWidget {
  const AdminSignInPage({super.key});

  @override
  _AdminSignInPageState createState() => _AdminSignInPageState();
}

class _AdminSignInPageState extends State<AdminSignInPage> {
  final TextEditingController _villaNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
              borderRadius: BorderRadius.all(Radius.circular(20)),
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
                    'Administrator\nSign In',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      color: Color.fromRGBO(42, 54, 59, 1),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomTextFieldWController(
                    controller: _villaNumberController,
                    labelText: 'Username',
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
                        signInResult = await signFunctions.signIn(
                            _villaNumberController, _passwordController);
                        if (signInResult[0] == 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage(
                                        villa_num: int.tryParse(
                                                _villaNumberController.text
                                                    .trim()) ??
                                            0,
                                        userData: signInResult[1],
                                      )));
                        } else if (signInResult[0] == 1) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Invalid Credentials'),
                                content: const Text(
                                    'The villa number or password is incorrect.'),
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
      bottomSheet: Container(
        height: 70,
        color: const Color.fromRGBO(42, 54, 59, 1),
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
    ),
    );
  }
}
