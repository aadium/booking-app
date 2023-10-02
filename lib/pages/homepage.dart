import 'package:booking_app/pages/profile/profile_page.dart';
import 'package:booking_app/pages/book_clubhouse.dart';
import 'package:booking_app/pages/view_bookings.dart';
import 'package:booking_app/widgets/buttons/homepage_option_button.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
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
        backgroundColor: Color.fromRGBO(42, 54, 59, 1),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.logout)),
            IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              villaNumber: widget.villa_num,
                              userDataList: widget.userData,
                            ))),
                icon: Icon(Icons.house_rounded)),
          ],
        ),
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
                              )),
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: HomepageOptionButton(
                  text: 'View Bookings',
                  onPressed: () async {
                    asyncDate = await customDatePicker.selectDate(context);
                    setState(() {
                      selectedDate =
                          asyncDate == null ? selectedDate : asyncDate;
                    });
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewClubhouseBookings(
                                villaNum: widget.villa_num,
                                selected_date: selectedDate,
                              )),
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
