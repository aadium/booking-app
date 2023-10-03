import 'package:booking_app/constants.dart';
import 'package:booking_app/firebase_options.dart';
import 'package:booking_app/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final observer = AppLifecycleObserver();
    observer.didChangeAppLifecycleState(AppLifecycleState.paused);
    runApp(MyApp(userCredential.user));
    WidgetsBinding.instance.addObserver(observer);
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
          cursorColor: Color.fromRGBO(42, 54, 59, 1),
        ),
      ),
      home: SignInPage(),
    );
  }
}

class AppLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _storeLastUsageTime();
    }
  }

  Future<void> _storeLastUsageTime() async {
    final preferences = await SharedPreferences.getInstance();
    final currentTime = DateTime.now();
    final formattedTime = DateFormat('yyyy-MM-dd hh:mm').format(currentTime);
    await preferences.setString('last_usage_time', formattedTime.toString());
  }
}