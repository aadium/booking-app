// ignore_for_file: use_build_context_synchronously

import 'package:booking_app/constants/constants.dart';
import 'package:booking_app/functions/booking_functions.dart';
import 'package:booking_app/widgets/datepicker/date_picker.dart';
import 'package:booking_app/widgets/textboxes/text_area_wcontroller.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller_numeric.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
import 'package:booking_app/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookClubHouse extends StatefulWidget {
  final int villaNum;
  final List<dynamic> userDataList;

  const BookClubHouse(
      {super.key, required this.villaNum, required this.userDataList});
  @override
  // ignore: no_logic_in_create_state
  State<BookClubHouse> createState() => _BookClubHouse();
}

class _BookClubHouse extends State<BookClubHouse> {
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

  TextEditingController reason = TextEditingController();
  TextEditingController occupants = TextEditingController();
  TextEditingController additionalRequests = TextEditingController();

  DateTime selectedDate = DateTime.now();
  dynamic asyncDate;
  TimeOfDay selectedStartingTime = TimeOfDay.now();
  TimeOfDay selectedEndingTime = TimeOfDay.now();

  final customDatePicker = CustomDatePicker();
  final bookingMinorFunctions = BookingMinorFunctions();
  final bookingMainFunctions = BookingMainFunctions();

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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      controller: reason, labelText: 'Purpose of booking')),
              const SizedBox(height: 3),
              FractionallySizedBox(
                  widthFactor: 0.9,
                  child: CustomNumericTextFieldWController(
                      controller: occupants, labelText: 'Number of Occupants')),
              const SizedBox(height: 3),
              FractionallySizedBox(
                  widthFactor: 0.9,
                  child: CustomTextAreaWController(
                    controller: additionalRequests,
                    labelText: 'Additional requests (optional)',
                    maxLines: 3,
                  )),
              const SizedBox(height: 20),
              Table(children: [
                TableRow(children: [
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: DropdownButtonFormField<dynamic>(
                      // Start Time
                      value: startTimeList[0],
                      onChanged: (value) {
                        setState(() {
                          selectedStartingTime =
                              bookingMinorFunctions.parseTimeOfDay(value!);
                        });
                      },
                      items: startTimeList.map((time) {
                        return DropdownMenuItem<dynamic>(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: DropdownButtonFormField<dynamic>(
                      // End Time
                      value: endTimeList[0],
                      onChanged: (value) {
                        setState(() {
                          selectedEndingTime =
                              bookingMinorFunctions.parseTimeOfDay(value!);
                        });
                      },
                      items: endTimeList.map((time) {
                        return DropdownMenuItem<dynamic>(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                    ),
                  ),
                ])
              ]),
              const SizedBox(height: 30),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: SecondaryButton(
                      text: isDateSelectionDone
                          ? DateFormat('d MMMM yyyy').format(selectedDate)
                          : 'Select Date',
                      onPressed: () async {
                        asyncDate = await customDatePicker
                            .selectDateFromCurrentDate(context);
                        setState(() {
                          isDateSelectionDone = true;
                          selectedDate =
                              asyncDate == null ? selectedDate : asyncDate;
                        });
                      }),
                ),
              ),
              const SizedBox(height: 30),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: PrimaryButton(
                  text: 'Book Clubhouse',
                  isLoading: loading,
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    List bookingStatus = await bookingMainFunctions.addEntry(
                        selectedName,
                        selectedEmail,
                        selectedPhoneNumber,
                        widget.villaNum,
                        reason,
                        occupants,
                        additionalRequests,
                        selectedDate,
                        selectedStartingTime,
                        selectedEndingTime,
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
