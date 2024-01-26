import 'package:booking_app/firebase/firebase_options.dart';
import 'package:booking_app/home_screen.dart';
import 'package:booking_app/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    return MaterialApp(
      title: 'Booking App',
      initialRoute: currentUser != null ? '/home' : '/login',
      routes: {
        '/home': (context) =>
            HomeScreen(pageIndex: 0, user: currentUser!),
        '/admin_home': (context) =>
            HomeScreen(pageIndex: 0, user: currentUser!),
        '/login': (context) => SignInPage(),
      },
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color.fromRGBO(42, 54, 59, 1),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Color.fromRGBO(42, 54, 59, 1), unselectedItemColor: Color.fromRGBO(112, 132, 141, 1), selectedItemColor: Color.fromRGBO(235, 74, 95, 1), elevation: 0),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(42, 54, 59, 1),
          elevation: 0,
        ),
      ),
    );
  }
}