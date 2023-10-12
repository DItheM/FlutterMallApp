import 'package:app_mall/services/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OwnerScreen extends StatelessWidget {
  final String accountType;

  const OwnerScreen({super.key, required this.accountType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Information'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                showToastMessage('Logged out');
                // Navigate to the login or splash screen after logout
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
            const Text(
              'Account Type:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "User Type: $accountType",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
