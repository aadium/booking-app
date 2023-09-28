import 'package:booking_app/constants.dart';
import 'package:booking_app/pages/book_clubhouse.dart';
import 'package:booking_app/widgets/textbuttons/accept_text_button.dart';
import 'package:booking_app/widgets/buttons/delete_button.dart';
import 'package:booking_app/widgets/textbuttons/reject_text_button.dart';
import 'package:booking_app/widgets/buttons/secondary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final double tablePadding = 7;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selected_date;
  }

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              color: Colors.black12,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: SecondaryButton(
                      text: 'Select Date',
                      onPressed: () => _selectDate(context)),
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat('d MMMM yyyy').format(selectedDate),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
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
                      color: Colors.black87,
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
                          widthFactor: 0.9,
                          child: ElevatedButton(
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
                            style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 15),
                                backgroundColor: Colors.white70,
                                disabledBackgroundColor: Colors.white54,
                                padding: EdgeInsets.all(10)),
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
                                                color: Colors.black),
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
                                                color: Colors.black),
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
                                                color: Colors.black),
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
                                                color: Colors.black),
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

  Future<void> deleteBooking(DocumentReference bookingRef) async {
    setState(() {
      isLoading = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm delete'),
          content: const Text('Do you want to delete the booking?'),
          actions: [
            AcceptTextButton(
              text: 'Yes',
              onPressed: () async {
                try {
                  await bookingRef.delete();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  if (widget.villa_number == widget.data['villa_no']) {
                    deleteBooking(widget.bookingRef);
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
                  color: Colors.black87,
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
                  color: Colors.black87,
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
                  color: Colors.black87,
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
                  color: Colors.black87,
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
                  color: Colors.black87,
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
                  color: Colors.black87,
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
                  color: Colors.black87,
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
                  color: Colors.black87,
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
