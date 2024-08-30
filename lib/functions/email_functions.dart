import 'package:booking_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> sendRegistrationRequestEmail(
      int villaNumber,
      String name,
      int phoneNumber,
      String email) async {
    final response = await http.get(
        Uri.parse('${adminServerUrl}api/auth/getAllAdminEmails'));

    if (response.statusCode == 200) {
      try {
        final adminEmails = jsonDecode(response.body);
        final message = Message()
          ..from = Address(smtpServerEmail, 'Dana Garden')
          ..recipients.addAll(adminEmails)
          ..subject = 'USER REGISTRATION REQUEST (VILLA NUMBER: $villaNumber)'
          ..html = '''
            <p>Below are the user details:</p>
            <ul>
              <li>Villa Number: $villaNumber</li>
              <li>Name: $name</li>
              <li>Phone Number: $phoneNumber</li>
              <li>Email: $email</li>
            </ul>
          ''';

        try {
          await send(message, smtpServer);
        } on MailerException catch (e) {
          debugPrint('Message not sent: $e');
        }
      } catch (e) {
        debugPrint('Failed to decode JSON: $e');
      }
    } else {
      debugPrint('Request failed with status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
    }
  }

  Future<void> sendAccountCreationEmail(
      String adminEmail,
      String adminName,
      String name,
      String email,
      int phoneNumber,
      String password) async {
    final message = Message()
      ..from = Address(adminEmail, adminName)
      ..recipients.add(email)
      ..subject = 'ACCOUNT CREATED'
      ..html = '''
        <p>Dear $name,</p>
        <p>Below are your account details:</p>
        <hr/>
        <p>Name: $name</p>
        <p>Email: $email</p>
        <p>Phone Number: $phoneNumber</p>
        <p>Password: $password</p>
        <hr/>
        <p>Kindly change your password after logging in.</p>
        <p>With Regards,</p>
        <p>$adminName</p>
      ''';

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      debugPrint('Message not sent: $e');
    }
  }
}
