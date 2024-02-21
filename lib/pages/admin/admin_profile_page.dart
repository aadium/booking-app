import 'package:booking_app/pages/sign_in_admin.dart';
import 'package:booking_app/widgets/buttons/primary_profile_menu_button.dart';
import 'package:booking_app/widgets/buttons/secondary_button.dart';
import 'package:booking_app/widgets/buttons/secondary_profile_menu_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String email = '';
  String name = '';

  @override
  void initState() {
    super.initState();
    email = auth.currentUser!.email!;
    name = auth.currentUser?.displayName ?? 'Name not defined';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Profile'),
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
                        String newName = '';
                        return AlertDialog(
                          title: Text('Change Name'),
                          content: TextField(
                            onChanged: (value) {
                              newName = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter new name',
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
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
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  text: 'Change Name',
                  icon: Icons.edit_attributes,
                ),
              ),
              SizedBox(height: 16),
              FractionallySizedBox(
                widthFactor: 0.95,
                child: PrimaryProfileMenuButton(
                  onPressed: () {},
                  text: 'Change password',
                  icon: Icons.lock,
                ),
              ),
              SizedBox(height: 16),
              FractionallySizedBox(
                widthFactor: 0.95,
                child: SecondaryPrimaryProfileMenuButton(
                  onPressed: () {
                    auth.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AdminSignInPage()),
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
