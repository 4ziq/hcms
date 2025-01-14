import 'package:flutter/material.dart';

class Cleaningschedule {
  final String CleaningscheduleID;
  final double DailyEarning;
  final String CleanerID;
  final String JobID;

  Cleaningschedule({
    required this.CleaningscheduleID,
    required this.DailyEarning,
    required this.CleanerID,
    required this.JobID,
  });

  // Convert Cleaningschedule to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'CleaningscheduleID': CleaningscheduleID,
      'DailyEarning': DailyEarning,
      'CleanerID': CleanerID,
      'JobID': JobID,
    };
  }

  // Create a Cleaningschedule from a Firebase snapshot
  factory Cleaningschedule.fromMap(Map<String, dynamic> map) {
    return Cleaningschedule(
      CleaningscheduleID: map['CleaningscheduleID'],
      DailyEarning: map['DailyEarning'],
      CleanerID: map['CleanerID'],
      JobID: map['JobID'],
    );
  }
}
