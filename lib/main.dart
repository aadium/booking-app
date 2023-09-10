import 'package:booking_app/constants.dart';
import 'package:booking_app/firebase_options.dart';
import 'package:booking_app/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    UserCredential? userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: firestoreSignInEmail,
      password: firestoreSignInPassword,
    );
    runApp(MyApp(userCredential.user));
  } on Exception catch (e) {
    debugPrint('Error: $e');
  }
}

class MyApp extends StatelessWidget {
  final User? user;
  const MyApp(this.user, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black87,
        ),
      ),
      home: SignInPage(),
    );
  }
}
