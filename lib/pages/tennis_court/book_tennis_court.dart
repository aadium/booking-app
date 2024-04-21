// ignore_for_file: use_build_context_synchronously

import 'package:booking_app/constants/constants.dart';
import 'package:booking_app/functions/tennis_court_booking_functions.dart';
import 'package:booking_app/widgets/datepicker/date_picker.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
import 'package:booking_app/widgets/buttons/secondary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookTennisCourt extends StatefulWidget {
  final int villaNum;
  final List<dynamic> userDataList;

  const BookTennisCourt(
      {super.key, required this.villaNum, required this.userDataList});
  @override
  // ignore: no_logic_in_create_state
  State<BookTennisCourt> createState() => _BookTennisCourt();
}

class _BookTennisCourt extends State<BookTennisCourt> {
  bool isDateSelectionDone = false;
  String selectedName = '';
  String selectedEmail = '';
  int selectedPhoneNumber = 0;
  late List<dynamic> _names;
  late List<dynamic> _phoneNumbers;
  late List<dynamic> _emailAdresses;
  final String firstElementOfStartTimeList = 'Start Time';
  final String firstElementOfEndTimeList = 'End Time';
  List<String> startTimeList = timeList;
  List<String> endTimeList = timeList;
  DateTime selectedDate = DateTime.now();
  dynamic asyncDate;
  TimeOfDay selectedStartingTime = TimeOfDay.now();
  TimeOfDay selectedEndingTime = TimeOfDay.now();

  final customDatePicker = CustomDatePicker();
  final bookingMinorFunctions = TennisCourtBookingMinorFunctions();
  final bookingMainFunctions = TennisCourtBookingMainFunctions();

  bool loading = false;

  final User user = FirebaseAuth.instance.currentUser!;

  @override
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
    startTimeList = [firstElementOfStartTimeList, ...timeList];
    endTimeList = [firstElementOfEndTimeList, ...timeList];
    selectedEmail = user.email!;
    int selectedIndex = _emailAdresses.indexOf(selectedEmail);
    if (selectedIndex >= 0 &&
        selectedIndex < _phoneNumbers.length) {
      selectedPhoneNumber = _phoneNumbers[selectedIndex];
      selectedName = _names[selectedIndex];
    } else {
      selectedPhoneNumber = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(42, 54, 59, 1),
        title: Text('Enter Booking Details'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Table(
                border: TableBorder.all(color: Color.fromRGBO(219, 226, 230, 1)),
                  children: [
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Text(
                        'Name',
                        style: const TextStyle(fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Text(
                        selectedName,
                        style: const TextStyle(fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Text(
                        'Phone Number',
                        style: const TextStyle(fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Text(
                        selectedPhoneNumber == 0 ? '' : '+974 $selectedPhoneNumber',
                        style: const TextStyle(fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Text(
                        'Email I.D.',
                        style: const TextStyle(fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Text(
                        selectedEmail,
                        style: const TextStyle(fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
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
              isDateSelectionDone ? Column(
                children: [
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
                              selectedStartingTime = bookingMinorFunctions.parseTimeOfDay(value!);
                              int selectedIndex = timeList.indexOf(value);
                              if (selectedIndex >= 0 && selectedIndex < timeList.length - 1) {
                                endTimeList = [firstElementOfEndTimeList, ...timeList.sublist(selectedIndex + 1)];
                              } else {
                                endTimeList = [firstElementOfEndTimeList];
                              }
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
                ],
              ) : const SizedBox(height: 0),
              const SizedBox(height: 30),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: PrimaryButton(
                  text: 'Book Tennis Court',
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
                        selectedDate,
                        selectedStartingTime,
                        selectedEndingTime,
                        context);
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
                            title: const Text('Tennis Court booked'),
                            content: const Text('Your booking has been confirmed'),
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
                                'Please select a time atleast 1 hour from now'),
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
