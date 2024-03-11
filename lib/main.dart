import 'dart:convert';

import 'package:booking_app/constants/constants.dart';
import 'package:booking_app/firebase/firebase_options.dart';
import 'package:booking_app/home_screen.dart';
import 'package:booking_app/pages/admin/admin_home_screen.dart';
import 'package:booking_app/pages/loading_screen.dart';
import 'package:booking_app/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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

  MyApp({super.key});

  Future<String> getUserRole(User? user) async {
    if (user == null) {
      return '';
    }
    final jwt = await user.getIdToken();
    final response = await http.get(
        Uri.parse(
            '${adminServerUrl}api/auth/getUser/${user.uid}'),
        headers: {'Authorization': 'Bearer $jwt'});
    return jsonDecode(response.body)['customClaims']['role'];
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    return FutureBuilder<String>(
      future: getUserRole(currentUser),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          String userRole = snapshot.data ?? '';
          return MaterialApp(
            title: 'Booking App',
            initialRoute: currentUser != null
                ? userRole == 'admin'
                    ? '/admin'
                    : '/home'
                : '/login',
            routes: {
              '/home': (context) =>
                  HomeScreen(pageIndex: 0, user: currentUser!),
              '/admin': (context) => AdminHomeScreen(pageIndex: 0),
              '/login': (context) => const SignInPage(),
            },
            theme: ThemeData(
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Color.fromRGBO(42, 54, 59, 1),
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Color.fromRGBO(42, 54, 59, 1),
                unselectedItemColor: Color.fromRGBO(112, 132, 141, 1),
                selectedItemColor: Color.fromRGBO(235, 74, 95, 1),
                elevation: 0,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromRGBO(42, 54, 59, 1),
                elevation: 0,
              ),
            ),
          );
        } else {
          // Return a placeholder widget while the Future is loading.
          return LoadingScreen();
        }
      },
    );
  }
}
