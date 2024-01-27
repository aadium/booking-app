import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminVillasPage extends StatefulWidget {
  const AdminVillasPage({Key? key}) : super(key: key);

  @override
  State<AdminVillasPage> createState() => _AdminVillasPageState();
}

class _AdminVillasPageState extends State<AdminVillasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Villas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('villa_users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic>? data = documents[index].data() as Map<String, dynamic>?;
                return ListTile(
                  title: Text(data!['Villa_num'].toString()),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}