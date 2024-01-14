import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('User signed in');
      return userCredential.user;
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('User signed up');
      return userCredential.user;
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    debugPrint('User signed out');
  }
}
