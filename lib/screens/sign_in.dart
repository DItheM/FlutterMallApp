import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/show_toast.dart';
import 'customers.dart';
import 'owners.dart';
import 'security_officers.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';

  Future<String> signInWithUsernameAndPassword(
      String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve the user's account type from Firestore
      final user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection('users') // Change to your Firestore collection
          .doc(user!.uid)
          .get();
      final accountType = userData['accountType'];
      return accountType;
    } catch (e) {
      showToastMessage('Error signing in: $e');
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                setState(() {
                  email = value;
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
            ElevatedButton(
              onPressed: () {
                // Add login logic here
                if (email.isEmpty) {
                  showToastMessage('Email cannot be empty');
                } else if (password.isEmpty) {
                  showToastMessage('Password cannot be empty');
                } else if (password.length <= 6) {
                  showToastMessage(
                      'Password must be at least 7 characters long');
                } else {
                  String accountType =
                      signInWithUsernameAndPassword(email, password) as String;
                  // Navigate to the relevant screen based on the account type
                  if (accountType == 'Customer') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CustomerScreen(accountType: accountType),
                      ),
                    );
                  } else if (accountType == 'Shop Owner') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OwnerScreen(accountType: accountType),
                      ),
                    );
                  } else if (accountType == 'Security Officer') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SecurityOfficerScreen(accountType: accountType),
                      ),
                    );
                  }
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20), // Add some spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ),
                    );
                  },
                  child: const Text('Sign up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
