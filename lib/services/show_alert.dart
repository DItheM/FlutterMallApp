import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FirestoreDataListener {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BuildContext context;
  final String accountType;
  final String uid;
  bool canShow = false;
  int runTime = 60;

  late StreamSubscription<DocumentSnapshot> _subscription;

  FirestoreDataListener({
    required this.context,
    required this.accountType,
    required this.uid,
  });

  void startListening() {
    _subscription = _firestore
        .collection("latest_alarm")
        .doc("latest")
        .snapshots()
        .listen((event) {
      if (event.exists) {
        if (canShow) {
          final data = event.data() as Map<String, dynamic>;
          showDataUpdatedPopup(data);
        } else {
          canShow = true;
        }
      }
    });
  }

  void forSO(String msg, String floor, String section, String reporter) {
    Flushbar(
      messageText: Center(
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.warning,
              size: 100.0,
              color: Colors.red,
            ),
            const Text(
              'WARNING!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              msg,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.purple,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Floor: $floor',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Section: $section',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Reporter: $reporter',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      duration: Duration(seconds: runTime),
    ).show(context);
  }

  void forCus(String msg, String floor, String section) {
    Flushbar(
      messageText: Center(
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.warning,
              size: 100.0,
              color: Colors.red,
            ),
            const Text(
              'WARNING!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              msg,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.purple,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Floor: $floor',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Section: $section',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      'GET OUTSIDE!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      duration: Duration(seconds: runTime),
    ).show(context);
  }

  void showDataUpdatedPopup(Map<String, dynamic> updatedValue) {
    String f = "Fire Has Occurred";
    String c = "Criminal Activity Reported";

    String floor = updatedValue["floorName"];
    String section = updatedValue["sectionName"];
    String reporter = updatedValue["name"];

    if (accountType == "Security Officer" && updatedValue["uid"] != uid) {
      if (updatedValue["alarmType"] == "fire") {
        forSO(f, floor, section, reporter);
      } else {
        forSO(c, floor, section, reporter);
      }
    }

    if (accountType == "Shop Owner") {
      if (updatedValue["alarmType"] == "fire") {
        forSO(f, floor, section, reporter);
      } else {
        forSO(c, floor, section, reporter);
      }
    }

    if (accountType == "Customer") {
      if (updatedValue["alarmType"] == "fire") {
        forCus(f, floor, section);
      }
    }
  }

  void stopListening() {
    _subscription.cancel();
  }
}
