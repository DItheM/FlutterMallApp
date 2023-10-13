import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  final String uid;
  final String screenTitle;
  final IconData icon;

  const AlarmScreen({
    Key? key,
    required this.uid,
    required this.screenTitle,
    required this.icon,
  }) : super(key: key);

  @override
  AlarmScreenState createState() => AlarmScreenState();
}

class AlarmScreenState extends State<AlarmScreen> {
  String selectedFloor = '';
  String selectedSection = '';

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
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                hint: const Text("Select Section"),
                items: ["A", "B", "C", "D", "E"]
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
