import 'package:booking_app/functions/sign_functions.dart';
import 'package:booking_app/pages/sign_in.dart';
import 'package:booking_app/widgets/buttons/primary_profile_menu_button.dart';
import 'package:booking_app/widgets/buttons/secondary_profile_menu_button.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller.dart';
import 'package:booking_app/widgets/textboxes/password_box.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:booking_app/widgets/textbuttons/secondary_text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _currPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  SignFunctions signFunctions = SignFunctions();
  String email = '';
  String name = '';

  @override
  void initState() {
    super.initState();
    email = auth.currentUser!.email!;
    name = auth.currentUser?.displayName ?? 'Name not set';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Profile')),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 16),
                  Text(
                    email,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Divider(
              color: Color.fromRGBO(151, 169, 175, 1.0),
            ),
            SizedBox(height: 10),
            FractionallySizedBox(
              widthFactor: 0.95,
              child: PrimaryProfileMenuButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Change Name'),
                        content: CustomTextFieldWController(
                          controller: _nameController,
                          labelText: 'Enter new name',
                        ),
                        actions: <Widget>[
                          PrimaryTextButton(
                            onPressed: () async {
                              String newName = _nameController.text;
                              if (newName.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text('Name cannot be empty'),
                                      actions: [
                                        PrimaryTextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          text: 'OK',
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }
                              try {
                                User? user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  await user.updateDisplayName(newName);
                                  print('Display name updated successfully');
                                } else {
                                  print('User is not logged in');
                                }
                              } catch (e) {
                                print('Error updating display name: $e');
                              }
                              setState(() {
                                name = auth.currentUser?.displayName ??
                                    'Name not set';
                              });
                              Navigator.of(context).pop();
                            },
                            text: 'OK',
                          ),
                          SecondaryTextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            text: 'Cancel',
                          ),
                        ],
                      );
                    },
                  );
                },
                text: 'Change Name',
                icon: FontAwesomeIcons.a,
              ),
            ),
            SizedBox(height: 15),
            FractionallySizedBox(
              widthFactor: 0.95,
              child: PrimaryProfileMenuButton(
                  text: 'Change password',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String newPassword = '';
                        String currPassword = '';
                        return AlertDialog(
                          title: Text('Change Password'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomPasswordField(
                                  controller: _currPasswordController,
                                  labelText: 'Enter current password'),
                              CustomPasswordField(
                                controller: _newPasswordController,
                                labelText: 'Enter new password',
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            PrimaryTextButton(
                              onPressed: () async {
                                currPassword = _currPasswordController.text;
                                newPassword = _newPasswordController.text;
                                try {
                                  User? user =
                                      FirebaseAuth.instance.currentUser;
                                  AuthCredential credential =
                                      EmailAuthProvider.credential(
                                          email: email, password: currPassword);
                                  await user!
                                      .reauthenticateWithCredential(credential);
                                  await user.updatePassword(newPassword);
                                  print('Password updated successfully');
                                } catch (e) {
                                  print('Error updating password: $e');
                                }
                                Navigator.of(context).pop();
                              },
                              text: 'OK',
                            ),
                            SecondaryTextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              text: 'Cancel',
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: FontAwesomeIcons.lock),
            ),
            SizedBox(height: 20),
            FractionallySizedBox(
                widthFactor: 0.95,
                child: SecondaryPrimaryProfileMenuButton(
                    text: 'Sign Out',
                    onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Sign Out'),
                              content:
                                  Text('Are you sure you want to sign out?'),
                              actions: [
                                PrimaryTextButton(
                                  text: 'Yes',
                                  onPressed: () async {
                                    await signFunctions.signOut();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignInPage()),
                                      (route) => false,
                                    );
                                  },
                                ),
                                SecondaryTextButton(
                                  text: 'No',
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          },
                        ))),
          ],
        ),
      ),
    );
  }
}
