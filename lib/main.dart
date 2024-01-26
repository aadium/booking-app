import 'package:booking_app/firebase/firebase_options.dart';
import 'package:booking_app/home_screen.dart';
import 'package:booking_app/pages/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String initialRoute = '/login';

  Future<String> decideRoute() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      final doc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(currentUser.email)
          .get();
      if (doc.exists) {
        return '/admin_home';
      } else {
        return '/home';
      }
    }
    return '/login';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: decideRoute(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Booking App',
            initialRoute: snapshot.data,
            routes: {
              '/home': (context) => HomeScreen(pageIndex: 0, user: _auth.currentUser!),
              '/admin_home': (context) => HomeScreen(pageIndex: 0, user: _auth.currentUser!),
              '/login': (context) => SignInPage(),
            },
            theme: ThemeData(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: Color.fromRGBO(42, 54, 59, 1),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: Color.fromRGBO(42, 54, 59, 1),
                  unselectedItemColor: Color.fromRGBO(112, 132, 141, 1),
                  selectedItemColor: Color.fromRGBO(235, 74, 95, 1),
                  elevation: 0),
              appBarTheme: AppBarTheme(
                backgroundColor: Color.fromRGBO(42, 54, 59, 1),
                elevation: 0,
              ),
            ),
          );
        }
        // While the data is loading, return a spinner
        return CircularProgressIndicator();
      },
    );
  }
}