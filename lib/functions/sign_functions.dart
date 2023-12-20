import 'package:booking_app/constants/constants.dart';
import 'package:booking_app/firebase/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignFunctions {
  Authentication authentication = Authentication();
  Future<List> signIn(
    TextEditingController _villaNumberController,
    TextEditingController _passwordController,
  ) async {
    int villaNumber = int.tryParse(_villaNumberController.text.trim()) ?? 0;
    String password = _passwordController.text.trim();

    try {
      // Sign in with the default Firebase account
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: firestoreSignInEmail,
        password: firestoreSignInPassword,
      );

      debugPrint('Successfully signed in to Firestore!');

      // Query Firestore to check if the villa number and password combination exists
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection(firestoreVillaUsersCollection)
              .where('Villa_num', isEqualTo: villaNumber)
              .where('Password', isEqualTo: password)
              .get();

      if (snapshot.docs.isNotEmpty) {
        List<dynamic> userMaps = snapshot.docs.first.data()['userMaps'];
        return [0, userMaps];
      } else {
        authentication.signOut();
        return [1, null];
      }
    } catch (error) {
      print('Authentication Error: $error');
      return [2, null];
    }
  }
}
