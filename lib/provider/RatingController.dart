import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms/domain/Rating.dart';

class RatingController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a rating to Firestore
  Future<void> createRating(Rating rating) async {
    try {
      await _firestore.collection('ratings').add(rating.toMap());
    } catch (e) {
      throw Exception('Failed to create rating: $e');
    }
  }

  // Get all ratings
  Stream<List<Rating>> getRatings() {
    return _firestore.collection('ratings').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Rating.fromSnapshot(doc)).toList());
  }

  // Get ratings by booking ID
  Stream<List<Rating>> getRatingsByBookingId(String bookingId) {
    return _firestore
        .collection('ratings')
        .where('bookingId', isEqualTo: bookingId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Rating.fromSnapshot(doc)).toList());
  }
}
