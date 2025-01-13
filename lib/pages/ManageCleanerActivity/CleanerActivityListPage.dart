import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hcms/provider/CleanerActivityController.dart';
import 'TaskDetailPage.dart';

class CleanerActivityListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cleanerActivityController =
        Provider.of<CleanerActivityController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Activity'),
        centerTitle: true,
      ),
      body: cleanerActivityController.tasks.isEmpty
          ? const Center(
              child: Text('No Activities Found'),
            )
          : ListView.builder(
              itemCount: cleanerActivityController.tasks.length,
              itemBuilder: (context, index) {
                final activity = cleanerActivityController.tasks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.blueAccent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${activity['date']}   ${activity['time']}",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            activity['homestay'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            activity['description'],
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Payment: ${activity['payment']}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TaskDetailPage(activity: activity),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Update Activity",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cleanerActivityController.addTask({
            "date": "20/01/2025",
            "time": "1:00 PM - 3:00 PM",
            "homestay": "NEW HOMESTAY",
            "description": "Added via Provider.",
            "payment": "RM 30",
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
