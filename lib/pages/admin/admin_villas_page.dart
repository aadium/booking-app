import 'package:flutter/material.dart';

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
        title: const Text('Admin Villas'),
      ),
      body: const Placeholder(),
    );
  }
}