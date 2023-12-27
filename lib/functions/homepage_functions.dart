import 'package:booking_app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePageFunctions {
  Future<List> FetchVillaData(User user) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(firestoreVillaUsersCollection)
        .get();

    var docs = snapshot.docs.where((doc) {
      List userMaps = doc.data()['userMaps'];
      return userMaps.any((userMap) => userMap['email'] == user.email);
    }).toList();

    if (docs.isNotEmpty) {
      int villaNumber = docs.first.data()['Villa_num'];
      List<dynamic> userMaps = docs.first.data()['userMaps'];
      return [villaNumber, userMaps];
    } else {
      throw Exception('No documents found');
    }
  }
}
