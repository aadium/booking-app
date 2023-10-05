import 'package:booking_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignFunctions {
  Future<List> signIn(TextEditingController _villaNumberController,
      TextEditingController _passwordController) async {
    int villaNumber = int.tryParse(_villaNumberController.text.trim()) ?? 0;
    String password = _passwordController.text.trim();

    // Query Firestore to check if the villa number and password combination exists in "villa_users"
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(firestoreVillaUsersCollection)
        .where('Villa_num', isEqualTo: villaNumber)
        .where('Password', isEqualTo: password)
        .get();
    _villaNumberController.clear();
    _passwordController.clear();
    if (snapshot.docs.isNotEmpty) {
      List<dynamic> userMaps = snapshot.docs.first.data()['userMaps'];
      return [0, userMaps];
    } else {
      return [1, null];
    }
  }
}
