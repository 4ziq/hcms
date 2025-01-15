import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hcms/domain/CleanerActivity.dart';
import 'TaskDetailPage.dart'; // Import TaskDetailPage

class CleanerActivityListPage extends StatelessWidget {
  const CleanerActivityListPage({Key? key}) : super(key: key);

  Future<List<CleanerActivity>> fetchCleanerActivities() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('CleanerActivities') // Ensure this matches your collection name
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return CleanerActivity(
        cleanerActivityID: doc.id,
        activityPhotos: List<String>.from(data['activityPhotos'] ?? []),
        additionalNotes: data['additionalNotes'] ?? '',
        cleaningScheduleID: data['cleaningScheduleID'],
        bookingID: data['bookingID'],
        jobID: data['jobID'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Activity'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<CleanerActivity>>(
        future: fetchCleanerActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load activities'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No activities available'));
          }

          final activities = snapshot.data!;
          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Homestay: ${activity.bookingID}', // Placeholder for homestay name
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Task: ${activity.additionalNotes}', // Placeholder for task description
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Total Payment: RM 20', // Placeholder for payment
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailPage(cleanerActivityID: activity.cleanerActivityID),
                          ),
                        );
                      },
                      child: const Text('Update Activity'),
                    ),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
