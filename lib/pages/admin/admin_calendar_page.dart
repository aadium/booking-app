import 'package:booking_app/functions/clubhouse_booking_functions.dart';
import 'package:booking_app/pages/admin/bookings/clubhouse/clubhouse_bookings.dart';
import 'package:booking_app/pages/clubhouse/view_bookings.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminCalendarPage extends StatefulWidget {
  @override
  _AdminCalendarPageState createState() => _AdminCalendarPageState();
}

class _AdminCalendarPageState extends State<AdminCalendarPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  List<DateTime> bookedDates = [];
  ClubhouseBookingMainFunctions bookingMainFunctions = ClubhouseBookingMainFunctions();

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    getBookedDates();
  }

  void getBookedDates() async {
    List<DateTime> dates = await bookingMainFunctions.fetchBookedDates();
    setState(() {
      bookedDates = dates;
    });
    print(bookedDates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FractionallySizedBox(
        heightFactor: 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Text(
              'Select Date',
              style:
                  TextStyle(fontSize: 45, color: Color.fromRGBO(42, 54, 59, 1)),
            ),
            TableCalendar(
              calendarBuilders: CalendarBuilders(
                headerTitleBuilder: (context, day) {
                  final text = DateFormat.yMMMM().format(day);
                  return Center(
                    child: Text(
                      text,
                      style: TextStyle(color: Color.fromRGBO(42, 54, 59, 1)),
                    ),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 157, 170, 1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${day.day}',
                    ),
                  );
                },
                selectedBuilder: (context, date, events) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(235, 74, 95, 1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color: Colors.white, // Customize the text color
                      ),
                    ),
                  );
                },
                dowBuilder: (context, day) {
                  if (day.weekday == DateTime.friday ||
                      day.weekday == DateTime.saturday) {
                    final text = DateFormat.E().format(day);
                    return Center(
                      child: Text(
                        text,
                        style: TextStyle(color: Color.fromRGBO(235, 74, 95, 1)),
                      ),
                    );
                  } else {
                    final text = DateFormat.E().format(day);
                    return Center(
                      child: Text(
                        text,
                        style: TextStyle(color: Color.fromRGBO(42, 54, 59, 1)),
                      ),
                    );
                  }
                },
                markerBuilder: (context, date, events) {
                  final sameDayBookedDates = bookedDates.where((bookedDate) => 
                    DateTime(bookedDate.year, bookedDate.month, bookedDate.day) == 
                    DateTime(date.year, date.month, date.day)
                  ).toList();

                  if (sameDayBookedDates.isNotEmpty) {
                    return Positioned(
                      bottom: 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(sameDayBookedDates.length, (index) => 
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.0), // Add some space between the dots
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(42, 54, 59, 1),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
              firstDay: DateTime(DateTime.now().year - 1),
              lastDay: DateTime(DateTime.now().year + 1),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              availableCalendarFormats: {CalendarFormat.month: 'Month'},
            ),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: PrimaryButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminViewClubhouseBookings(
                              selected_date: _selectedDay,
                            )),
                  );
                },
                text:
                    'View bookings on ${DateFormat.yMMMMd().format(_selectedDay)}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
