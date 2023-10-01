// ignore_for_file: use_build_context_synchronously

import 'package:booking_app/functions/sign_functions.dart';
import 'package:booking_app/pages/homepage.dart';
import 'package:booking_app/widgets/textboxes/password_box.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller_numeric.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:flutter/material.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _villaNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  dynamic signInResult;
  dynamic signFunctions = SignFunctions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
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
                child: CustomNumericTextFieldWController(
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
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    signInResult = await signFunctions.signIn(
                        _villaNumberController,
                        _passwordController);
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
                            title: Text('Invalid Credentials'),
                            content: Text('The villa number or password is incorrect.'),
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
            ],
          ),
        ),
      ),
    );
  }
}
