import 'package:booking_app/pages/clubhouse/book_clubhouse.dart';
import 'package:booking_app/pages/clubhouse/calendar_page.dart';
import 'package:booking_app/pages/squash_court/book_squash_court.dart';
import 'package:booking_app/pages/squash_court/calendar_page.dart';
import 'package:booking_app/pages/swimming_pool/book_swim_pool.dart';
import 'package:booking_app/pages/swimming_pool/calendar_page.dart';
import 'package:booking_app/pages/tennis_court/book_tennis_court.dart';
import 'package:booking_app/pages/tennis_court/calendar_page.dart';
import 'package:booking_app/widgets/buttons/homepage_option_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User user;
  final int villaNumber;
  final List userData;
  const HomePage({super.key, required this.user, required this.villaNumber, required this.userData});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    int villaNumber = widget.villaNumber;
    List userData = widget.userData;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(42, 54, 59, 1),
        automaticallyImplyLeading: false,
        title: Center (child: Text('Facilities'),)
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Color.fromRGBO(219, 226, 230, 1),
                    image: DecorationImage(
                      image: AssetImage('assets/clubhouse.png'), // replace with your image
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Clubhouse',
                          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color.fromRGBO(42, 54, 59, 1)),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: HomepageOptionButton(
                                text: 'Book\nClubhouse',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookClubHouse(
                                        villaNum: villaNumber,
                                        userDataList: userData,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: HomepageOptionButton(
                                text: 'View all\nBookings',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CalendarPage(
                                        villaNum: villaNumber,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Color.fromRGBO(219, 226, 230, 1),
                    image: DecorationImage(
                      image: AssetImage('assets/swimming_pool.png'), // replace with your image
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Swimming Pool',
                          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color.fromRGBO(42, 54, 59, 1)),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: HomepageOptionButton(
                                text: 'Book\nSwimming Pool',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookSwimPool(
                                        villaNum: villaNumber,
                                        userDataList: userData,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: HomepageOptionButton(
                                text: 'View all\nBookings',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SwimPoolCalendarPage(
                                        villaNum: villaNumber,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Color.fromRGBO(219, 226, 230, 1),
                    image: DecorationImage(
                      image: AssetImage('assets/tennis_court.png'), // replace with your image
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Tennis Court',
                          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color.fromRGBO(42, 54, 59, 1)),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: HomepageOptionButton(
                                text: 'Book Tennis\nCourt',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookTennisCourt(
                                        villaNum: villaNumber,
                                        userDataList: userData,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: HomepageOptionButton(
                                text: 'View all\nBookings',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TennisCourtCalendarPage(
                                        villaNum: villaNumber,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Color.fromRGBO(219, 226, 230, 1),
                    image: DecorationImage(
                      image: AssetImage('assets/squash_court.png'), // replace with your image
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Squash Court',
                          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color.fromRGBO(42, 54, 59, 1)),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: HomepageOptionButton(
                                text: 'Book Squash\nCourt',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookSquashCourt(
                                        villaNum: villaNumber,
                                        userDataList: userData,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: HomepageOptionButton(
                                text: 'View all\nBookings',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SquashCourtCalendarPage(
                                        villaNum: villaNumber,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
