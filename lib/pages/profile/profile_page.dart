import 'package:booking_app/functions/profile_functions.dart';
import 'package:booking_app/functions/sign_functions.dart';
import 'package:booking_app/pages/profile/user_booking_history.dart';
import 'package:booking_app/pages/profile/user_info.dart';
import 'package:booking_app/pages/sign_in.dart';
import 'package:booking_app/widgets/buttons/primary_profile_menu_button.dart';
import 'package:booking_app/widgets/buttons/secondary_profile_menu_button.dart';
import 'package:booking_app/widgets/loaders/loader_1.dart';
import 'package:booking_app/widgets/textboxes/password_box.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:booking_app/widgets/textbuttons/secondary_text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final int villaNumber;
  final List<dynamic> userDataList;
  final User user;

  const ProfilePage({
    Key? key,
    required this.villaNumber,
    required this.userDataList,
    required this.user,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileFunctions = ProfileFunctions();
  final signFunctions = SignFunctions();
  String name = '';
  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _setUserProfile();
  }

  Future<void> _changePassword(currentPasswordController,newPasswordController,confirmPasswordController) async {
    if (newPasswordController.text ==
        confirmPasswordController.text) {
      User? user =
          FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        try {
          AuthCredential credential =
          EmailAuthProvider.credential(
            email: user.email!,
            password:
            currentPasswordController.text,
          );
          await user.reauthenticateWithCredential(
              credential);
          await signFunctions.changePassword(
              newPasswordController.text);
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text(
                    'Password changed successfully'),
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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(
                    'An error occured while changing passwords. Please try again later.'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Passwords do not match. Please try again.'),
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

  Future<void> _setUserProfile() async {
    List<String> userProfile =
        await profileFunctions.getCurrentUser(widget.villaNumber);
    setState(() {
      name = userProfile[0];
      phoneNumber = userProfile[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
      ),
      body: FutureBuilder<List<String>>(
          future: profileFunctions.getCurrentUser(widget.villaNumber),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Loader1());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading profile.'));
            } else if (snapshot.hasData) {
              final userProfile = snapshot.data!;
              final name = userProfile[0];
              final phoneNumber = userProfile[1];

              return ListView(
                children: <Widget>[
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                        "User: $name",
                        style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PrimaryProfileMenuButton(
                      text: 'View Profile',
                      icon: (FontAwesomeIcons.solidUser),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('View Profile'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: Icon(FontAwesomeIcons.solidUser),
                                    title: Text('Name: $name'),
                                  ),
                                  ListTile(
                                    leading: Icon(FontAwesomeIcons.phone),
                                    title: Text('Phone Number: $phoneNumber'),
                                  ),
                                  ListTile(
                                    leading: Icon(FontAwesomeIcons.solidEnvelope),
                                    title: Text('Email: ${widget.user.email}'),
                                  ),
                                  ListTile(
                                    leading: Icon(FontAwesomeIcons.house),
                                    title: Text('Villa Number: ${widget.villaNumber}'),
                                  ),
                                  ListTile(
                                    leading: Icon(FontAwesomeIcons.solidCalendar),
                                    title: Text('Joined: ${DateFormat('d MMMM yyyy').format(widget.user.metadata.creationTime!)}'),
                                  )
                                ],
                              ),
                              actions: [
                                SecondaryTextButton(
                                  text: 'Close',
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PrimaryProfileMenuButton(
                      text: 'Change Password',
                      icon: (FontAwesomeIcons.key),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            TextEditingController currentPasswordController =
                                TextEditingController();
                            TextEditingController newPasswordController =
                                TextEditingController();
                            TextEditingController confirmPasswordController =
                                TextEditingController();

                            return AlertDialog(
                              title: Text('Change Password'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomPasswordField(
                                    controller: currentPasswordController,
                                    labelText: 'Current Password',
                                  ),
                                  CustomPasswordField(
                                    controller: newPasswordController,
                                    labelText: 'New Password',
                                  ),
                                  CustomPasswordField(
                                    controller: confirmPasswordController,
                                    labelText: 'Confirm Password',
                                  ),
                                ],
                              ),
                              actions: [
                                PrimaryTextButton(
                                  text: ('Change Password'),
                                  onPressed: () async {
                                    _changePassword(currentPasswordController, newPasswordController, confirmPasswordController);
                                  },
                                ),
                                SecondaryTextButton(
                                  text: ('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: Color.fromRGBO(151, 169, 175, 1.0),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Villa Number: ${widget.villaNumber}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PrimaryProfileMenuButton(
                      text: 'Users',
                      icon: FontAwesomeIcons.userGroup,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserInfoPage(
                            villaNumber: widget.villaNumber,
                            userDataList: widget.userDataList,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PrimaryProfileMenuButton(
                      text: 'Booking History',
                      icon: FontAwesomeIcons.clockRotateLeft,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserBookingHistory(
                            villaNum: widget.villaNumber,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PrimaryProfileMenuButton(
                      text: 'Location',
                      icon: FontAwesomeIcons.locationDot,
                      onPressed: () => profileFunctions.showLocation(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: Color.fromRGBO(151, 169, 175, 1.0),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SecondaryPrimaryProfileMenuButton(
                      text: 'Sign Out',
                      onPressed: () => _showSignOutDialog(context),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No profile data available.'));
            }
          },
        ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            PrimaryTextButton(
              text: 'Yes',
              onPressed: () async {
                await signFunctions.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
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
    );
  }
}
