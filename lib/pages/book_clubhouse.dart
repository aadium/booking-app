import 'package:booking_app/constants.dart';
import 'package:booking_app/widgets/textboxes/text_area_wcontroller.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller_numeric.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
import 'package:booking_app/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
  String selectedName = '';
  int selectedPhoneNumber = 0;
  late List<dynamic> _names;
  late List<dynamic> _phoneNumbers;
  final String firstElementOfNameList = 'Select Name';
  final String firstElementOfTimeList = 'Select Time';
  final int firstElementOfPhoneList = 0;
  List<String> TimeList = timeList;

  TextEditingController reason = TextEditingController();
  TextEditingController occupants = TextEditingController();
  TextEditingController additionalRequests = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartingTime = TimeOfDay.now();
  TimeOfDay selectedEndingTime = TimeOfDay.now();

  bool loading = false;

  void initState() {
    super.initState();
    _names = widget.userDataList
        .map((userData) => userData['name'] as String)
        .toList();
    _phoneNumbers = widget.userDataList
        .map((userData) => userData['phoneNum'] as int)
        .toList();
    _names = [firstElementOfNameList, ..._names];
    _phoneNumbers = [firstElementOfPhoneList, ..._phoneNumbers];
    TimeList = [firstElementOfTimeList, ...timeList];
  }

  String checkBookingConflicts(DateTime selectedStartingTime,
      DateTime selectedEndingTime, List<dynamic> existingBookings) {
    for (var booking in existingBookings) {
      DateTime existingStartingTime = DateTime.parse(booking['start_datetime']);
      DateTime existingEndingTime = DateTime.parse(booking['end_datetime']);

      if ((existingStartingTime.isBefore(selectedEndingTime) &&
              existingEndingTime.isAfter(selectedStartingTime)) ||
          (existingStartingTime.isAfter(selectedStartingTime) &&
              existingEndingTime.isBefore(selectedEndingTime)) ||
          (existingStartingTime.isBefore(selectedStartingTime) &&
              existingEndingTime.isAfter(selectedEndingTime))) {
        return 'Clubhouse is booked from ${DateFormat('h:mm a').format(existingStartingTime)} to ${DateFormat('h:mm a').format(existingEndingTime)} on ${DateFormat('dd MMMM yyyy').format(existingStartingTime)}. Please choose another time range'; // Conflict detected
      }
    }
    return ''; // No conflict
  }

  bool checkTimeDiffValid(DateTime selectedStartingDateTime) {
    Duration timeDifference =
        selectedStartingDateTime.difference(DateTime.now());
    int hourDifference = timeDifference.inHours;

    if (hourDifference < 4) {
      return false;
    }

    return true;
  }

  bool checkNullRecords(
      TextEditingController reason, int occupants, BuildContext context) {
    if (reason.text == '' || occupants == 0) {
      return false;
    }
    return true;
  }

  void addEntry(
      String name,
      int phoneNumber,
      int villano,
      TextEditingController reason,
      int occupants,
      TextEditingController additionalRequests,
      DateTime selectedDate,
      TimeOfDay selectedStartingTime,
      TimeOfDay selectedEndingTime,
      BuildContext context) async {
    if (checkNullRecords(reason, occupants, context)) {
      setState(() {
        loading = true;
      });
      try {
        DateTime startingDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedStartingTime.hour,
          selectedStartingTime.minute,
        );
        DateTime endingDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedEndingTime.hour,
          selectedEndingTime.minute,
        );

        if (checkTimeDiffValid(startingDateTime)) {
          final existingBookings = [];
          firestore
              .collection(firestoreBookClubhouseCollection)
              .get()
              .then((snapshot) {
            existingBookings.addAll(snapshot.docs.map((doc) => doc.data()));
            String conflict = checkBookingConflicts(
                startingDateTime, endingDateTime, existingBookings);
            if (conflict != '') {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Booking Conflict'),
                    content: Text(conflict),
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
            } else {
              // No conflict, proceed to add the booking
              Map<String, dynamic> entryData = {
                'name': name,
                'villa_no': villano,
                'phone_number': phoneNumber,
                'reason': reason.text,
                'occupants': occupants,
                'additionalRequests': additionalRequests.text,
                'start_datetime': startingDateTime.toString(),
                'end_datetime': endingDateTime.toString(),
              };

              firestore
                  .collection(firestoreBookClubhouseCollection)
                  .add(entryData)
                  .then((value) {
                debugPrint('Document added to Firestore: $entryData');
                debugPrint('Value ID = ${value.id}');
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
              }).catchError((error) {
                debugPrint('Error adding document to Firestore: $error');
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
              });
            }
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Date too early'),
                content:
                    const Text('Please select a time atleast 4 hours from now'),
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
      } finally {
        setState(() {
          loading = false;
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Empty field'),
            content: const Text('One or more of the required fields is empty'),
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

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        // Theme customization for the date picker
        final ThemeData theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: Colors.black87,
              onPrimary: Colors.white,
            ),
            textTheme: theme.textTheme.copyWith(
              titleMedium: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  TimeOfDay parseTimeOfDay(String timeString) {
    List<String> parts = timeString.split(' ');
    List<String> timeParts = parts[0].split(':');

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    if (parts[1].toLowerCase() == 'pm' && hour != 12) {
      hour += 12;
    } else if (parts[1].toLowerCase() == 'am' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
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
                      borderSide: BorderSide(color: Colors.black87),
                    ),
                    labelStyle: TextStyle(color: Colors.black87),
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
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: SecondaryButton(
                            text: 'Select Date',
                            onPressed: () => _selectDate(context)),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        DateFormat('d MMMM yyyy').format(selectedDate),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Table(children: [
                TableRow(children: [
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        child: DropdownButtonFormField<dynamic>(
                          value: TimeList[0],
                          onChanged: (value) {
                            setState(() {
                              selectedStartingTime = parseTimeOfDay(value!);
                            });
                          },
                          items: TimeList.map((time) {
                            return DropdownMenuItem<dynamic>(
                              value: time,
                              child: Text(time),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: 'Start time',
                            labelStyle: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        child: DropdownButtonFormField<dynamic>(
                          value: TimeList[0],
                          onChanged: (value) {
                            setState(() {
                              selectedEndingTime = parseTimeOfDay(value!);
                            });
                          },
                          items: TimeList.map((time) {
                            return DropdownMenuItem<dynamic>(
                              value: time,
                              child: Text(time),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: 'End time',
                            labelStyle: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                  ),
                ])
              ]),
              const SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: PrimaryButton(
                  text: 'Book Clubhouse',
                  isLoading: loading,
                  onPressed: () {
                    int occupantsInteger = int.tryParse(occupants.text) ?? 0;
                    addEntry(
                        selectedName,
                        selectedPhoneNumber,
                        widget.villaNum,
                        reason,
                        occupantsInteger,
                        additionalRequests,
                        selectedDate,
                        selectedStartingTime,
                        selectedEndingTime,
                        context);
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
