import 'package:booking_app/pages/clubhouse/view_bookings.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
import 'package:booking_app/widgets/buttons/primary_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final int villaNum;

  const CalendarPage({super.key, required this.villaNum});
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
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
            Text('Select Date', style: TextStyle(fontSize: 45, color: Color.fromRGBO(42, 54, 59, 1)),),
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
                        builder: (context) => ViewClubhouseBookings(
                              villaNum: widget.villaNum,
                              selected_date: _selectedDay,
                            )),
                  );
                },
                text: 'Next',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
