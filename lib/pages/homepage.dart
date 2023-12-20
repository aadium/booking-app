import 'package:booking_app/pages/clubhouse/book_clubhouse.dart';
import 'package:booking_app/pages/clubhouse/calendar_page.dart';
import 'package:booking_app/pages/complaints/register_complaint.dart';
import 'package:booking_app/pages/complaints/view_complaints.dart';
import 'package:booking_app/pages/profile/profile_page.dart';
import 'package:booking_app/widgets/buttons/homepage_option_button.dart';
import 'package:booking_app/widgets/buttons/homepage_option_secondary_button.dart';
import 'package:booking_app/widgets/datepicker/date_picker.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final int villa_num;
  final List<dynamic> userData;
  const MyHomePage(
      {super.key, required this.villa_num, required this.userData});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();
  dynamic asyncDate;
  final customDatePicker = CustomDatePicker();

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
                      villaNumber: widget.villa_num,
                      userDataList: widget.userData,
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
                                  villaNum: widget.villa_num,
                                  userDataList: widget.userData,
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
                                  villaNum: widget.villa_num,
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
                                  villaNum: widget.villa_num,
                                  userDataList: widget.userData,
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
                                  villaNum: widget.villa_num,
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
