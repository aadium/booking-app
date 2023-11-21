// ignore_for_file: use_build_context_synchronously

import 'package:booking_app/functions/profile_functions.dart';
import 'package:booking_app/pages/profile/user_booking_history.dart';
import 'package:booking_app/pages/profile/user_info.dart';
import 'package:booking_app/pages/sign_in.dart';
import 'package:booking_app/widgets/buttons/primary_profile_menu_button.dart';
import 'package:booking_app/widgets/buttons/secondary_profile_menu_button.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:booking_app/widgets/textbuttons/secondary_text_button.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final int villaNumber;
  final List<dynamic> userDataList; // Pass a list of user data maps

  const ProfilePage({
    Key? key,
    required this.villaNumber,
    required this.userDataList,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileFunctions = ProfileFunctions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
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
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          const SizedBox(width: 10,),
                          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 27,))                          
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Villa Number:',
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
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(children: [
                  SizedBox(
                      height:
                          MediaQuery.of(context).copyWith().size.height / 7),
                  FractionallySizedBox(
                      widthFactor: 0.9,
                      child: PrimaryProfileMenuButton(
                          text: 'Users',
                          icon: (Icons.group),
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
                          icon: (Icons.history),
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
                          icon: Icons.location_pin,
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
                                        onPressed: () {
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
