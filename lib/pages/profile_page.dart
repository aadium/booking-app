import 'package:booking_app/constants.dart';
import 'package:booking_app/widgets/labels/dialog_box_notice.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller.dart';
import 'package:booking_app/widgets/textboxes/text_box_wcontroller_numeric.dart';
import 'package:booking_app/widgets/textbuttons/accept_text_button.dart';
import 'package:booking_app/widgets/textbuttons/primary_text_button.dart';
import 'package:booking_app/widgets/textbuttons/reject_text_button.dart';
import 'package:booking_app/widgets/buttons/secondary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final User? user = FirebaseAuth.instance.currentUser;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ProfilePage extends StatefulWidget {
  final int villaNumber;
  final List<dynamic> userDataList; // Pass a list of user data maps

  const ProfilePage({
    Key? key,
    required this.villaNumber,
    required this.userDataList,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void AddUser() {
    TextEditingController newNameController = TextEditingController();
    TextEditingController newPhoneNumberController = TextEditingController();
    TextEditingController newEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add another user'),
          content: SizedBox(
            height: 230,
            child: Column(
              children: [
                CustomTextFieldWController(
                  labelText: 'Enter name',
                  controller: newNameController,
                ),
                CustomNumericTextFieldWController(
                  labelText: 'Enter phone number',
                  controller: newPhoneNumberController,
                ),
                CustomTextFieldWController(
                  labelText: 'Enter email ID',
                  controller: newEmailController,
                ),
                const SizedBox(height: 20,),
                DialogBoxNotice(labelText: 'Changes will be reflected the next time you login')
              ],
            ),
          ),
          actions: [
            AcceptTextButton(
              text: 'Add user',
              onPressed: () async {
                String newName = newNameController.text;
                String newPhoneNumber = newPhoneNumberController.text;
                String newEmail = newEmailController.text;

                Map<String, dynamic> userData = {
                  'name': newName,
                  'phoneNum': newPhoneNumber,
                  'email': newEmail,
                };

                QuerySnapshot<Map<String, dynamic>> snapshot =
                    await FirebaseFirestore.instance
                        .collection(firestoreVillaUsersCollection)
                        .where('Villa_num', isEqualTo: widget.villaNumber)
                        .get();

                if (snapshot.docs.isNotEmpty) {
                  DocumentSnapshot<Map<String, dynamic>> userDoc =
                      snapshot.docs.first;

                  String documentId = userDoc.id;

                  await _firestore
                      .collection(firestoreVillaUsersCollection)
                      .doc(documentId)
                      .update({
                    'userMaps': FieldValue.arrayUnion([userData])
                  });
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Success'),
                        content: Text('$newName had been added.'),
                        actions: [
                          PrimaryTextButton(
                            text: 'OK',
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Failure to add user'),
                        content: Text('$newName could not be added.'),
                        actions: [
                          PrimaryTextButton(
                            text: 'OK',
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            RejectTextButton(
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Villa Number:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.villaNumber.toString(),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'User Information:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: IntrinsicColumnWidth(), // Adjusts width based on content
                  1: IntrinsicColumnWidth(),
                  2: IntrinsicColumnWidth(),
                },
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(8.0), // Add cell padding
                          child: Center(
                            child: Text(
                              'Name',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(8.0), // Add cell padding
                          child: Center(
                            child: Text(
                              'Phone Number',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(8.0), // Add cell padding
                          child: Center(
                            child: Text(
                              'Email',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (final userData in widget.userDataList)
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(8.0), // Add cell padding
                            child: Center(
                              child: Text(
                                userData['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(8.0), // Add cell padding
                            child: Center(
                              child: Text(
                                userData['phoneNum'].toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(8.0), // Add cell padding
                            child: Center(
                              child: Text(
                                userData['email'],
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SecondaryButton(text: 'Add User', onPressed: () => AddUser())
          ],
        ),
      ),
    );
  }
}
