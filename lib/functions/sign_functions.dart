import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
