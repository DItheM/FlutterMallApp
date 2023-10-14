import 'package:app_mall/services/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/show_alert.dart';
import 'set_alarm.dart';
import 'sign_in.dart';

class OwnerScreen extends StatefulWidget {
  final String accountType;
  final String name;
  final String uid;

  const OwnerScreen(
      {super.key,
      required this.accountType,
      required this.name,
      required this.uid});

  @override
  OwnerScreenState createState() => OwnerScreenState();
}

class OwnerScreenState extends State<OwnerScreen> {
  late FirestoreDataListener listener;

  @override
  void initState() {
    super.initState();
    listener = FirestoreDataListener(
        context: context, accountType: widget.accountType, uid: widget.uid);
    listener.startListening();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable the back button
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          automaticallyImplyLeading: false, // Hide the back button
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  listener.stopListening();
                  showToastMessage('Logged out');
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  }
                } catch (e) {
                  showToastMessage('Error logging out: $e');
                }
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Account Type: ${widget.accountType}",
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                "User Name: ${widget.name}",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // Criminal activity alarm button
              Container(
                width: 170, // Set a fixed width
                height: 110,
                padding: const EdgeInsets.all(10), // Add padding
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlarmScreen(
                          alarmType: "criminal",
                          icon: Icons.security,
                          screenTitle: "Criminal Alarm",
                          uid: widget.uid,
                          name: widget.name,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.security, size: 50), // Security icon
                        SizedBox(height: 8), // Add vertical spacing
                        Text('Set Criminal Alarm'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
