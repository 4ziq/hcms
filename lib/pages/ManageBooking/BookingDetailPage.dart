import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingDetailPage extends StatelessWidget {
  final String bookingId;
  const BookingDetailPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Detail'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('bookings')
              .doc(bookingId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              print(snapshot);
              return const Center(
                  child: Text('You have not made any bookings.'));
            }
            final bookings = snapshot.data!.data() as Map<String, dynamic>;
            bookings['BookingStartTime'] =
                (bookings['BookingStartTime'] as Timestamp).toDate().toString();
            bookings['BookingEndTime'] =
                (bookings['BookingEndTime'] as Timestamp).toDate().toString();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${DateTime.parse(bookings['BookingDate']).day.toString().padLeft(2, '0')}/${DateTime.parse(bookings['BookingDate']).month.toString().padLeft(2, '0')}/${DateTime.parse(bookings['BookingDate']).year}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Time: ${int.parse(bookings['BookingStartTime'].split(' ')[1].substring(0, 2)) % 12 == 0 ? 12 : int.parse(bookings['BookingStartTime'].split(' ')[1].substring(0, 2)) % 12}:${bookings['BookingStartTime'].split(' ')[1].substring(3, 5)} ${int.parse(bookings['BookingStartTime'].split(' ')[1].substring(0, 2)) >= 12 ? 'PM' : 'AM'} until ' +
                        '${int.parse(bookings['BookingEndTime'].split(' ')[1].substring(0, 2)) % 12 == 0 ? 12 : int.parse(bookings['BookingEndTime'].split(' ')[1].substring(0, 2)) % 12}:${bookings['BookingEndTime'].split(' ')[1].substring(3, 5)} ${int.parse(bookings['BookingEndTime'].split(' ')[1].substring(0, 2)) >= 12 ? 'PM' : 'AM'}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Homestay Address:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bookings['BookingHomeAddress'],
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bookings['BookingTaskDescription'],
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Total Fee:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'RM ${bookings['CalculatedRate'].toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Status:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bookings['BookingStatus'],
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
