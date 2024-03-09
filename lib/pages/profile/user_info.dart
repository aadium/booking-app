// ignore_for_file: use_build_context_synchronously

import 'package:booking_app/firebase/authentication.dart';
import 'package:booking_app/functions/profile_functions.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  final int villaNumber;
  final List<dynamic> userDataList;

  const UserInfoPage({
    Key? key,
    required this.villaNumber,
    required this.userDataList,
  }) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final profileFunctions = ProfileFunctions();
  final Authentication authentication = Authentication();

  @override
  Widget build(BuildContext context) {
    const double fontSize = 17;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(42, 54, 59, 1),
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
                            color: Color.fromRGBO(219, 226, 230, 1),
                            borderRadius: BorderRadius.circular(17)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Table(
                                columnWidths: const {
                                  0: FixedColumnWidth(
                                      150),
                                  1: FixedColumnWidth(170),
                                },
                                children: [
                                  TableRow(children: [
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Container(
                                        height: 40,
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
                                      child: Container(
                                        height: 40,
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
                                      child: Container(
                                        height: 40,
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
                                      child: Container(
                                        height: 40,
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
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Container(
                                        height: 40,
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
                                      child: Container(
                                        height: 40,
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
            ],
          ),
        ),
      ),
    );
  }
}
