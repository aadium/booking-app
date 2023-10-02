import 'package:booking_app/constants.dart';
import 'package:booking_app/pages/book_clubhouse.dart';
import 'package:booking_app/widgets/buttons/view_bookings_date_button.dart';
import 'package:booking_app/widgets/buttons/view_bookings_option_button.dart';
import 'package:booking_app/widgets/datepicker/date_picker.dart';
import 'package:booking_app/widgets/textbuttons/accept_text_button.dart';
import 'package:booking_app/widgets/textbuttons/reject_text_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class ViewClubhouseBookings extends StatefulWidget {
  final int villaNum;
  final DateTime selected_date;
  ViewClubhouseBookings(
      {super.key, required this.villaNum, required this.selected_date});

  @override
  _ViewClubhouseBookingsState createState() => _ViewClubhouseBookingsState();
}

class _ViewClubhouseBookingsState extends State<ViewClubhouseBookings> {
  DateTime selectedDate = DateTime.now();
  dynamic asyncDate;
  final double tablePadding = 7;
  final customDatePicker = CustomDatePicker();

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selected_date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(42, 54, 59, 1),
      ),
      body: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            child: ViewBookingsDateButton(
                text: DateFormat('d MMMM yyyy').format(selectedDate),
                onPressed: () async {
                  asyncDate = await customDatePicker.selectDate(context);
                  setState(() {
                    selectedDate = asyncDate == null ? selectedDate : asyncDate;
                  });
                }),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection(firestoreBookClubhouseCollection)
                  .orderBy('start_datetime', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(42, 54, 59, 1),
                    ),
                  );
                }

                // Extract the documents and display them in boxes
                final documents = snapshot.data!.docs;

                // Apply the name filter
                final filteredDocuments = documents.where((document) {
                  final data = document.data() as Map<String, dynamic>;
                  final name = DateFormat('d MMMM yyyy')
                      .format(DateTime.parse(data['start_datetime']));
                  return name
                      .toString()
                      .contains(DateFormat('d MMMM yyyy').format(selectedDate));
                }).toList();

                return ListView.builder(
                  itemCount: filteredDocuments.length,
                  itemBuilder: (context, index) {
                    final document = filteredDocuments[index];
                    final data = document.data() as Map<String, dynamic>;

                    return Column(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.95,
                          child: ViewBookingsOptionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ClubhouseBookingDetails(
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
                                                color: Color.fromRGBO(42, 54, 59, 1)),
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
                                                color: Color.fromRGBO(42, 54, 59, 1)),
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
                                    TableRow(children: [
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(tablePadding),
                                          child: const Text(
                                            'Occupants',
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
                                            data['occupants'].toString(),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ClubhouseBookingDetails extends StatefulWidget {
  final data;
  final DocumentReference bookingRef;
  final int villa_number;

  const ClubhouseBookingDetails(
      {super.key,
      required this.data,
      required this.villa_number,
      required this.bookingRef});

  @override
  _ClubhouseBookingDetails createState() => _ClubhouseBookingDetails();
}

class _ClubhouseBookingDetails extends State<ClubhouseBookingDetails> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(42, 54, 59, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  if (widget.villa_number == widget.data['villa_no']) {
                    setState(() {
                      isLoading = true;
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm delete'),
                          content:
                              const Text('Do you want to delete the booking?'),
                          actions: [
                            AcceptTextButton(
                              text: 'Yes',
                              onPressed: () async {
                                try {
                                  await widget.bookingRef.delete();
                                  debugPrint('Booking deleted successfully.');
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } catch (error) {
                                  debugPrint('Error deleting booking: $error');
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                            ),
                            RejectTextButton(
                              text: 'No',
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  ;
                },
                icon: Icon(
                  Icons.delete,
                  color: widget.villa_number == widget.data['villa_no']
                      ? Colors.white
                      : Colors.grey,
                )),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Villa Number:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(42, 54, 59, 1),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${widget.data['villa_no']}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Person Name:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(42, 54, 59, 1),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${widget.data['name']}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Phone Number:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(42, 54, 59, 1),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${widget.data['phone_number']}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Date:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(42, 54, 59, 1),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${DateFormat('d MMMM yyyy').format(DateTime.parse(widget.data['start_datetime']))}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Start Time:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(42, 54, 59, 1),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${DateFormat('h:mm a').format(DateTime.parse(widget.data['start_datetime']))}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'End time:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(42, 54, 59, 1),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${DateFormat('h:mm a').format(DateTime.parse(widget.data['end_datetime']))}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Reason for booking:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(42, 54, 59, 1),
                ),
              ),
              const SizedBox(height: 5),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Center(
                  child: Text(
                    '${widget.data['reason']}',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Number of Occupants:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(42, 54, 59, 1),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${widget.data['occupants']}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
