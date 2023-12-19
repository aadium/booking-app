import 'package:booking_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailFunctions {
  final smtpServer = gmail(firestoreSignInEmail, appPassword);

  Future<void> sendBookingConfirmationEmail(
    String recipientAddress,
    String bookingRef,
    String name,
    int phoneNumber,
    int villano,
    String reason,
    int occupants,
    String additionalRequests,
    DateTime selectedStartingDateTime,
    DateTime selectedEndingDateTime,
  ) async {
    final message = Message()
      ..from = Address(firestoreSignInEmail, 'Dana Garden')
      ..recipients.add(recipientAddress)
      ..bccRecipients.add(firestoreSignInEmail)
      ..subject = 'BOOKING CONFIRMATION (Reference: $bookingRef)'
      ..html = '''
        <p>Below are the details of your booking:</p>
        <ul>
          <li>Villa Number: $villano
          <li>Name: $name
          <li>Phone Number: $phoneNumber
          <li>Reason: $reason
          <li>Occupants: $occupants
          <li>Additional Requests: $additionalRequests
          <li>Date: ${DateFormat('d MMMM yyyy').format(DateTime.parse(selectedStartingDateTime.toString()))}
          <li>Time duration: ${DateFormat('h:mm a').format(DateTime.parse(selectedStartingDateTime.toString()))} to ${DateFormat('h:mm a').format(DateTime.parse(selectedEndingDateTime.toString()))}
      ''';

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      debugPrint('Message not sent: $e');
    }
  }

  Future<void> sendBookingDeleteConfirmationEmail(
    String recipientAddress,
    String bookingRef,
    String name,
    int phoneNumber,
    int villano,
    String reason,
    String selectedStartingDateTime,
    String selectedEndingDateTime,
  ) async {
    final message = Message()
      ..from = Address(firestoreSignInEmail, 'Dana Garden')
      ..recipients.add(recipientAddress)
      ..bccRecipients.add(firestoreSignInEmail)
      ..subject = 'BOOKING DELETED (Reference: $bookingRef)'
      ..html = '''
        <p>Below are the details of the deleted booking:</p>
        <ul>
          <li>Villa Number: $villano
          <li>Name: $name
          <li>Phone Number: $phoneNumber
          <li>Reason for Booking: $reason
          <li>Date: ${DateFormat('d MMMM yyyy').format(DateTime.parse(selectedStartingDateTime))}
          <li>Time duration: ${DateFormat('h:mm a').format(DateTime.parse(selectedStartingDateTime))} to ${DateFormat('h:mm a').format(DateTime.parse(selectedEndingDateTime.toString()))}
      ''';

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      debugPrint('Message not sent: $e');
    }
  }

  Future<void> sendComplaintConfirmationEmail(
    String recipientAddress,
    String complaintRef,
    String name,
    int phoneNumber,
    int villano,
    String issue,
    String description
  ) async {
    final message = Message()
      ..from = Address(firestoreSignInEmail, 'Dana Garden')
      ..recipients.add(recipientAddress)
      ..bccRecipients.add(firestoreSignInEmail)
      ..subject = 'Complaint registered (Reference: $complaintRef)'
      ..html = '''
        <p>Below are the details of the registered complaint:</p>
        <ul>
          <li>Villa Number: $villano
          <li>Name: $name
          <li>Phone Number: $phoneNumber
          <li>Issue: $issue
          <li>Description: $description
      ''';

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      debugPrint('Message not sent: $e');
    }
  }
}