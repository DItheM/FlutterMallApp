import 'package:app_mall/services/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'sign_in.dart';

class OwnerScreen extends StatelessWidget {
  final String accountType;
  final String name;
  final String uid;

  const OwnerScreen(
      {super.key,
      required this.accountType,
      required this.name,
      required this.uid});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable the back button
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account Information'),
          automaticallyImplyLeading: false, // Hide the back button
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
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
                "Account Type: $accountType",
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                "User Name: $name",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
