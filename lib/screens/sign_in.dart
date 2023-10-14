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

  // Create TextEditingController for the email and password fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInWithUsernameAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve the user's account type from Firestore
      final user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection('all_users')
          .doc(user!.uid)
          .get();
      final accountType = userData['accountType'];
      final name = userData['name'];

      // Navigate to the relevant screen based on the account type
      if (context.mounted) {
        if (accountType == 'Customer') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerScreen(
                  accountType: accountType, name: name, uid: user.uid),
            ),
          );
        } else if (accountType == 'Shop Owner') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OwnerScreen(
                  accountType: accountType, name: name, uid: user.uid),
            ),
          );
        } else if (accountType == 'Security Officer') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SecurityOfficerScreen(
                  accountType: accountType, name: name, uid: user.uid),
            ),
          );
        }
      }
      showToastMessage("Logged in");

      // Clear the text fields
      emailController.clear();
      passwordController.clear();
    } catch (e) {
      showToastMessage('Error signing in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable the ability to go back from this screen
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Login'), automaticallyImplyLeading: false),
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
                    signInWithUsernameAndPassword(context, email, password);
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
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
