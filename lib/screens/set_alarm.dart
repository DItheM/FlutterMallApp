import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/show_toast.dart';

class AlarmScreen extends StatefulWidget {
  final String uid;
  final String alarmType;
  final IconData icon;
  final String name;
  final String screenTitle;

  const AlarmScreen({
    Key? key,
    required this.uid,
    required this.alarmType,
    required this.icon,
    required this.name,
    required this.screenTitle,
  }) : super(key: key);

  @override
  AlarmScreenState createState() => AlarmScreenState();
}

class AlarmScreenState extends State<AlarmScreen> {
  String selectedFloor = '';
  String selectedSection = '';
  String pageTitle = '';

  //method to set alarm
  //update data to the firestore db
  //after set alarm, go back
  Future<void> setAlarm(String floorName, String sectionName) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      //get the alarm id
      String key = firestore.collection('alarms').doc().id;

      await firestore.collection('alarms').doc(key).set({
        'alarmType': widget.alarmType,
        'name': widget.name,
        'uid': widget.uid,
        'floorName': selectedFloor,
        'sectionName': selectedSection,
      });

      await firestore.collection('latest_alarm').doc("latest").set({
        'alarmType': widget.alarmType,
        'name': widget.name,
        'uid': widget.uid,
        'floorName': selectedFloor,
        'sectionName': selectedSection,
        'alarmId': key,
      });

      showToastMessage('Alarm sent');
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      showToastMessage('Error sending alarm: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.screenTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              widget.icon,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 20), // Add some spacing

            // Dropdown for selecting the floor
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropdownButtonFormField<String>(
                hint: const Text("Select Floor"),
                items: ["Floor 1", "Floor 2", "Floor 3"]
                    .map((floor) => DropdownMenuItem<String>(
                          value: floor,
                          child: Text(floor),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFloor = value.toString();
                  });
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropdownButtonFormField<String>(
                hint: const Text("Select Section"),
                items: [
                  "Section A",
                  "Section B",
                  "Section C",
                  "Section D",
                  "Section E"
                ]
                    .map((section) => DropdownMenuItem<String>(
                          value: section,
                          child: Text(section),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSection = value.toString();
                  });
                },
              ),
            ),

            const SizedBox(height: 20), // Add some spacing

            // Row with Cancel and Send Alarm buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Navigate back when Cancel button is pressed
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 16), // Add spacing between the buttons
                ElevatedButton(
                  onPressed: () {
                    // Implement the logic to send the alarm
                    if (selectedFloor.isEmpty) {
                      showToastMessage("Floor can't be empty");
                    } else if (selectedSection.isEmpty) {
                      showToastMessage("Selection can't be empty");
                    } else {
                      setAlarm(selectedFloor, selectedSection);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Send Alarm"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
