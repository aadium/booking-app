import 'dart:async';

import 'package:booking_app/constants/constants.dart';
import 'package:booking_app/functions/email_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class BookingMinorFunctions {
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

  bool checkNullRecords(TextEditingController reason, int occupants) {
    if (reason.text == '' || occupants == 0) {
      return false;
    }
    return true;
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
}

class BookingMainFunctions {
  final bookingMinorFunctions = BookingMinorFunctions();
  final emailFunctions = EmailFunctions();

  Future<List> addEntry(
    String name,
    String emailAddress,
    int phoneNumber,
    int villano,
    TextEditingController reason,
    TextEditingController occupants,
    TextEditingController additionalRequests,
    DateTime selectedDate,
    TimeOfDay selectedStartingTime,
    TimeOfDay selectedEndingTime,
    BuildContext context,
  ) async {
    Completer<List> completer = Completer<List>();
    int occupantsInteger = int.tryParse(occupants.text) ?? 1;
    if (bookingMinorFunctions.checkNullRecords(reason, occupantsInteger)) {
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

      if (bookingMinorFunctions.checkTimeDiffValid(startingDateTime)) {
        final existingBookings = [];
        firestore
            .collection(firestoreBookClubhouseCollection)
            .get()
            .then((snapshot) {
          existingBookings.addAll(snapshot.docs.map((doc) => doc.data()));
          String conflict = bookingMinorFunctions.checkBookingConflicts(
              startingDateTime, endingDateTime, existingBookings);
          if (conflict != '') {
            completer.complete([1, conflict]);
            debugPrint('1');
          } else {
            // No conflict, proceed to add the booking
            Map<String, dynamic> entryData = {
              'name': name,
              'villa_no': villano,
              'phone_number': phoneNumber,
              'reason': reason.text,
              'occupants': occupantsInteger,
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
              emailFunctions.sendBookingConfirmationEmail(
                  emailAddress,
                  value.id,
                  name,
                  phoneNumber,
                  villano,
                  reason.text,
                  occupantsInteger,
                  additionalRequests.text,
                  startingDateTime,
                  endingDateTime);
              completer.complete([0, null]);
              debugPrint('0');
            }).catchError((error) {
              debugPrint('Error adding document to Firestore: $error');
              completer.complete([2, null]);
              debugPrint('2');
            });
          }
        });
      } else {
        completer.complete([3, null]);
        debugPrint('3');
      }
    } else {
      completer.complete([4, null]);
      debugPrint('4');
    }
    return completer.future;
  }

  Future<List> fetchClubhouseBookingsByDate(
      DateTime selectedDate, bool isSortInDescendingOrder) async {
    final querySnapshot = await firestore
        .collection(firestoreBookClubhouseCollection)
        .orderBy('start_datetime', descending: isSortInDescendingOrder)
        .get();

    final documents = querySnapshot.docs;

    final filteredDocuments = documents.where((document) {
      final data = document.data() as Map<String, dynamic>;
      final name = DateFormat('d MMMM yyyy')
          .format(DateTime.parse(data['start_datetime']));
      return name
          .toString()
          .contains(DateFormat('d MMMM yyyy').format(selectedDate));
    }).toList();
    return filteredDocuments;
  }

  Future<List> fetchClubhouseBookingsByVilla(
      int villaNumber, bool isSortInDescendingOrder) async {
    final querySnapshot = await firestore
        .collection(firestoreBookClubhouseCollection)
        .orderBy('start_datetime', descending: isSortInDescendingOrder)
        .get();

    final documents = querySnapshot.docs;

    final filteredDocuments = documents.where((document) {
      final data = document.data() as Map<String, dynamic>;
      final documentVillaNumber = data['villa_no'];
      return documentVillaNumber == villaNumber;
    }).toList();

    return filteredDocuments;
  }
}