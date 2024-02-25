import 'dart:async';

import 'package:booking_app/constants/constants.dart';
import 'package:booking_app/functions/email_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class SwimPoolBookingMinorFunctions {
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
        return 'Swimming Pool is booked from ${DateFormat('h:mm a').format(existingStartingTime)} to ${DateFormat('h:mm a').format(existingEndingTime)} on ${DateFormat('dd MMMM yyyy').format(existingStartingTime)}. Please choose another time range'; // Conflict detected
      }
    }
    return ''; // No conflict
  }

  bool checkTimeDiffValid(DateTime selectedStartingDateTime) {
    Duration timeDifference =
        selectedStartingDateTime.difference(DateTime.now());
    int hourDifference = timeDifference.inHours;

    if (hourDifference < 1) {
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

class SwimPoolBookingMainFunctions {
  final bookingMinorFunctions = SwimPoolBookingMinorFunctions();
  final emailFunctions = EmailFunctions();

  Future<List> addEntry(
    String name,
    String emailAddress,
    int phoneNumber,
    int villano,
    DateTime selectedDate,
    TimeOfDay selectedStartingTime,
    TimeOfDay selectedEndingTime,
    BuildContext context,
  ) async {
    Completer<List> completer = Completer<List>();
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
            .collection(firestoreBookSwimPoolCollection)
            .get()
            .then((snapshot) {
          existingBookings.addAll(snapshot.docs.map((doc) => doc.data()));
          String conflict = bookingMinorFunctions.checkBookingConflicts(
              startingDateTime, endingDateTime, existingBookings);
          if (conflict != '') {
            completer.complete([1, conflict]);
            debugPrint('1');
          } else {
            Map<String, dynamic> entryData = {
              'name': name,
              'villa_no': villano,
              'phone_number': phoneNumber,
              'email_address': emailAddress,
              'start_datetime': startingDateTime.toString(),
              'end_datetime': endingDateTime.toString(),
            };

            firestore
                .collection(firestoreBookSwimPoolCollection)
                .add(entryData)
                .then((value) {
              debugPrint('Document added to Firestore: $entryData');
              debugPrint('Value ID = ${value.id}');
              emailFunctions.sendBookingConfirmationEmail(
                  'Swimming Pool',
                  emailAddress,
                  value.id,
                  name,
                  phoneNumber,
                  villano,
                  startingDateTime,
                  endingDateTime,
                  '',);
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
    return completer.future;
  }

  Future<List> fetchBookingsByDate(
      DateTime selectedDate, bool isSortInDescendingOrder) async {
    final querySnapshot = await firestore
        .collection(firestoreBookSwimPoolCollection)
        .orderBy('start_datetime', descending: isSortInDescendingOrder)
        .get();

    final documents = querySnapshot.docs;

    final filteredDocuments = documents.where((document) {
      final data = document.data();
      final name = DateFormat('d MMMM yyyy')
          .format(DateTime.parse(data['start_datetime']));
      return name
          .toString()
          .contains(DateFormat('d MMMM yyyy').format(selectedDate));
    }).toList();
    return filteredDocuments;
  }

  Future<List> fetchBookingsByVilla(
      int villaNumber, bool isSortInDescendingOrder) async {
    final querySnapshot = await firestore
        .collection(firestoreBookSwimPoolCollection)
        .orderBy('start_datetime', descending: isSortInDescendingOrder)
        .get();

    final documents = querySnapshot.docs;

    final filteredDocuments = documents.where((document) {
      final data = document.data();
      final documentVillaNumber = data['villa_no'];
      return documentVillaNumber == villaNumber;
    }).toList();

    return filteredDocuments;
  }

  Future<List<DateTime>> fetchBookedDates() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(firestoreBookSwimPoolCollection)
        .get();

    return snapshot.docs.map((doc) {
      String dateString = doc.data()['start_datetime'];
      DateTime dateTime = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').parse(dateString);
      DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);
      return date;
    }).toList();
  }
}
