import 'package:booking_app/pages/view_bookings/calendar_page.dart';
import 'package:booking_app/pages/profile/profile_page.dart';
import 'package:booking_app/pages/book_clubhouse.dart';
import 'package:booking_app/pages/view_bookings/view_bookings.dart';
import 'package:booking_app/widgets/buttons/homepage_option_button.dart';
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
        child: Icon(Icons.house_rounded, size: 27,),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FractionallySizedBox(
                widthFactor: 0.9,
                child: HomepageOptionButton(
                  text: 'Book Clubhouse',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookClubHouse(
                              villaNum: widget.villa_num,
                              userDataList: widget.userData,
                            )
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: HomepageOptionButton(
                  text: 'View Bookings',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalendarPage(villaNum: widget.villa_num,)
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
