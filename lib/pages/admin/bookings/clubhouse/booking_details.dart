import 'package:booking_app/functions/email_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

// ignore: must_be_immutable
class AdminClubhouseBookingDetails extends StatefulWidget {
  final data;
  final DocumentReference bookingRef;
  bool isUserInBookingHistory = false;

  AdminClubhouseBookingDetails(
      {super.key,
      required this.data,
      required this.bookingRef,
      this.isUserInBookingHistory = false});

  @override
  _AdminClubhouseBookingDetails createState() => _AdminClubhouseBookingDetails();
}

class _AdminClubhouseBookingDetails extends State<AdminClubhouseBookingDetails> {
  bool isLoading = false;
  late String bookerName;
  late String bookerEmailAddress;
  late int bookerPhNo;
  late int bookerVilla;
  late String reason;
  late String start_dt;
  late String end_dt;

  final EmailFunctions emailFuncs = EmailFunctions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(42, 54, 59, 1),
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
