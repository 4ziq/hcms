import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentInfoPage extends StatelessWidget {
  final List<Map<String, dynamic>>
      selectedBookings; // Booking details passed from CompletedTaskPage
  final double totalAmount; // Total payment amount

  const PaymentInfoPage({
    required this.selectedBookings,
    required this.totalAmount,
    Key? key,
  }) : super(key: key);

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  DateTime parseTimestampOrString(dynamic field) {
    if (field is Timestamp) {
      return field.toDate();
    } else if (field is String) {
      return DateTime.parse(field);
    } else {
      throw Exception("Unsupported field format: $field");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: selectedBookings.length,
                itemBuilder: (context, index) {
                  final booking = selectedBookings[index];
                  final bookingDate = DateTime.parse(booking['BookingDate']);
                  final bookingStartTime =
                      parseTimestampOrString(booking['BookingStartTime']);
                  final bookingEndTime =
                      parseTimestampOrString(booking['BookingEndTime']);
                  final bookingAddress = booking['BookingHomeAddress'];
                  final bookingDescription = booking['BookingTaskDescription'];
                  final bookingAmount = booking['CalculatedRate'];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date: ${formatDate(bookingDate)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Time: ${formatTime(bookingStartTime)} - ${formatTime(bookingEndTime)}',
                          ),
                          Text('Address: $bookingAddress'),
                          const SizedBox(height: 8.0),
                          Text('Description: $bookingDescription'),
                          const SizedBox(height: 8.0),
                          Text(
                            'Total: RM ${bookingAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: RM ${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment processing...')),
                    );
                    // Implement payment functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Pay'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
