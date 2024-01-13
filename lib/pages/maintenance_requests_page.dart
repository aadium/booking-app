import 'package:booking_app/pages/maintenance_requests/register_maintenance_request.dart';
import 'package:booking_app/pages/maintenance_requests/view_maintenance_requests.dart';
import 'package:booking_app/widgets/buttons/HomePage_option_button.dart';
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
            child: Text('Dana Garden'),
          )),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            FractionallySizedBox(
              widthFactor: 0.95,
              child: HomepageOptionButton(
                text: 'Request Maintenance',
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
              ),
            ),
            const SizedBox(height: 10),
            FractionallySizedBox(
              widthFactor: 0.95,
              child: HomepageOptionButton(
                text: 'View your Requests',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewMaintenanceRequests(
                        villaNum: villaNumber,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
