import 'package:booking_app/functions/profile_functions.dart';
import 'package:flutter/material.dart';

class ProfileStatsPage extends StatefulWidget {
  final userDataList;

  const ProfileStatsPage({super.key, required this.userDataList});

  @override
  _ProfileStatsPageState createState() => _ProfileStatsPageState();
}

class _ProfileStatsPageState extends State<ProfileStatsPage> {
  final statisticsFunctions = StatisticsFunctions();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(42, 54, 59, 1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Number of users:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(42, 54, 59, 1),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.userDataList.length.toString(),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Time of last use:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(42, 54, 59, 1),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              child: FutureBuilder<String>(
                future: statisticsFunctions.getLastUsageTime(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('No usage data available');
                  } else {
                    final lastUsageTime = snapshot.data!;
                    return Text(lastUsageTime.substring(0, 16), style: const TextStyle(
                      fontSize: 18,
                    ),);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
