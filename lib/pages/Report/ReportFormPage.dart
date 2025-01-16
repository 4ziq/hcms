import 'package:flutter/material.dart';

class ReportDetailPage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const ReportDetailPage({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    final photos = bookingData['activityPhotos'] as List<dynamic>;
    final cleanerInfo = bookingData['cleanerInfo'] as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${bookingData['BookingDate']}'),
              Text(
                  'Time: ${bookingData['BookingStartTime']} - ${bookingData['BookingEndTime']}'),
              Text('Duration: ${bookingData['duration']} Hours'),
              const SizedBox(height: 16.0),
              const Text('Description:'),
              Text(bookingData['BookingTaskDescription']),
              const SizedBox(height: 16.0),
              Text('Total: RM ${bookingData['CalculatedRate']}'),
              const SizedBox(height: 16.0),
              const Text('Photos:'),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: photos
                    .map((photoUrl) => Image.network(
                          photoUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16.0),
              const Text('Additional Notes:'),
              Text(bookingData['additionalNotes']),
              const SizedBox(height: 16.0),
              const Text('Cleaner Information:'),
              ListTile(
                // leading: CircleAvatar(
                //   backgroundImage:
                //       NetworkImage(cleanerInfo['CleanerProfilePic']),
                // ),
                title: Text(cleanerInfo['CleanerName']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone: ${cleanerInfo['CleanerPhoneNum']}'),
                    Text('Email: ${cleanerInfo['CleanerEmail']}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
