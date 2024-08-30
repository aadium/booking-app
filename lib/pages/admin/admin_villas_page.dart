import 'package:booking_app/constants/constants.dart';
import 'package:booking_app/pages/admin/admin_user_info.dart';
import 'package:booking_app/widgets/cards/AdminVillasCard.dart';
import 'package:booking_app/widgets/loaders/loader_1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'admin_registration_requests.dart';

class AdminVillasPage extends StatefulWidget {
  const AdminVillasPage({super.key});

  @override
  State<AdminVillasPage> createState() => _AdminVillasPageState();
}

class _AdminVillasPageState extends State<AdminVillasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: const Text('Villas')),
            IconButton(
              icon: const Icon(FontAwesomeIcons.bars),
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(110, 90, 0, 0),
                  items: [
                    PopupMenuItem(
                      value: 'registration_requests',
                      child: Text('Registration requests'),
                    ),
                  ],
                ).then((value) {
                  if (value == 'registration_requests') {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AdminRegistrationRequestsPage(),
                    ));
                  }
                });
              },
            )
          ],
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection(firestoreVillaUsersCollection).orderBy('Villa_num', descending: false).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final documents = snapshot.data!.docs;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic>? data = documents[index].data() as Map<String, dynamic>?;
                  return AdminVillasCard(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdminUserInfoPage(   
                          villaNumber: int.parse(data['Villa_num'].toString()),
                          userDataList: data['userMaps'],
                        ),
                      ));
                    },
                    child:
                      Text(
                        data!['Villa_num'].toString(),
                        style: const TextStyle(fontSize: 60, fontWeight:
                        FontWeight.bold, color: Color.fromRGBO(42, 54, 59, 1)),
                      ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(child: Loader1());
            }
          },
        ),
      ),
    );
  }
}
