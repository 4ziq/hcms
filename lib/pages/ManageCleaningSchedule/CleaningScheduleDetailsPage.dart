import 'package:flutter/material.dart';

class CleaningScheduleDetailsPage extends StatelessWidget {
  final Map<String, dynamic> job;

  const CleaningScheduleDetailsPage({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildJobInfo("Date", job['date']),
            _buildJobInfo("Time", job['time']),
            _buildJobInfo("Homestay Address", job['address']),
            _buildJobInfo("Description", job['description']),
            const SizedBox(height: 20),
            _buildJobStatus(context),
          ],
        ),
      ),
    );
  }

  Widget _buildJobInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobStatus(BuildContext context) {
    String status = job['status'];
    String buttonText = "On The Way";

    if (status == "Waiting") {
      buttonText = "On The Way";
    } else if (status == "On The Way") {
      buttonText = "Start";
    } else if (status == "In Progress") {
      buttonText = "Complete";
    }

    return ElevatedButton(
      onPressed: () {
        // Handle status update logic
      },
      child: Text(buttonText),
    );
  }
}
