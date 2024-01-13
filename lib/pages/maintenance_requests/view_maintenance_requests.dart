import 'package:booking_app/functions/maintenance_request_functions.dart';
import 'package:booking_app/widgets/buttons/tertiary_button.dart';
import 'package:booking_app/widgets/loaders/loader_1.dart';
import 'package:flutter/material.dart';

class ViewMaintenanceRequests extends StatefulWidget {
  final int villaNum;
  ViewMaintenanceRequests({super.key, required this.villaNum});

  @override
  _ViewMaintenanceRequests createState() => _ViewMaintenanceRequests();
}

class _ViewMaintenanceRequests extends State<ViewMaintenanceRequests> {
  int villaNum = 0;
  dynamic asyncDate;
  final double tablePadding = 7;
  final maintenanceRequestFunctions = MaintenanceRequestFunctions();

  List complaints = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    villaNum = widget.villaNum;
    _fetchData(villaNum);
  }

  Future<void> _fetchData(int villaNum) async {
    final List fetchedComplaints =
        await maintenanceRequestFunctions.fetchMaintenanceRequestsByVilla(villaNum, true);
    setState(() {
      complaints = fetchedComplaints;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(42, 54, 59, 1),
        title: Text('Your requests'),
      ),
      body: isLoading
          ? Center(
              child: Loader1()
            )
          :  Column(
        children: [
          const SizedBox(height: 10,),
          Expanded(
              child: ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final document = complaints[index];
              final data = document.data() as Map<String, dynamic>;

              return Column(
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.95,
                    child: TertiaryButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Table(
                            columnWidths: const {
                              0: FixedColumnWidth(
                                  170), // Adjusts width based on content
                              1: FixedColumnWidth(170),
                            },
                            children: [
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: const Text(
                                      'Issue',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(42, 54, 59, 1)),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: Text(
                                      data['issue'],
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: const Text(
                                      'Description',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(42, 54, 59, 1)),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: Text(
                                      data['description'],
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: const Text(
                                      'Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(42, 54, 59, 1)),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(tablePadding),
                                    child: Text(
                                      data['date'],
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                )
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          )),
        ],
      ),
    );
  }
}
