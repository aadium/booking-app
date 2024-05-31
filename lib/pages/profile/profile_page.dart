// ignore_for_file: use_build_context_synchronously

import 'package:booking_app/functions/profile_functions.dart';
import 'package:booking_app/functions/sign_functions.dart';
import 'package:booking_app/pages/profile/user_booking_history.dart';
import 'package:booking_app/pages/profile/user_info.dart';
import 'package:booking_app/pages/sign_in.dart';
import 'package:booking_app/widgets/buttons/primary_profile_menu_button.dart';
import 'package:booking_app/widgets/buttons/secondary_profile_menu_button.dart';
import 'package:booking_app/widgets/textboxes/password_box.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:booking_app/widgets/textbuttons/secondary_text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: 90,
        maxHeight: 200,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        panel: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 200,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.user.email.toString(),
                style: TextStyle(
                    fontSize: 30, color: Color.fromRGBO(42, 54, 59, 1)),
              ),
              const SizedBox(height: 30),
              FractionallySizedBox(
                  widthFactor: 0.9,
                  child: PrimaryProfileMenuButton(
                    text: 'Change Password',
                    icon: (Icons.change_circle_outlined),
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
                  )),
            ],
          ),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(80),
                          bottomRight: Radius.circular(80)),
                      color: Color.fromRGBO(42, 54, 59, 1)),
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      const Text(
                        'Villa Number',
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        widget.villaNumber.toString(),
                        style: const TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(children: [
                  SizedBox(
                      height:
                          MediaQuery.of(context).copyWith().size.height / 10),
                  FractionallySizedBox(
                      widthFactor: 0.9,
                      child: PrimaryProfileMenuButton(
                          text: 'Users',
                          icon: (FontAwesomeIcons.userGroup),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfoPage(
                                      villaNumber: widget.villaNumber,
                                      userDataList: widget.userDataList))))),
                  const SizedBox(height: 15),
                  FractionallySizedBox(
                      widthFactor: 0.9,
                      child: PrimaryProfileMenuButton(
                          text: 'Booking History',
                          icon: (FontAwesomeIcons.clockRotateLeft),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserBookingHistory(
                                      villaNum: widget.villaNumber))))),
                  const SizedBox(height: 15),
                  FractionallySizedBox(
                      widthFactor: 0.9,
                      child: PrimaryProfileMenuButton(
                          text: 'Location',
                          icon: (FontAwesomeIcons.locationDot),
                          onPressed: () => profileFunctions.showLocation())),
                  const SizedBox(height: 20),
                  FractionallySizedBox(
                      widthFactor: 0.9,
                      child: SecondaryPrimaryProfileMenuButton(
                          text: 'Sign Out',
                          onPressed: () => showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Sign Out'),
                                    content: Text(
                                        'Are you sure you want to sign out?'),
                                    actions: [
                                      PrimaryTextButton(
                                        text: 'Yes',
                                        onPressed: () async {
                                          await signFunctions.signOut();
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignInPage()),
                                            (route) => false,
                                          );
                                        },
                                      ),
                                      SecondaryTextButton(
                                        text: 'No',
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    ],
                                  );
                                },
                              ))),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
