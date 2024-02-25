import 'package:booking_app/functions/email_functions.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:booking_app/widgets/textbuttons/secondary_text_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

// ignore: must_be_immutable
class SwimPoolBookingDetails extends StatefulWidget {
  final data;
  final DocumentReference bookingRef;
  final int villa_number;
  bool isUserInBookingHistory = false;

  SwimPoolBookingDetails(
      {super.key,
      required this.data,
      required this.villa_number,
      required this.bookingRef,
      this.isUserInBookingHistory = false});

  @override
  _SwimPoolBookingDetails createState() => _SwimPoolBookingDetails();
}

class _SwimPoolBookingDetails extends State<SwimPoolBookingDetails> {
  bool isLoading = false;
  String bookerName = '';
  String bookerEmailAddress = '';
  int bookerPhNo = 0;
  int bookerVilla = 0;
  String start_dt = '';
  String end_dt = '';

  final EmailFunctions emailFuncs = EmailFunctions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(42, 54, 59, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: widget.isUserInBookingHistory
                    ? null
                    : () {
                        if (widget.villa_number == widget.data['villa_no']) {
                          setState(() {
                            isLoading = true;
                          });
                          widget.bookingRef
                              .get()
                              .then((DocumentSnapshot bookingSnapshot) {
                            Map<String, dynamic> bookingData =
                                bookingSnapshot.data() as Map<String, dynamic>;
                            setState(() {
                              bookerName = bookingData['name'];
                              bookerEmailAddress = bookingData['email_address'];
                              bookerPhNo = bookingData['phone_number'];
                              bookerVilla = bookingData['villa_no'];
                              start_dt = bookingData['start_datetime'];
                              end_dt = bookingData['end_datetime'];
                            });
                            debugPrint(widget.bookingRef.id);
                          }).catchError((error) {
                            debugPrint('Error: $error');
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm delete'),
                                content: const Text(
                                    'Do you want to delete the booking?'),
                                actions: [
                                  PrimaryTextButton(
                                    text: 'Yes',
                                    onPressed: () async {
                                      try {
                                        await widget.bookingRef.delete();
                                        emailFuncs
                                            .sendBookingDeleteConfirmationEmail(
                                                bookerEmailAddress,
                                                'Swimming Pool',
                                                widget.bookingRef.id,
                                                bookerName,
                                                bookerPhNo,
                                                bookerVilla,
                                                start_dt,
                                                end_dt);
                                        debugPrint(
                                            'Booking deleted successfully.');
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      } catch (error) {
                                        debugPrint(
                                            'Error deleting booking: $error');
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
                  color: widget.villa_number == widget.data['villa_no'] &&
                          !widget.isUserInBookingHistory
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
            ],
          ),
        ),
      ),
    );
  }
}
