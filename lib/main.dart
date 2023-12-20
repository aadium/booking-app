import 'package:booking_app/constants/constants.dart';
import 'package:booking_app/firebase/firebase_options.dart';
import 'package:booking_app/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: 'secrets.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    runApp(MyApp());
  } on Exception catch (e) {
    debugPrint('Error: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color.fromRGBO(42, 54, 59, 1),
        ),
        appBarTheme: AppBarTheme(backgroundColor: Color.fromRGBO(42, 54, 59, 1),elevation: 0)
      ),
      home: SignInPage(),
    );
  }
}