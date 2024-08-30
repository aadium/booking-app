import 'package:booking_app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'email_functions.dart';

class SignFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  EmailFunctions emailFunctions = EmailFunctions();

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<void> changePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.updatePassword(newPassword).then((_) {
        debugPrint('Successfully changed password');
      }).catchError((error) {
        debugPrint('Password cannot be changed: $error');
      });
    }
  }

  Future<void> registerRequest(villaNumController, nameController, phoneNumberController, emailController) async {
    await emailFunctions.sendRegistrationRequestEmail(
        int.parse(villaNumController.text),
        nameController.text,
        int.parse(phoneNumberController.text),
        emailController.text);
    await firestore
        .collection(firestoreRegistrationRequestsCollection)
        .add({
          'villa_num': int.parse(villaNumController.text),
          'name': nameController.text,
          'email': emailController.text,
          'phone_number': int.parse(phoneNumberController.text),
          'created_at': DateTime.now(),
        });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
