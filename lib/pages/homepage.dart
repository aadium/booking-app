import 'package:booking_app/pages/profile/profile_page.dart';
import 'package:booking_app/pages/book_clubhouse.dart';
import 'package:booking_app/pages/view_bookings.dart';
import 'package:booking_app/widgets/buttons/homepage_option_button.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
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
  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        // Theme customization for the date picker
        final ThemeData theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: Colors.black87,
              onPrimary: Colors.white,
            ),
            textTheme: theme.textTheme.copyWith(
              titleMedium: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewClubhouseBookings(
                  villaNum: widget.villa_num,
                  selected_date: selectedDate,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
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
          // Return false to disable the back button functionality.
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
                    _selectDate(context);
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
