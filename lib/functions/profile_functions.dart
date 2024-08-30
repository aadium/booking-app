import 'package:booking_app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileFunctions {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProfileFunctions() {
    FirebaseAuth.instance.authStateChanges().listen((User? newUser) {
      user = newUser;
    });
  }

  Future<List> addUser(
      String newName,
      String newPhoneNumberStr,
      String newEmail,
      int villaNum) async {
    if (newName == '' || newPhoneNumberStr == '' || newEmail == '') {
      return [1, null, null];
    } else {
      int newPhoneNumber = int.parse(newPhoneNumberStr);
      Map<String, dynamic> userData = {
        'name': newName,
        'phoneNum': newPhoneNumber,
        'email': newEmail,
        'createdAt': DateTime.now(),
      };

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection(firestoreVillaUsersCollection)
          .where('Villa_num', isEqualTo: villaNum)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = snapshot.docs.first;

        String documentId = userDoc.id;

        await _firestore
            .collection(firestoreVillaUsersCollection)
            .doc(documentId)
            .update({
          'userMaps': FieldValue.arrayUnion([userData])
        });
        return [0, newName, userData];
      } else {
        return [2, newName, null];
      }
    }
  }

  Future<List> deleteAcceptedRequest(
      String newName,
      String newPhoneNumberStr,
      String newEmail,
      int villaNum) async {
    if (newName == '' || newPhoneNumberStr == '' || newEmail == '') {
      return [1, 'One or more fields are empty'];
    }

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection(firestoreRegistrationRequestsCollection)
          .where('name', isEqualTo: newName)
          .where('phone_number', isEqualTo: int.parse(newPhoneNumberStr))
          .where('email', isEqualTo: newEmail)
          .where('villa_num', isEqualTo: villaNum)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(firestoreRegistrationRequestsCollection)
            .doc(snapshot.docs.first.id)
            .delete();
        return [0, 'Request accepted and removed'];
      } else {
        return [2, 'Request not found'];
      }
    } catch (e) {
      return [3, 'Error: $e'];
    }
  }

  Future<void> removeUser(int villaNum, dynamic userDataList, int index) async {
    await _firestore
        .collection(firestoreVillaUsersCollection)
        .where('Villa_num', isEqualTo: villaNum)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = snapshot.docs.first;
        userDataList.removeAt(index);
        String documentId = userDoc.id;

        _firestore
            .collection(firestoreVillaUsersCollection)
            .doc(documentId)
            .update({'userMaps': userDataList});
      }
    });
  }

  Future<List<String>> getCurrentUser(int villaNum) async {
    String email = user!.email!;
    String currentUserName = '';
    String currentUserPhoneNum = '';
    await _firestore
        .collection(firestoreVillaUsersCollection)
        .where('Villa_num', isEqualTo: villaNum)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = snapshot.docs.first;
        List<dynamic> userMaps = userDoc['userMaps'];
        for (var userMap in userMaps) {
          if (userMap['email'] == email) {
            currentUserName = userMap['name'];
            currentUserPhoneNum = userMap['phoneNum'].toString();
          }
        }
      }
    });
    return [currentUserName, currentUserPhoneNum, email];
  }

  void showLocation() async {
    const latitude = 25.24225207729788;
    const longitude = 51.55955193548285;

    const url = 'https://maps.google.com/?q=$latitude,$longitude';

    await launch(url);
  }
}