import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'BookingDetailPage.dart';
import 'BookingFormPage.dart';
import 'EditBookingPage.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  List<Map<String, dynamic>> bookings = []; // Initially empty list for testing "No Booking Found"

  void _deleteBooking(int index) {
    setState(() {
      bookings.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking deleted successfully!')),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Booking?'),
          content: const Text('Are you sure you want to delete this booking?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Perform the delete action
              },
              child: const Text('Confirm', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

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
          // title: const Text(
          //   "HCMS",
          //   style: TextStyle(
          //     fontSize: 18,
          //     color: Colors.black,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          title: Center(
            child: Row(
              children: [
                Spacer(),
                Text(
                  "Booking List",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                Text(
                  "HCMS",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: bookings.isEmpty
            ? const Center(
                child: Text(
                  'No Booking Found',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${booking['date']} ${booking['startTime']} - ${booking['endTime']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            booking['description'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Handle View action
                                  // Pass booking details to detail screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookingDetailPage(booking: booking),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                child: const Text('View'),
                              ),
                              const SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: () {
                                  // Handle Update action
                                  // Navigate to AddBookingScreen for editing
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditBookingPage(booking: booking),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: const Text('Update'),
                              ),
                              const SizedBox(width: 8.0),
                              IconButton(
                                onPressed: () {
                                  // Show confirmation dialog before deleting
                                  showDeleteConfirmationDialog(context, () => _deleteBooking(index));
                                },
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: Container(
          width: 375, // Desired width
          height: 50, // Optional: Desired height
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookingFormPage(),
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