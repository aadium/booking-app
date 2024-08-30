import 'dart:convert';

import 'package:booking_app/constants/constants.dart';
import 'package:booking_app/functions/email_functions.dart';
import 'package:booking_app/functions/profile_functions.dart';
import 'package:booking_app/widgets/cards/AdminRegistrationCard.dart';
import 'package:booking_app/widgets/loaders/loader_1.dart';
import 'package:booking_app/widgets/textboxes/password_box.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:booking_app/widgets/textbuttons/secondary_text_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminRegistrationRequestsPage extends StatefulWidget {
  const AdminRegistrationRequestsPage({super.key});

  @override
  State<AdminRegistrationRequestsPage> createState() => _AdminRegistrationRequestsPageState();
}

class _AdminRegistrationRequestsPageState extends State<AdminRegistrationRequestsPage> {
  List _registrationRequests = [];
  bool _isLoading = true;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ProfileFunctions profileFunctions = ProfileFunctions();
  EmailFunctions emailFunctions = EmailFunctions();
  User? user = FirebaseAuth.instance.currentUser;

  void _fetchRegistrationRequests() async {
    try {
      final registrationRequests = await firestore.collection(firestoreRegistrationRequestsCollection).get();
      setState(() {
        _registrationRequests = registrationRequests.docs;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void addUserDialog(data) {
    TextEditingController newPasswordController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add another user'),
          content: SingleChildScrollView(
            child: IntrinsicHeight(
              child: Column(
                children: [
                  CustomPasswordField(
                    labelText: "Enter the user's new password",
                    controller: newPasswordController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            PrimaryTextButton(
                text: 'Add user',
                onPressed: () async {
                  var addUserResult = await profileFunctions.addUser(
                      data['name'],
                      data['phone_number'].toString(),
                      data['email'],
                      data['villa_num'],
                  );
                  if (addUserResult[0] == 1) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Empty field'),
                          content: const Text(
                              'One or more of the required fields is empty'),
                          actions: [
                            PrimaryTextButton(
                              text: 'OK',
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (addUserResult[0] == 0) {
                    var body = {
                      'email': data['email'],
                      'password': newPasswordController.text.toString(),
                      'role': 'user'
                    };
                    var jwt = await user?.getIdToken();
                    await http.post(
                        Uri.parse('${adminServerUrl}api/auth/createUser'),
                        headers: {
                          "Content-Type": "application/json",
                          'Authorization': 'Bearer $jwt'
                        },
                        body: json.encode(body));
                    emailFunctions.sendAccountCreationEmail(
                        user!.email!,
                        user!.displayName!,
                        data['name'],
                        data['email'],
                        int.parse(data['phone_number'].toString()),
                        newPasswordController.text.toString());
                    Navigator.of(context).pop();
                    profileFunctions.deleteAcceptedRequest(data['name'], data['phone_number'].toString(), data['email'], data['villa_num']);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Success'),
                          content: Text('${addUserResult[1]} had been added.'),
                          actions: [
                            PrimaryTextButton(
                              text: 'OK',
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (addUserResult[0] == 2) {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Failure to add user'),
                          content:
                          Text('${addUserResult[1]} could not be added.'),
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
                }
              ),
            SecondaryTextButton(
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchRegistrationRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Requests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: _isLoading
              ? Center(child: Loader1())
              : _registrationRequests.isEmpty
                  ? const Center(child: Text('No registration requests'))
                  : Column(
                      children: _registrationRequests.map((request) {
                        final data = request.data() as Map<String, dynamic>;
                        return AdminRegistrationCard(
                          onPressed: () => addUserDialog(data),
                          villaNum: data['villa_num'],
                          name: data['name'],
                          email: data['email'],
                          phoneNumber: data['phone_number'],
                          createdAt: data['created_at'].toDate(),
                        );
                      }).toList(),
                    ),
        ),
      ),
    );
  }
}