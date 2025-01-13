import 'package:flutter/material.dart';

class Job {
  final String JobID;
  final String JobStatus;
  final String DeclineReason;
  final double CalculatedRate;
  final String CleanerID;
  final String BookingID;

  Job({
    required this.JobID,
    required this.JobStatus,
    required this.DeclineReason,
    required this.BookingID,
    required this.CalculatedRate,
    required this.CleanerID,
  });

  // Convert Booking to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'JobID': JobID,
      'JobStatus': JobStatus,
      'DeclineReason': DeclineReason,
      'CleanerID': CleanerID,
      'BookingID': BookingID,
      'CalculatedRate' : CalculatedRate,
    };
  }

  // Create a Booking from a Firebase snapshot
  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      JobID: map['JobID'],
      JobStatus: map['JobStatus'],
      DeclineReason: map['DeclineReason'],
      CleanerID: map['CleanerID'],
      BookingID: map['BookingID'],
      CalculatedRate: map['CalculatedRate'],
    );
  }
}
