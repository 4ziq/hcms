import 'package:flutter/material.dart';

class Booking {
  final String BookingID;
  final DateTime BookingDate;
  final TimeOfDay BookingStartTime;
  final TimeOfDay BookingEndTime;
  final String BookingHomeAddress;
  final String BookingTaskDescription;
  final double CalculatedRate;
  final String BookingStatus;
  final String OwnerID;

  Booking({
    required this.BookingID,
    required this.BookingDate,
    required this.BookingStartTime,
    required this.BookingEndTime,
    required this.BookingHomeAddress,
    required this.BookingTaskDescription,
    required this.CalculatedRate,
    this.BookingStatus = "Pending",
    required this.OwnerID,
  });

  // Convert Booking to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'BookingID': BookingID,
      'OwnerID': OwnerID,
      'BookingDate': BookingDate.toIso8601String(),
      'BookingStartTime': BookingStartTime,
      'BookingEndTime': BookingEndTime,
      'BookingHomeAddress': BookingHomeAddress,
      'BookingTaskDescription': BookingTaskDescription,
      'CalculatedRate' : CalculatedRate,
      'BookingStatus': BookingStatus,
    };
  }

  // Create a Booking from a Firebase snapshot
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      BookingID: map['BookingID'],
      OwnerID: map['OwnerID'],
      BookingDate: DateTime.parse(map['BookingDate']),
      BookingStartTime: map['BookingStartTime'],
      BookingEndTime: map['BookingEndTime'],
      BookingHomeAddress: map['BookingHomeAddress'],
      BookingTaskDescription: map['BookingTaskDescription'],
      CalculatedRate: map['CalculatedRate'],
      BookingStatus: map['BookingStatus'] ?? "Pending",
    );
  }
}
