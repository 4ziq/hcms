import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final String bookingId;
  final double rating;
  final String review;
  final String? photoUrl;
  final String? videoUrl;

  Rating({
    required this.bookingId,
    required this.rating,
    required this.review,
    this.photoUrl,
    this.videoUrl,
  });

  // Convert Rating to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'rating': rating,
      'review': review,
      'photoUrl': photoUrl,
      'videoUrl': videoUrl,
    };
  }

  // Create Rating from a Firestore document
  factory Rating.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Rating(
      bookingId: data['bookingId'],
      rating: data['rating'],
      review: data['review'],
      photoUrl: data['photoUrl'],
      videoUrl: data['videoUrl'],
    );
  }
}
