import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingDetailPage extends StatelessWidget {
  const BookingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Date: ${booking['date']}'),
            // Text('Time: ${booking['time']}'),
            // Text('Fee: ${booking['fee']}'),
            // Text('Description: ${booking['description']}'),
          ],
        ),
      ),
    );
  }
}
