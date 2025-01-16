import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms/pages/ManagePayment/PaymentInfoPage.dart';
import 'package:hcms/pages/ManageBooking/BookingDetailPage.dart';

class CompletedTaskPage extends StatefulWidget {
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
          PaymentList(status: "Pending"), // "To Pay" tab
          PaymentList(status: "Completed"), // "Completed" tab
        ],
      ),
    );
  }
}

class PaymentList extends StatefulWidget {
  final String status;

  PaymentList({required this.status});

  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  List<String> selectedBookingIDs = [];
  double totalAmount = 0.0;
  bool selectAll = false;

  DateTime parseDate(dynamic value) {
    return value is Timestamp ? value.toDate() : DateTime.parse(value);
  }

  String formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
  }

  String formatTimeRange(DateTime start, DateTime end) {
    return "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - "
        "${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')} "
        "${end.hour < 12 ? 'AM' : 'PM'}";
  }

  void toggleSelection(List<Map<String, dynamic>> bookings,
      Map<String, dynamic> booking, bool isSelected) {
    String bookingID = booking['BookingID'];
    setState(() {
      if (isSelected) {
        selectedBookingIDs.add(bookingID);
        totalAmount += booking['CalculatedRate'];
      } else {
        selectedBookingIDs.remove(bookingID);
        totalAmount -= booking['CalculatedRate'];
      }
      selectAll = selectedBookingIDs.length == bookings.length;
    });
  }

  void toggleSelectAll(List<Map<String, dynamic>> bookings) {
    setState(() {
      if (selectAll) {
        selectedBookingIDs.clear();
        totalAmount = 0.0;
      } else {
        selectedBookingIDs =
            bookings.map((b) => b['BookingID'] as String).toList();
        totalAmount = bookings.fold(
            0.0, (sum, booking) => sum + booking['CalculatedRate']);
      }
      selectAll = !selectAll;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingStream = FirebaseFirestore.instance
        .collection('bookings')
        .where('BookingStatus', isEqualTo: widget.status)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: bookingStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final bookings = snapshot.data!.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        if (bookings.isEmpty) {
          return const Center(child: Text('No Bookings Found'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  String bookingID = booking['BookingID'];

                  DateTime bookingDate = parseDate(booking['BookingDate']);
                  DateTime bookingStartTime =
                      parseDate(booking['BookingStartTime']);
                  DateTime bookingEndTime =
                      parseDate(booking['BookingEndTime']);

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(
                        '${formatDate(bookingDate)} - ${formatTimeRange(bookingStartTime, bookingEndTime)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(booking['BookingTaskDescription'] ??
                              'No Description'),
                          Text(
                              'Amount: RM ${booking['CalculatedRate'].toStringAsFixed(2)}'),
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
                                  builder: (context) =>
                                      BookingDetailPage(booking: booking),
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
                            child: const Text('View',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Checkbox(
                            value: selectedBookingIDs.contains(bookingID),
                            onChanged: (bool? value) {
                              toggleSelection(
                                  bookings, booking, value ?? false);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (widget.status == "Pending")
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: selectAll,
                          onChanged: (value) => toggleSelectAll(bookings),
                        ),
                        const Text('Select All'),
                        const SizedBox(width: 16),
                        Text('Total: RM ${totalAmount.toStringAsFixed(2)}'),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: totalAmount > 0
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PaymentInfoPage(totalAmount: totalAmount),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            totalAmount > 0 ? Colors.green : Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Checkout',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
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
