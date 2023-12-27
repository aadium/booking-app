import 'package:booking_app/functions/homepage_functions.dart';
import 'package:booking_app/pages/clubhouse/book_clubhouse.dart';
import 'package:booking_app/pages/clubhouse/calendar_page.dart';
import 'package:booking_app/pages/complaints/register_complaint.dart';
import 'package:booking_app/pages/complaints/view_complaints.dart';
import 'package:booking_app/pages/profile/profile_page.dart';
import 'package:booking_app/widgets/buttons/homepage_option_button.dart';
import 'package:booking_app/widgets/buttons/homepage_option_secondary_button.dart';
import 'package:booking_app/widgets/datepicker/date_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  dynamic asyncDate;
  final customDatePicker = CustomDatePicker();
  List userData = [];
  int villaNumber = 0;
  final homepageFunctions = HomePageFunctions();

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(42, 54, 59, 1),
        automaticallyImplyLeading: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(235, 74, 95, 1),
        elevation: 0,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      villaNumber: villaNumber,
                      userDataList: userData,
                    ))),
        child: Icon(
          Icons.house_rounded,
          size: 27,
        ),
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.95,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Clubhouse Bookings',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Color.fromRGBO(219, 226, 230, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: HomepageOptionButton(
                          text: 'Book Clubhouse',
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
                        child: HomepageOptionSecondaryButton(
                          text: 'View all Bookings',
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
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Complaints',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Color.fromRGBO(255, 216, 221, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: HomepageOptionButton(
                          text: 'Register a Complaint',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterComplaint(
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
                        child: HomepageOptionSecondaryButton(
                          text: 'View your Complaints',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewComplaints(
                                  villaNum: villaNumber,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
