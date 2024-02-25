import 'package:booking_app/functions/email_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

// ignore: must_be_immutable
class AdminSwimPoolBookingDetails extends StatefulWidget {
  final data;
  final DocumentReference bookingRef;
  bool isUserInBookingHistory = false;

  AdminSwimPoolBookingDetails(
      {super.key,
      required this.data,
      required this.bookingRef,
      this.isUserInBookingHistory = false});

  @override
  _AdminSwimPoolBookingDetails createState() => _AdminSwimPoolBookingDetails();
}

class _AdminSwimPoolBookingDetails extends State<AdminSwimPoolBookingDetails> {
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
