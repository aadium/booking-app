import 'package:booking_app/functions/homepage_functions.dart';
import 'package:booking_app/pages/home_page.dart';
import 'package:booking_app/pages/maintenance_requests_page.dart';
import 'package:booking_app/pages/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  int pageIndex;
  final User user;
  HomeScreen({super.key, required this.pageIndex, required this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List userData = [];
  int villaNumber = 0;
  final homepageFunctions = HomePageFunctions();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.pageIndex;
    setUserDataAndVillaNum();
  }

  Future<void> setUserDataAndVillaNum() async {
    List villaData = await homepageFunctions.FetchVillaData(widget.user);
    setState(() {
      villaNumber = villaData[0];
      userData = villaData[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = widget.user;
    final List<Widget> pages = <Widget>[
      HomePage(user: user, villaNumber: villaNumber, userData: userData),
      MaintenanceRequestsPage(user: user, villaNumber: villaNumber, userData: userData),
      ProfilePage(villaNumber: villaNumber, userDataList: userData)
    ];
    return Scaffold(
      body: Center(
        child: pages.elementAt(_currentIndex)
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
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
              icon: FaIcon(FontAwesomeIcons.list),
              label: 'Facilities',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.screwdriverWrench),
              label: 'Maintenance',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.houseUser),
              label: 'Villa',
            ),
          ],
        ),
      ),
    );
  }
}
