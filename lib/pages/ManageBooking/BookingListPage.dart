import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcms/domain/Booking.dart';
import 'package:hcms/provider/BookingController.dart';
import 'BookingDetailPage.dart';
import 'BookingFormPage.dart';
import 'EditBookingPage.dart';

class BookingListPage extends StatefulWidget {
  BookingListPage({super.key});

  @override
  State<BookingListPage> createState() => _BookingListPageState();

  final _bookingController = BookingController();
}

class _BookingListPageState extends State<BookingListPage> {
  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Theme(
      data: _buildTheme(Brightness.light),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking List'),
        ),
        body: Column(
          children: [
            // Filters Section
            // Booking List Section
            Expanded(
              child: StreamBuilder<List<Booking>>(
                stream:
                    widget._bookingController.getBookingsByOwnerId('ownerId'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    print(snapshot);
                    return const Center(
                        child: Text('You have not made any bookings.'));
                  }
                  final bookings = snapshot.data!;
                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return BookingCard(
                        BookingID: booking.BookingID,
                        BookingDate: booking.BookingDate.toString(),
                        BookingStartTime: booking.BookingStartTime.toString(),
                        BookingEndTime: booking.BookingEndTime.toString(),
                        BookingHomeAddress: booking.BookingHomeAddress,
                        BookingTaskDescription: booking.BookingTaskDescription,
                        CalculatedRate: booking.CalculatedRate,
                        BookingStatus: booking.BookingStatus,
                        OwnerID: booking.OwnerID,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          width: 375, // Desired width
          height: 50, // Optional: Desired height
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingFormPage(),
                ),
              );
            },
            backgroundColor: const Color.fromRGBO(69, 151, 246, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              'Make New Booking',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BookingCard extends StatefulWidget {
  final String BookingID;
  final String BookingDate;
  final String BookingStartTime;
  final String BookingEndTime;
  final String BookingHomeAddress;
  final String BookingTaskDescription;
  final double CalculatedRate;
  final String BookingStatus;
  final String OwnerID;

  BookingCard({
    super.key,
    required this.BookingID,
    required this.BookingDate,
    required this.BookingStartTime,
    required this.BookingEndTime,
    required this.BookingHomeAddress,
    required this.BookingTaskDescription,
    required this.CalculatedRate,
    required this.BookingStatus,
    required this.OwnerID,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BookingCardState createState() => _BookingCardState();
  final _bookingController = BookingController();
}

class _BookingCardState extends State<BookingCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookingDetailPage(
                        bookingId: widget.BookingID,
                      )),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.BookingDate.split(' ')[0].split('-')[2]}/${widget.BookingDate.split(' ')[0].split('-')[1]}/${widget.BookingDate.split(' ')[0].split('-')[0]}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.BookingStartTime.split(' ')[1].split(':')[0]}:${widget.BookingStartTime.split(' ')[1].split(':')[1]} - ${widget.BookingEndTime.split(' ')[1].split(':')[0]}:${widget.BookingEndTime.split(' ')[1].split(':')[1]}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.BookingTaskDescription,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Text(
                        'RM ${widget.CalculatedRate.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Text(
                        widget.BookingStatus,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookingDetailPage(
                                      bookingId: widget.BookingID,
                                    )),
                          );
                        },
                        child: const Text('View'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => EditBookingPage(
                          //       bookingId: widget.BookingID,
                          //     ),
                          //   ),
                          // );
                        },
                        child: const Text('Update'),
                      ),
                      if (widget.BookingStatus == 'Pending')
                        TextButton(
                          onPressed: () async {
                            widget._bookingController
                                .cancelBooking(widget.BookingID);
                          },
                          child: const Text('Cancel Booking'),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
