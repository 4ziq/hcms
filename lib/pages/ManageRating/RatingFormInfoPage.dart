import 'package:flutter/material.dart';
import 'package:hcms/domain/Rating.dart';
import 'package:hcms/provider/RatingController.dart';

class RatingFormInfoPage extends StatefulWidget {
  final String bookingId;

  RatingFormInfoPage({required this.bookingId});

  @override
  _RatingFormInfoPageState createState() => _RatingFormInfoPageState();
}

class _RatingFormInfoPageState extends State<RatingFormInfoPage> {
  final _ratingController = TextEditingController();
  final _reviewController = TextEditingController();
  double rating = 0.0;

  @override
  void dispose() {
    _ratingController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _submitRating() {
    final ratingData = Rating(
      bookingId: widget.bookingId,
      rating: rating,
      review: _reviewController.text,
      photoUrl: null, // Add photo upload logic here
      videoUrl: null, // Add video upload logic here
    );

    RatingController().createRating(ratingData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Rating submitted successfully!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rate Booking")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Rate your experience:"),
            const SizedBox(height: 16.0),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                  ),
                  onPressed: () {
                    setState(() {
                      rating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Write your review here...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitRating,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
