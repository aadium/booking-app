import 'package:booking_app/pages/sign_in.dart';
import 'package:booking_app/widgets/buttons/primary_profile_menu_button.dart';
import 'package:booking_app/widgets/buttons/secondary_profile_menu_button.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 16),
              Text(
                email,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 30),
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
                                try {
                                  User? user =
                                      FirebaseAuth.instance.currentUser;
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
                              CustomTextFieldWController(
                                  controller: _currPasswordController,
                                  labelText: 'Enter current password'
                              ),
                              CustomTextFieldWController(
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
                                  await user!.reauthenticateWithCredential(
                                      credential);
                                  if (user != null) {
                                    await user.updatePassword(newPassword);
                                    print('Password updated successfully');
                                  } else {
                                    print('User is not logged in');
                                  }
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
                  icon: FontAwesomeIcons.lock
                ),
              ),
              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.95,
                child: SecondaryPrimaryProfileMenuButton(
                  onPressed: () {
                    auth.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignInPage()),
                      (route) => false,
                    );
                  },
                  text: 'Logout',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
