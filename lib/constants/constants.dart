import 'package:flutter_dotenv/flutter_dotenv.dart';

const List<String> timeList = [
  '12:00 AM',
  '1:00 AM',
  '2:00 AM',
  '3:00 AM',
  '4:00 AM',
  '5:00 AM',
  '6:00 AM',
  '7:00 AM',
  '8:00 AM',
  '9:00 AM',
  '10:00 AM',
  '11:00 AM',
  '12:00 PM',
  '1:00 PM',
  '2:00 PM',
  '3:00 PM',
  '4:00 PM',
  '5:00 PM',
  '6:00 PM',
  '7:00 PM',
  '8:00 PM',
  '9:00 PM',
  '10:00 PM',
  '11:00 PM'
];

const String firestoreBookClubhouseCollection = 'book_clubhouse';
const String firestoreBookTennisCourtCollection = 'book_tennis_court';
const String firestoreBookSwimPoolCollection = 'book_swim_pool';
const String firestoreBookSquashCourtCollection = 'book_squash_court';
const String firestoreMaintenanceRequestsCollection = 'maintenance_requests';
const String firestoreVillaUsersCollection = 'villa_users';
const String firestoreRegistrationRequestsCollection = 'register_requests';
const String adminServerUrl = 'https://booking-app-95z3.onrender.com/';
String smtpServerEmail = dotenv.env['smtpServerEmail']!;
String appPassword = dotenv.env['appPassword']!;