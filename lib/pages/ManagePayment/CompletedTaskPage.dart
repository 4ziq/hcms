import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms/pages/ManageBooking/BookingDetailPage.dart';
import 'package:hcms/pages/ManagePayment/PaymentInfoPage.dart';

class CompletedTaskPage extends StatefulWidget {
  final String ownerID;

  CompletedTaskPage({required this.ownerID});

  @override
  _CompletedTaskPageState createState() => _CompletedTaskPageState();
}

class _CompletedTaskPageState extends State<CompletedTaskPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'To Pay'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BookingList(ownerID: widget.ownerID),
          const Center(
            child: Text('No completed payments to display.'),
          ),
        ],
      ),
    );
  }
}

class BookingList extends StatefulWidget {
  final String ownerID;

  BookingList({required this.ownerID});

  @override
  _BookingListState createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  List<String> selectedBookings = [];
  double totalAmount = 0.0;
  bool selectAll = false;

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

  void toggleSelection(String bookingID, double amount, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedBookings.add(bookingID);
        totalAmount += amount;
      } else {
        selectedBookings.remove(bookingID);
        totalAmount -= amount;
      }
    });
  }

  void toggleSelectAll(List<Map<String, dynamic>> bookings) {
    setState(() {
      if (selectAll) {
        // Unselect all
        selectedBookings.clear();
        totalAmount = 0.0;
      } else {
        // Select all
        selectedBookings =
            bookings.map((booking) => booking['id'] as String).toList();
        totalAmount = bookings.fold(
          0.0,
          (sum, booking) => sum + (booking['CalculatedRate'] ?? 0.0),
        );
      }
      selectAll = !selectAll;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingStream = FirebaseFirestore.instance
        .collection('bookings')
        .where('OwnerID', isEqualTo: widget.ownerID)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: bookingStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No bookings found.'));
        }

        final bookings = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final bookingID = booking['id'] as String;
                  final bookingDate = DateTime.parse(booking['BookingDate']);
                  final bookingStartTime =
                      parseTimestampOrString(booking['BookingStartTime']);
                  final bookingEndTime =
                      parseTimestampOrString(booking['BookingEndTime']);
                  final bookingAmount = booking['CalculatedRate'] != null
                      ? booking['CalculatedRate'] as double
                      : 0.0;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(
                        '${formatDate(bookingDate)} - ${formatTime(bookingStartTime)} to ${formatTime(bookingEndTime)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(booking['BookingTaskDescription'] ??
                              'No Description'),
                          Text(
                            'Amount: RM ${bookingAmount.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingDetailPage(
                                    bookingId: bookingID,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'View',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Checkbox(
                            value: selectedBookings.contains(bookingID),
                            onChanged: (bool? value) {
                              toggleSelection(
                                  bookingID, bookingAmount, value ?? false);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: selectAll,
                        onChanged: (bool? value) {
                          toggleSelectAll(bookings);
                        },
                      ),
                      const Text('Select All'),
                    ],
                  ),
                  Text('Total: RM ${totalAmount.toStringAsFixed(2)}'),
                  ElevatedButton(
                    onPressed: totalAmount > 0
                        ? () {
                            final selectedBookingsDetails = bookings
                                .where((booking) =>
                                    selectedBookings.contains(booking['id']))
                                .toList();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentInfoPage(
                                  selectedBookings: selectedBookingsDetails,
                                  totalAmount: totalAmount,
                                ),
                              ),
                            );
                          }
                        : null,
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
