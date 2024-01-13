import 'package:booking_app/functions/maintenance_request_functions.dart';
import 'package:booking_app/pages/maintenance_requests/register_maintenance_request.dart';
import 'package:booking_app/widgets/buttons/primary_button.dart';
import 'package:booking_app/widgets/buttons/tertiary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MaintenanceRequestsPage extends StatefulWidget {
  final User user;
  final int villaNumber;
  final List userData;
  const MaintenanceRequestsPage(
      {super.key,
      required this.user,
      required this.villaNumber,
      required this.userData});
  @override
  _MaintenanceRequestsPageState createState() =>
      _MaintenanceRequestsPageState();
}

class _MaintenanceRequestsPageState extends State<MaintenanceRequestsPage> {
  int villaNum = 0;
  dynamic asyncDate;
  final double tablePadding = 7;
  final maintenanceRequestFunctions = MaintenanceRequestFunctions();

  List requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    villaNum = widget.villaNumber;
    _fetchData(villaNum);
  }

  Future<void> _fetchData(int villaNum) async {
    final List fetchedRequests = await maintenanceRequestFunctions
        .fetchMaintenanceRequestsByVilla(villaNum, true);
    setState(() {
      requests = fetchedRequests;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int villaNumber = widget.villaNumber;
    List userData = widget.userData;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(42, 54, 59, 1),
          automaticallyImplyLeading: false,
          title: Center(
            child: Text('Your Maintenance Requests'),
          )),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Expanded(
                child: ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final document = requests[index];
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
                                            color:
                                                Color.fromRGBO(42, 54, 59, 1)),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(tablePadding),
                                      child: Text(
                                        data['issue'],
                                        style: const TextStyle(
                                            color: Colors.black),
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
                                            color:
                                                Color.fromRGBO(42, 54, 59, 1)),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(tablePadding),
                                      child: Text(
                                        data['description'],
                                        style: const TextStyle(
                                            color: Colors.black),
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
                                            color:
                                                Color.fromRGBO(42, 54, 59, 1)),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(tablePadding),
                                      child: Text(
                                        data['date'],
                                        style: const TextStyle(
                                            color: Colors.black),
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
            const SizedBox(height: 70)
          ],
        ),
      ),
      bottomSheet: Container(
        height: 70,
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.95,
            child: PrimaryButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterMaintenanceRequest(
                      villaNum: villaNumber,
                      userDataList: userData,
                    ),
                  ),
                );
              },
              text: 'Request Maintenance'
            ),
          ),
        ),
      ),
    );
  }
}
