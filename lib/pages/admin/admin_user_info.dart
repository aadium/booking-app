// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:booking_app/constants/constants.dart';
import 'package:booking_app/firebase/authentication.dart';
import 'package:booking_app/functions/profile_functions.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller_numeric.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:booking_app/widgets/textbuttons/secondary_text_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminUserInfoPage extends StatefulWidget {
  final int villaNumber;
  final List<dynamic> userDataList;

  const AdminUserInfoPage({
    super.key,
    required this.villaNumber,
    required this.userDataList,
  });

  @override
  _AdminUserInfoPageState createState() => _AdminUserInfoPageState();
}

class _AdminUserInfoPageState extends State<AdminUserInfoPage> {
  final profileFunctions = ProfileFunctions();
  final Authentication authentication = Authentication();
  final double tablePadding = 0;
  void addUserDialog() {
    TextEditingController newNameController = TextEditingController();
    TextEditingController newPhoneNumberController = TextEditingController();
    TextEditingController newEmailController = TextEditingController();
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
                  CustomTextFieldWController(
                    labelText: 'Enter password',
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
                      newNameController,
                      newPhoneNumberController,
                      newEmailController,
                      widget.villaNumber);
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
                      'email': newEmailController.text.toString(),
                      'password': newPasswordController.text.toString(),
                    };
                    var jwt = await user?.getIdToken();
                    var response = await http.post(
                        Uri.parse('${adminServerUrl}api/auth/createUser'),
                        headers: {
                          "Content-Type": "application/json",
                          'Authorization': 'Bearer $jwt'
                        },
                        body: json.encode(body));
                    debugPrint(response.body);
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Success'),
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
                }),
            SecondaryTextButton(
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
          title: const Text('Remove User'),
          content: const Text('Are you sure you want to remove this user?'),
          actions: [
            PrimaryTextButton(
              text: 'Remove',
              onPressed: () async {
                Navigator.of(context).pop();
                var body = {
                  'email': widget.userDataList[index]['email'],
                };
                var jwt = await user?.getIdToken();
                var response = await http.delete(
                    Uri.parse('${adminServerUrl}api/auth/deleteUserByEmail/'),
                    headers: {
                      "Content-Type": "application/json",
                      'Authorization': 'Bearer $jwt'
                    },
                    body: json.encode(body));
                debugPrint(response.body);
                profileFunctions.removeUser(
                    widget.villaNumber, widget.userDataList, index);
              },
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
  Widget build(BuildContext context) {
    const double fontSize = 17;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(42, 54, 59, 1),
        title: const Text('Users'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (final userData in widget.userDataList)
                Column(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.95,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: const Color.fromRGBO(219, 226, 230, 1),
                            borderRadius: BorderRadius.circular(17)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Table(
                            columnWidths: const {
                              0: FixedColumnWidth(30),
                              1: FixedColumnWidth(100),
                              2: FixedColumnWidth(170),
                            },
                            children: [
                              TableRow(children: [
                                const TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text(''),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: const Text(
                                      'Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize,
                                          color: Color.fromRGBO(42, 54, 59, 1)),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: Text(
                                      userData['name'].toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: fontSize,
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: IconButton(
                                        onPressed: () => removeUserDialog(widget
                                            .userDataList
                                            .indexOf(userData)),
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          color: Color.fromRGBO(235, 74, 95, 1),
                                        ))),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: const Text(
                                      'Phone Number',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize,
                                          color: Color.fromRGBO(42, 54, 59, 1)),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: Text(
                                      userData['phoneNum'].toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: fontSize,
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                const TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Text(''),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: const Text(
                                      'Email',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize,
                                          color: Color.fromRGBO(42, 54, 59, 1)),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: Text(
                                      userData['email'].toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: fontSize,
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              const SizedBox(
                height: 15,
              ),
              FractionallySizedBox(
                widthFactor: 0.95,
                child: PrimaryButton(
                    text: 'Add User', onPressed: () => addUserDialog()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
