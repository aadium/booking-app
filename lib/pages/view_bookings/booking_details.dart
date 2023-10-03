import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:booking_app/widgets/textbuttons/secondary_text_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
                            PrimaryTextButton(
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
                            SecondaryTextButton(
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
