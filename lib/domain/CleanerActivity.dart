import 'package:cloud_firestore/cloud_firestore.dart';

class CleanerActivity {
  final String cleanerActivityID;
  final List<String> activityPhotos;
  final String additionalNotes;
  final String cleaningScheduleID;
  final String bookingID;
  final String jobID;

  CleanerActivity({
    required this.cleanerActivityID,
    required this.activityPhotos,
    required this.additionalNotes,
    required this.cleaningScheduleID,
    required this.bookingID,
    required this.jobID,
  });

  // Create a CleanerActivity from a Firebase snapshot
  factory CleanerActivity.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CleanerActivity(
      cleanerActivityID: snapshot.id,
      activityPhotos: List<String>.from(data['activityPhotos'] ?? []),
      additionalNotes: data['additionalNotes'] ?? '',
      cleaningScheduleID: data['cleaningScheduleID'],
      bookingID: data['bookingID'],
      jobID: data['jobID'],
    );
  }

  // Convert CleanerActivity to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'cleanerActivityID': cleanerActivityID,
      'activityPhotos': activityPhotos,
      'additionalNotes': additionalNotes,
      'cleaningScheduleID': cleaningScheduleID,
      'bookingID': bookingID,
      'jobID': jobID,
    };
  }
}
