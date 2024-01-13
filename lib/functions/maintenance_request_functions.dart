import 'dart:async';

import 'package:booking_app/constants/constants.dart';
import 'package:booking_app/functions/email_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class MaintenanceRequestFunctions {
  final emailFunctions = EmailFunctions();

  Future<List> addEntry(
    String name,
    String emailAddress,
    int phoneNumber,
    int villano,
    TextEditingController issue,
    TextEditingController description,
    BuildContext context,
  ) async {
    Completer<List> completer = Completer<List>();
    firestore
        .collection(firestoreMaintenanceRequestsCollection)
        .get()
        .then((snapshot) {
      Map<String, dynamic> entryData = {
        'name': name,
        'villa_no': villano,
        'phone_number': phoneNumber,
        'email_address': emailAddress,
        'issue': issue.text,
        'description': description.text,
        'date': DateFormat('d MMMM yyyy').format(DateTime.now()),
      };

      firestore
          .collection(firestoreMaintenanceRequestsCollection)
          .add(entryData)
          .then((value) {
        debugPrint('Document added to Firestore: $entryData');
        debugPrint('Value ID = ${value.id}');
        emailFunctions.sendComplaintConfirmationEmail(
            emailAddress,
            value.id,
            name,
            phoneNumber,
            villano,
            issue.text,
            description.text,);
        completer.complete([0, null]);
        debugPrint('0');
      }).catchError((error) {
        debugPrint('Error adding document to Firestore: $error');
        completer.complete([2, null]);
        debugPrint('2');
      });
    });
    return completer.future;
  }

  Future<List> fetchMaintenanceRequestsByVilla(
      int villaNumber, bool isSortInDescendingOrder) async {
    final querySnapshot = await firestore
        .collection(firestoreMaintenanceRequestsCollection)
        .orderBy('date', descending: isSortInDescendingOrder)
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
