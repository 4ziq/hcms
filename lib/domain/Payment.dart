import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String paymentID;
  final DateTime paymentDate;
  final DateTime paymentStartTime;
  final DateTime paymentEndTime;
  final String paymentDescription;
  final double amount;
  final String paymentStatus;
  final String ownerID;

  Payment({
    required this.paymentID,
    required this.paymentDate,
    required this.paymentStartTime,
    required this.paymentEndTime,
    required this.paymentDescription,
    required this.amount,
    this.paymentStatus = "Pending",
    required this.ownerID,
  });

  // Factory constructor to create a `Payment` from a Firestore snapshot
  factory Payment.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Payment(
      paymentID: snapshot.id,
      ownerID: data['OwnerID'],
      paymentDate: DateTime.parse(data['PaymentDate']),
      paymentStartTime: DateTime.parse(data['PaymentStartTime']),
      paymentEndTime: DateTime.parse(data['PaymentEndTime']),
      paymentDescription: data['PaymentDescription'],
      amount: data['Amount'],
      paymentStatus: data['PaymentStatus'] ?? "Pending",
    );
  }

  // Convert `Payment` to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'OwnerID': ownerID,
      'PaymentDate': paymentDate.toIso8601String(),
      'PaymentStartTime': paymentStartTime.toIso8601String(),
      'PaymentEndTime': paymentEndTime.toIso8601String(),
      'PaymentDescription': paymentDescription,
      'Amount': amount,
      'PaymentStatus': paymentStatus,
    };
  }
}
