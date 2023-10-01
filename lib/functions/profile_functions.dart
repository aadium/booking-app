import 'package:booking_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final User? user = FirebaseAuth.instance.currentUser;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ProfileFunctions {
  Future<List> addUser(
      TextEditingController newNameController,
      TextEditingController newPhoneNumberController,
      TextEditingController newEmailController,
      int villaNum) async {
    String newName = newNameController.text;
    String newPhoneNumberStr = newPhoneNumberController.text;
    String newEmail = newEmailController.text;
    if (newName == '' || newPhoneNumberStr == '' || newEmail == '') {
      return [1, null, null];
    } else {
      int newPhoneNumber = int.parse(newPhoneNumberStr);
      Map<String, dynamic> userData = {
        'name': newName,
        'phoneNum': newPhoneNumber,
        'email': newEmail,
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
}
