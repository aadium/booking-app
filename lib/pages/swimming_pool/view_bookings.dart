import 'package:booking_app/functions/swim_pool_booking_functions.dart';
import 'package:booking_app/pages/swimming_pool/booking_details.dart';
import 'package:booking_app/pages/swimming_pool/calendar_page.dart';
import 'package:booking_app/widgets/buttons/view_bookings_date_button.dart';
import 'package:booking_app/widgets/buttons/tertiary_button.dart';
import 'package:booking_app/widgets/datepicker/date_picker.dart';
import 'package:booking_app/widgets/loaders/loader_1.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewSwimPoolBookings extends StatefulWidget {
  final int villaNum;
  final DateTime selected_date;
  ViewSwimPoolBookings(
      {super.key, required this.villaNum, required this.selected_date});

  @override
  _ViewSwimPoolBookingsState createState() => _ViewSwimPoolBookingsState();
}

class _ViewSwimPoolBookingsState extends State<ViewSwimPoolBookings> {
  DateTime selectedDate = DateTime.now();
  dynamic asyncDate;
  final double tablePadding = 7;
  final customDatePicker = CustomDatePicker();
  final bookingMainFunctions = SwimPoolBookingMainFunctions();

  List bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selected_date;
    _fetchData(selectedDate);
  }

  Future<void> _fetchData(DateTime selectedDate) async {
    final List fetchedBookings = await bookingMainFunctions
        .fetchBookingsByDate(selectedDate, false);
    setState(() {
      bookings = fetchedBookings;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(42, 54, 59, 1),
        title: Text(
          'Swimming Pool Bookings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? Center(child: Loader1())
          : Column(
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: ViewBookingsDateButton(
                      text: DateFormat('d MMMM yyyy').format(selectedDate),
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SwimPoolCalendarPage(
                              villaNum: widget.villaNum,
                            ),
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final document = bookings[index];
                    final data = document.data() as Map<String, dynamic>;

                    return Column(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.95,
                          child: TertiaryButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SwimPoolBookingDetails(
                                          data: data,
                                          bookingRef: document.reference,
                                          villa_number: widget.villaNum,
                                        )),
                              );
                            },
                            child: Row(
                              children: [
                                Table(
                                  columnWidths: const {
                                    0: FixedColumnWidth(
                                        170), // Adjusts width based on content
                                    1: FixedColumnWidth(170),
                                  },
                                  children: [
                                    TableRow(children: [
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(tablePadding),
                                          child: const Text(
                                            'Villa Number',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    42, 54, 59, 1)),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(tablePadding),
                                          child: Text(
                                            data['villa_no'].toString(),
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                      )
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(tablePadding),
                                          child: const Text(
                                            'Time Duration',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    42, 54, 59, 1)),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(tablePadding),
                                          child: Text(
                                            '${DateFormat('h:mm a').format(DateTime.parse(data['start_datetime']))} to ${DateFormat('h:mm a').format(DateTime.parse(data['end_datetime']))}',
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                      )
                                    ]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                )),
              ],
            ),
    );
  }
}
