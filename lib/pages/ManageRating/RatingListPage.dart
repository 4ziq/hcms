import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'RatingFormInfoPage.dart';

class RatingListPage extends StatelessWidget {
  final String ownerID;

  RatingListPage({required this.ownerID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Rate"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('OwnerID', isEqualTo: ownerID)
            .where('BookingStatus', isEqualTo: "Completed")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bookings to rate.'));
          }

          final bookings = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final bookingDate = booking['BookingDate'] is Timestamp
                  ? (booking['BookingDate'] as Timestamp).toDate()
                  : DateTime.parse(booking['BookingDate']);

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    'Date: ${bookingDate.day}/${bookingDate.month}/${bookingDate.year}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Address: ${booking['BookingHomeAddress'] ?? "No Address"}',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RatingFormInfoPage(
                            bookingId: booking['id'],
                            bookingData: booking,
                          ),
                        ),
                      );
                    },
                    child: const Text("Rate"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
