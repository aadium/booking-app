// ignore_for_file: use_build_context_synchronously

import 'package:booking_app/constants.dart';
import 'package:booking_app/functions/profile_functions.dart';
import 'package:booking_app/pages/profile/profile_statistics.dart';
import 'package:booking_app/widgets/buttons/secondary_button.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller_numeric.dart';
import 'package:booking_app/widgets/textbuttons/accept_text_button.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:booking_app/widgets/textbuttons/reject_text_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final User? user = FirebaseAuth.instance.currentUser;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  void addUserDialog() {
    TextEditingController newNameController = TextEditingController();
    TextEditingController newPhoneNumberController = TextEditingController();
    TextEditingController newEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add another user'),
          content: SingleChildScrollView(
            child: IntrinsicHeight(
              child: Column(
                children: [
                  CustomTextFieldWController(
                    labelText: 'Enter name',
                    controller: newNameController,
                  ),
                  CustomNumericTextFieldWController(
                    labelText: 'Enter phone number',
                    controller: newPhoneNumberController,
                  ),
                  CustomTextFieldWController(
                    labelText: 'Enter email ID',
                    controller: newEmailController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            AcceptTextButton(
                text: 'Add user',
                onPressed: () async {
                  var addUserResult = await profileFunctions.addUser(
                      newNameController,
                      newPhoneNumberController,
                      newEmailController, widget.villaNumber);
                  if (addUserResult[0] == 1) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Empty field'),
                          content:
                              Text('One or more of the required fields is empty'),
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
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Success'),
                          content: Text('${addUserResult[1]} had been added.'),
                          actions: [
                            PrimaryTextButton(
                              text: 'OK',
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        );
                      },
                    );
                    setState(() {
                      widget.userDataList.add(addUserResult[2]);
                    });
                  } else if (addUserResult[0] == 2) {
                    Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Failure to add user'),
                            content: Text('${addUserResult[1]} could not be added.'),
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
                }),
            RejectTextButton(
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void removeUserDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove User'),
          content: Text('Are you sure you want to remove this user?'),
          actions: [
            AcceptTextButton(
              text: 'Remove',
              onPressed: () async {
                Navigator.of(context).pop();
                await profileFunctions.removeUser(widget.villaNumber, widget.userDataList);
                setState(() {
                  widget.userDataList.removeAt(index);
                });
              },
            ),
            RejectTextButton(
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileStatsPage()),
                  );
                },
                icon: Icon(Icons.stacked_bar_chart)),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Villa Number:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.villaNumber.toString(),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'User Information:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            FractionallySizedBox(
              widthFactor: 0.95,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        12.0), // Set the border radius here
                    border: Border.all(
                      color: Colors.black12, // Border color
                      width: 2, // Border width
                    ),
                  ),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      0: IntrinsicColumnWidth(), // Adjusts width based on content
                      1: IntrinsicColumnWidth(),
                      2: IntrinsicColumnWidth(),
                      3: IntrinsicColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(8.0), // Add cell padding
                              child: Center(
                                child: Text(
                                  '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(8.0), // Add cell padding
                              child: Center(
                                child: Text(
                                  'Name',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(8.0), // Add cell padding
                              child: Center(
                                child: Text(
                                  'Phone Number',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(8.0), // Add cell padding
                              child: Center(
                                child: Text(
                                  'Email',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (final userData in widget.userDataList)
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    8.0), // Add cell padding
                                child: Center(
                                    child: IconButton(
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    color: widget.userDataList.length != 1
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    if (widget.userDataList.length != 1) {
                                      removeUserDialog(widget.userDataList
                                          .indexOf(userData));
                                    }
                                  },
                                )),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    8.0), // Add cell padding
                                child: Center(
                                  child: Text(
                                    userData['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    8.0), // Add cell padding
                                child: Center(
                                  child: Text(
                                    userData['phoneNum'].toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    8.0), // Add cell padding
                                child: Center(
                                  child: Text(
                                    userData['email'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: 0.95,
              child: SecondaryButton(
                  text: 'Add User', onPressed: () => addUserDialog()),
            ),
          ],
        ),
      ),
    );
  }
}
