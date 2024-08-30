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

  Future<void> registerRequest(TextEditingController villaNumController, TextEditingController nameController, TextEditingController phoneNumberController, TextEditingController emailController) async {
    try {
      await firestore
          .collection(firestoreRegistrationRequestsCollection)
          .add({
        'villa_num': int.tryParse(villaNumController.text) ?? 0,
        'name': nameController.text,
        'email': emailController.text,
        'phone_number': int.tryParse(phoneNumberController.text) ?? 0,
        'created_at': DateTime.now()
      });
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception('Failed to add request to Firestore: ${e.message}');
      } else {
        throw Exception('Failed to send registration request: $e');
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
