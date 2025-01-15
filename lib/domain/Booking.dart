import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Booking {
  final String BookingID;
  final DateTime BookingDate;
  final DateTime BookingStartTime;
  final DateTime BookingEndTime;
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

  // Create a Booking from a Firebase snapshot
  factory Booking.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Booking(
      BookingID: snapshot.id,
      OwnerID: data['OwnerID'],
      BookingDate: DateTime.parse(data['BookingDate']),
      BookingStartTime: data['BookingStartTime'],
      BookingEndTime: data['BookingEndTime'],
      BookingHomeAddress: data['BookingHomeAddress'],
      BookingTaskDescription: data['BookingTaskDescription'],
      CalculatedRate: data['CalculatedRate'],
      BookingStatus: data['BookingStatus'] ?? "Pending",
    );
  }

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
      'CalculatedRate': CalculatedRate,
      'BookingStatus': BookingStatus,
    };
  }
}
