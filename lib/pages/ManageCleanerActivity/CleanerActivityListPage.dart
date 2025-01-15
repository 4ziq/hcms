import 'package:flutter/material.dart';
import 'TaskDetailPage.dart';

class CleanerActivityListPage extends StatelessWidget {
  final List<Map<String, dynamic>> activities = [
    {
      "taskId": 1,
      "taskDescription": "Clean living room",
      "status": "Pending",
      "date": "07/01/2025",
    },
    {
      "taskId": 2,
      "taskDescription": "Clean kitchen",
      "status": "In Progress",
      "date": "08/01/2025",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cleaner Activities'),
      ),
      body: activities.isEmpty
          ? const Center(child: Text('No Activities Found'))
          : ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(activity['taskDescription']),
                    subtitle: Text("Status: ${activity['status']} | Date: ${activity['date']}"),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailPage(activity: activity),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
