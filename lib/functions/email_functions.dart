import 'package:booking_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailFunctions {
  final smtpServer = gmail(smtpServerEmail, appPassword);

  Future<void> sendBookingConfirmationEmail(
    String facility,
    String recipientAddress,
    String bookingRef,
    String name,
    int phoneNumber,
    int villano,
    DateTime selectedStartingDateTime,
    DateTime selectedEndingDateTime,
    String additionalRequests,
  {
    String reason = '',
    int occupants = 0,
  }
  ) async {
    Message message = Message();
    if (reason == '' && occupants == 0) {
      message = Message()
        ..from = Address(smtpServerEmail, 'Dana Garden')
        ..recipients.add(recipientAddress)
        ..bccRecipients.add(smtpServerEmail)
        ..subject = '${facility.toUpperCase()} BOOKING CONFIRMATION (Reference: $bookingRef)'
        ..html = '''
          <p>Below are the details of your $facility booking:</p>
          <ul>
            <li>Villa Number: $villano
            <li>Name: $name
            <li>Phone Number: $phoneNumber
            <li>Date: ${DateFormat('d MMMM yyyy').format(DateTime.parse(selectedStartingDateTime.toString()))}
            <li>Time duration: ${DateFormat('h:mm a').format(DateTime.parse(selectedStartingDateTime.toString()))} to ${DateFormat('h:mm a').format(DateTime.parse(selectedEndingDateTime.toString()))}
        ''';
    } else {
      message = Message()
        ..from = Address(smtpServerEmail, 'Dana Garden')
        ..recipients.add(recipientAddress)
        ..bccRecipients.add(smtpServerEmail)
        ..subject = '${facility.toUpperCase()} BOOKING CONFIRMATION (Reference: $bookingRef)'
        ..html = '''
          <p>Below are the details of your $facility booking:</p>
          <ul>
            <li>Villa Number: $villano
            <li>Name: $name
            <li>Phone Number: $phoneNumber
            <li>Reason: $reason
            <li>Additional Requests: $additionalRequests
            <li>Occupants: $occupants
            <li>Date: ${DateFormat('d MMMM yyyy').format(DateTime.parse(selectedStartingDateTime.toString()))}
            <li>Time duration: ${DateFormat('h:mm a').format(DateTime.parse(selectedStartingDateTime.toString()))} to ${DateFormat('h:mm a').format(DateTime.parse(selectedEndingDateTime.toString()))}
        ''';
    }

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      debugPrint('Message not sent: $e');
    }
  }

  Future<void> sendBookingDeleteConfirmationEmail(
    String recipientAddress,
    String facility,
    String bookingRef,
    String name,
    int phoneNumber,
    int villano,
    String selectedStartingDateTime,
    String selectedEndingDateTime,
  ) async {
    final message = Message()
      ..from = Address(smtpServerEmail, 'Dana Garden')
      ..recipients.add(recipientAddress)
      ..bccRecipients.add(smtpServerEmail)
      ..subject = '${facility.toUpperCase()} BOOKING DELETED (Reference: $bookingRef)'
      ..html = '''
        <p>Below are the details of the deleted booking:</p>
        <ul>
          <li>Facility: $facility
          <li>Villa Number: $villano
          <li>Name: $name
          <li>Phone Number: $phoneNumber
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
      String description) async {
    final message = Message()
      ..from = Address(smtpServerEmail, 'Dana Garden')
      ..recipients.add(recipientAddress)
      ..bccRecipients.add(smtpServerEmail)
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
