// ignore_for_file: must_be_immutable

import 'package:booking_app/functions/homepage_functions.dart';
import 'package:booking_app/pages/admin/admin_profile_page.dart';
import 'package:booking_app/pages/admin/admin_villas_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminHomeScreen extends StatefulWidget {
  int pageIndex;
  final User user;
  AdminHomeScreen({super.key, required this.pageIndex, required this.user});
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;
  List userData = [];
  int villaNumber = 0;
  final homepageFunctions = HomePageFunctions();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    final User user = widget.user;
    final List<Widget> pages = <Widget>[
      AdminVillasPage(),
      AdminProfilePage()
    ];
    return Scaffold(
      body: Center(child: pages.elementAt(_currentIndex)),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 2.0, color: Color.fromRGBO(235, 74, 95, 1)),
          ),
        ),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/houses.svg',
                width: 30,
                height: 30,
                color: _currentIndex == 0
                    ? const Color.fromRGBO(235, 74, 95, 1)
                    : const Color.fromRGBO(112, 132, 141, 1),
              ),
              label: 'Villas',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/admin.svg',
                width: 30,
                height: 30,
                color: _currentIndex == 1
                    ? const Color.fromRGBO(235, 74, 95, 1)
                    : const Color.fromRGBO(112, 132, 141, 1),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
