import 'package:booking_app/functions/profile_functions.dart';
import 'package:booking_app/widgets/buttons/secondary_button.dart';
import 'package:booking_app/widgets/buttons/secondary_icon_button.dart';
import 'package:flutter/material.dart';

class ProfileStatsPage extends StatefulWidget {
  final userDataList;

  const ProfileStatsPage({super.key, required this.userDataList});

  @override
  _ProfileStatsPageState createState() => _ProfileStatsPageState();
}

class _ProfileStatsPageState extends State<ProfileStatsPage> {
  final profileInfoFunctions = ProfileInfoFunctions();
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
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SecondaryIconButton(iconData: Icons.location_pin, onPressed: () => profileInfoFunctions.showLocation()),
                const SizedBox(width: 10,),
                SecondaryIconButton(iconData: Icons.call_rounded, onPressed: () => profileInfoFunctions.showLocation()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
