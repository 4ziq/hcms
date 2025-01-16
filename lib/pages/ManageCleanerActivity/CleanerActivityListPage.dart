import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'TaskDetailPage.dart';
import 'package:intl/intl.dart';

class CleanerActivityListPage extends StatefulWidget {
  @override
  _CleanerActivityListPageState createState() =>
      _CleanerActivityListPageState();
}

class _CleanerActivityListPageState extends State<CleanerActivityListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Activity"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(   ///kutip data dari firebase
        stream: _firestore
            .collection('bookings')
            .orderBy('BookingDate', descending: false)
            .snapshots(),
        builder: (context, snapshot) {      ///loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No activities found'));
          }

          final bookings = snapshot.data!.docs;   

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index].data() as Map<String, dynamic>;
              final documentId = bookings[index].id;
              DateTime bookingDate;
              if (booking['BookingDate'] is Timestamp) {
                bookingDate = (booking['BookingDate'] as Timestamp).toDate();
              } else if (booking['BookingDate'] is String) {
                bookingDate = DateTime.parse(booking['BookingDate']);
              } else {
                throw Exception('Invalid BookingDate type');
              }
              final startTime =
                  (booking['BookingStartTime'] as Timestamp).toDate();
              final endTime = (booking['BookingEndTime'] as Timestamp).toDate();

              final formattedDate = DateFormat('dd/MM/yyyy').format(startTime);
              final formattedTimeRange =
                  '${DateFormat('h:mm a').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}';

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$formattedDate, $formattedTimeRange',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        booking['BookingHomeAddress'],
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        booking['BookingTaskDescription'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Total Payment: RM ${booking['CalculatedRate']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () async {
                          // Navigate to TaskDetailPage and wait for result
                          final updatedDocumentId = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailPage(
                                documentId: documentId,
                                bookingData: booking,
                              ),
                            ),
                          );

                          // If the task was updated, remove it from the list
                          if (updatedDocumentId != null) {
                            setState(() {
                              bookings.removeAt(index);
                            });
                          }
                        },
                        child: const Text(
                          'Update Activity',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
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
