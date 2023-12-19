import 'package:booking_app/functions/booking_functions.dart';
import 'package:booking_app/pages/clubhouse/booking_details.dart';
import 'package:booking_app/widgets/buttons/tertiary_button.dart';
import 'package:booking_app/widgets/datepicker/date_picker.dart';
import 'package:booking_app/widgets/loaders/loader_1.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserBookingHistory extends StatefulWidget {
  final int villaNum;
  UserBookingHistory({super.key, required this.villaNum});

  @override
  _UserBookingHistory createState() => _UserBookingHistory();
}

class _UserBookingHistory extends State<UserBookingHistory> {
  int villaNum = 0;
  dynamic asyncDate;
  final double tablePadding = 7;
  final customDatePicker = CustomDatePicker();
  final bookingMainFunctions = BookingMainFunctions();

  List bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    villaNum = widget.villaNum;
    _fetchData(villaNum);
  }

  Future<void> _fetchData(int villaNum) async {
    final List fetchedBookings =
        await bookingMainFunctions.fetchClubhouseBookingsByVilla(villaNum, true);
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
        title: Text('Villa #$villaNum booking history'),
      ),
      body: isLoading
          ? Center(
              child: Loader1()
            )
          :  Column(
        children: [
          const SizedBox(height: 10,),
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
                              builder: (context) => ClubhouseBookingDetails(
                                    data: data,
                                    bookingRef: document.reference,
                                    villa_number: widget.villaNum,
                                    isUserInBookingHistory: true,
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
                                      'Reason',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(42, 54, 59, 1)),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: Text(
                                      data['reason'],
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: const Text(
                                      'Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(42, 54, 59, 1)),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: Text(
                                      '${DateFormat('d MMMM yyyy').format(DateTime.parse(data['start_datetime']))}',
                                      style:
                                          const TextStyle(color: Colors.black),
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
                                          color: Color.fromRGBO(42, 54, 59, 1)),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: Text(
                                      '${DateFormat('h:mm a').format(DateTime.parse(data['start_datetime']))} to ${DateFormat('h:mm a').format(DateTime.parse(data['end_datetime']))}',
                                      style:
                                          const TextStyle(color: Colors.black),
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
