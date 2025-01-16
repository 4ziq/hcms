import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingFormInfoPage extends StatefulWidget {
  final String bookingId;
  final Map<String, dynamic> bookingData;

  RatingFormInfoPage({required this.bookingId, required this.bookingData});

  @override
  _RatingFormInfoPageState createState() => _RatingFormInfoPageState();
}

class _RatingFormInfoPageState extends State<RatingFormInfoPage> {
  int rating = 0; // Star rating (1-5)
  final TextEditingController reviewController = TextEditingController();
  bool isSubmitting = false;

  void submitRating() async {
    if (rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a rating.')),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await FirebaseFirestore.instance.collection('ratings').add({
        'bookingId': widget.bookingId,
        'rating': rating,
        'review': reviewController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rating submitted successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting rating: $e')),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.bookingData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date: ${booking['BookingDate']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Address: ${booking['BookingHomeAddress'] ?? "No Address"}',
              ),
              const SizedBox(height: 16),
              const Text(
                'Rating:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                    icon: Icon(
                      Icons.star,
                      color: index < rating ? Colors.yellow : Colors.grey,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              const Text(
                'Review:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: reviewController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your review here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: isSubmitting ? null : submitRating,
                    child: isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text('Submit'),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: isSubmitting
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
