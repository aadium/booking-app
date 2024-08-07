import 'package:booking_app/pages/admin/bookings/clubhouse/calendar_page.dart';
import 'package:booking_app/pages/admin/bookings/squash_court/calendar_page.dart';
import 'package:booking_app/pages/admin/bookings/swimming_pool/calendar_page.dart';
import 'package:booking_app/pages/admin/bookings/tennis_court/calendar_page.dart';
import 'package:booking_app/widgets/buttons/homepage_option_button.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
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
                                text: 'View all Bookings',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminClubhouseCalendarPage(),
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
                                text: 'View all Bookings',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminSwimPoolCalendarPage(),
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
                                text: 'View all Bookings',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminTennisCourtCalendarPage(),
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
                                text: 'View all Bookings',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminSquashCourtCalendarPage(),
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
