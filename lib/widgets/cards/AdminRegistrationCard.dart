import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminRegistrationCard extends StatelessWidget {
  final int villaNum;
  final String name;
  final String email;
  final int phoneNumber;
  final DateTime createdAt;
  final void Function() onPressed;

  const AdminRegistrationCard({
    super.key,
    required this.villaNum,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const double fontSize = 17;

    return Center(
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(219, 226, 230, 1),
              borderRadius: BorderRadius.circular(17)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 5),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Table(
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
                            name,
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
                            phoneNumber.toString(),
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
                            email,
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
                            'Villa Number',
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
                            villaNum.toString(),
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
                            'Created At',
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
                            DateFormat('d MMMM yyyy, hh:mm').format(createdAt),
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
                PrimaryTextButton(
                  text: 'Add User',
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}