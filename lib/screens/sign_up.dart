import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/show_toast.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  String username = '';
  String password = '';
  String retypePassword = '';
  String selectedAccountType = 'Customer'; // Default selection

  Future<void> signUpAndAddToFirestore(
      String username, String password, String selectedAccountType) async {
    try {
      // Create the user in Firebase Authentication
      UserCredential authResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );
      User? user = authResult.user;

      // Create a reference to Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Add the user to the 'all_users' collection (if needed)
      await firestore.collection('all_users').doc(user!.uid).set({
        'accountType': selectedAccountType,
      });

      await firestore
          .collection('users')
          .doc(selectedAccountType)
          .set({'uid': user.uid});

      showToastMessage('Account created');
    } catch (e) {
      showToastMessage('Error creating account: $e');
    }
  }

  final List<String> accountTypes = [
    'Customer',
    'Shop Owner',
    'Security Officer'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup Page')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: 'Username'),
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Retype Password'),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  retypePassword = value;
                });
              },
            ),
            DropdownButtonFormField(
              value: selectedAccountType,
              onChanged: (value) {
                setState(() {
                  selectedAccountType = value.toString();
                });
              },
              items: accountTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                // Check for password match and handle signup logic here
                // Validate username and password
                if (username.isEmpty) {
                  showToastMessage('Username cannot be empty');
                } else if (password.isEmpty) {
                  showToastMessage('Password cannot be empty');
                } else if (password.length <= 6) {
                  showToastMessage(
                      'Password must be at least 7 characters long');
                } else if (password != retypePassword) {
                  showToastMessage('Passwords do not match');
                } else {
                  // Valid username and password, perform signup
                  signUpAndAddToFirestore(
                      username, password, selectedAccountType);
                }
              },
              child: const Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
