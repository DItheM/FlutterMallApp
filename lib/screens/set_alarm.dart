import 'package:flutter/material.dart';

class AlarmScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 100),
            const SizedBox(height: 20), // Add some spacing

            // Dropdown for selecting the floor
            DropdownButton<String>(
              hint: const Text("Select Floor"),
              items: ["Floor 1", "Floor 2", "Floor 3"]
                  .map((floor) => DropdownMenuItem<String>(
                        value: floor,
                        child: Text(floor),
                      ))
                  .toList(),
              onChanged: (selectedFloor) {
                // Handle floor selection
              },
            ),

            // Dropdown for selecting the section
            DropdownButton<String>(
              hint: const Text("Select Section"),
              items: ["A", "B", "C", "D", "E"]
                  .map((section) => DropdownMenuItem<String>(
                        value: section,
                        child: Text(section),
                      ))
                  .toList(),
              onChanged: (selectedSection) {
                // Handle section selection
              },
            ),

            const SizedBox(height: 20), // Add some spacing

            // Cancel button
            ElevatedButton(
              onPressed: () {
                // Navigate back when Cancel button is pressed
                Navigator.pop(context);
              },
              // style: ElevatedButton.styleFrom(primary: Colors.red),
              child: const Text("Cancel"),
            ),

            // Send Alarm button
            ElevatedButton(
              onPressed: () {
                // Implement the logic to send the alarm
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Send Alarm"),
            ),
          ],
        ),
      ),
    );
  }
}
