import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms/domain/Payment.dart';

class PaymentController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create payment
  Future<void> createPayment(Payment payment) async {
    try {
      await _firestore.collection('payments').add(payment.toMap());
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }

  // Update payment
  Future<void> updatePayment(String paymentID, Payment payment) async {
    try {
      await _firestore
          .collection('payments')
          .doc(paymentID)
          .update(payment.toMap());
    } catch (e) {
      throw Exception('Failed to update payment: $e');
    }
  }

  // Delete payment
  Future<void> deletePayment(String paymentID) async {
    try {
      await _firestore.collection('payments').doc(paymentID).delete();
    } catch (e) {
      throw Exception('Failed to delete payment: $e');
    }
  }

  // Get payment stream by owner ID
  Stream<List<Payment>> getPaymentsByOwnerID(String ownerID) {
    return _firestore
        .collection('payments')
        .where('OwnerID', isEqualTo: ownerID)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Payment.fromSnapshot(doc)).toList());
  }
}
