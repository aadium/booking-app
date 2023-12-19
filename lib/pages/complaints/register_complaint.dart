// ignore_for_file: use_build_context_synchronously

import 'package:booking_app/constants/constants.dart';
import 'package:booking_app/functions/complaint_functions.dart';
import 'package:booking_app/widgets/textboxes/text_area_wcontroller.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

class RegisterComplaint extends StatefulWidget {
  final int villaNum;
  final List<dynamic> userDataList;

  const RegisterComplaint(
      {super.key, required this.villaNum, required this.userDataList});
  @override
  // ignore: no_logic_in_create_state
  State<RegisterComplaint> createState() => _RegisterComplaint();
}

class _RegisterComplaint extends State<RegisterComplaint> {
  bool isDateSelectionDone = false;
  String selectedName = '';
  String selectedEmail = '';
  int selectedPhoneNumber = 0;
  late List<dynamic> _names;
  late List<dynamic> _phoneNumbers;
  late List<dynamic> _emailAdresses;
  final String firstElementOfNameList = 'Select Name';
  final String firstElementOfEmailList = 'Select Email';
  final String firstElementOfStartTimeList = 'Start Time';
  final String firstElementOfEndTimeList = 'End Time';
  final int firstElementOfPhoneList = 0;
  List<String> startTimeList = timeList;
  List<String> endTimeList = timeList;

  TextEditingController issue = TextEditingController();
  TextEditingController description = TextEditingController();

  final complaintFunctions = ComplaintFunctions();

  bool loading = false;

  void initState() {
    super.initState();
    _names = widget.userDataList
        .map((userData) => userData['name'] as String)
        .toList();
    _phoneNumbers = widget.userDataList
        .map((userData) => userData['phoneNum'] as int)
        .toList();
    _emailAdresses = widget.userDataList
        .map((userData) => userData['email'] as String)
        .toList();
    _names = [firstElementOfNameList, ..._names];
    _phoneNumbers = [firstElementOfPhoneList, ..._phoneNumbers];
    _emailAdresses = [firstElementOfEmailList, ..._emailAdresses];
    startTimeList = [firstElementOfStartTimeList, ...timeList];
    endTimeList = [firstElementOfEndTimeList, ...timeList];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(42, 54, 59, 1),
        title: Text('Enter Complaint Details'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FractionallySizedBox(
                widthFactor: 0.9,
                child: DropdownButtonFormField<dynamic>(
                  value: _names[0],
                  onChanged: (value) {
                    setState(() {
                      selectedName = value!;
                      int selectedIndex = _names.indexOf(selectedName);
                      if (selectedIndex >= 0 &&
                          selectedIndex < _phoneNumbers.length) {
                        selectedPhoneNumber = _phoneNumbers[selectedIndex];
                        selectedEmail = _emailAdresses[selectedIndex];
                      } else {
                        selectedPhoneNumber = 0;
                      }
                    });
                  },
                  items: _names.map((name) {
                    return DropdownMenuItem<dynamic>(
                      value: name,
                      child: Text(name),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              FractionallySizedBox(
                  widthFactor: 0.9,
                  child: CustomTextFieldWController(
                      controller: issue, labelText: 'Issue')),
              const SizedBox(height: 3),
              FractionallySizedBox(
                  widthFactor: 0.9,
                  child: CustomTextAreaWController(
                    controller: description,
                    labelText: 'Description (optional)',
                    maxLines: 3,
                  )),
              const SizedBox(height: 30),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: PrimaryButton(
                  text: 'Register Complaint',
                  isLoading: loading,
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    List bookingStatus = await complaintFunctions.addEntry(
                        selectedName,
                        selectedEmail,
                        selectedPhoneNumber,
                        widget.villaNum,
                        issue,
                        description,
                        context);
                    print(bookingStatus[0]);
                    if (bookingStatus[0] == 1) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Booking Conflict'),
                            content: Text(bookingStatus[1]),
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
                    } else if (bookingStatus[0] == 0) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Record added'),
                            content: const Text('Your record has been added'),
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
                    } else if (bookingStatus[0] == 2) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('An error occured. Try again.'),
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
                    } else if (bookingStatus[0] == 3) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Date too early'),
                            content: const Text(
                                'Please select a time atleast 4 hours from now'),
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
                    } else if (bookingStatus[0] == 4) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('One or more empty fields'),
                            content: const Text(
                                'Please fill out all the required fields'),
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
                    setState(() {
                      loading = false;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
