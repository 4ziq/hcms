// lib/controllers/booking_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms/domain/Booking.dart';

class BookingController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create booking
  Future<void> createBooking(Booking booking) async {
    try {
      await _firestore.collection('bookings').add(booking.toMap());
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  // Update booking
  Future<void> updateBooking(String bookingId, Booking booking) async {
    try {
      await _firestore
          .collection('bookings')
          .doc(bookingId)
          .update(booking.toMap());
    } catch (e) {
      throw Exception('Failed to update booking: $e');
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _firestore
          .collection('bookings')
          .doc(bookingId)
          .update({'booking_status': 'Cancelled'});
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  // Get booking stream by owner ID
  Stream<List<Booking>> getBookingsByOwnerId(String? ownerId) {
    return _firestore
        .collection('booking')
        .where('owner_id', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Booking.fromSnapshot(doc)).toList());
  }

  // Get single booking
  Future<Booking> getBookingById(String bookingId) async {
    try {
      final doc = await _firestore.collection('bookings').doc(bookingId).get();
      return Booking.fromSnapshot(doc);
    } catch (e) {
      throw Exception('Failed to get booking: $e');
    }
  }

  // Get cleaning activities for a booking
  Stream<QuerySnapshot> getCleaningActivities(String bookingId) {
    return _firestore
        .collection('cleaningactivity')
        .where('booking_id',
            isEqualTo: _firestore.collection('bookings').doc(bookingId))
        .snapshots();
  }
}
