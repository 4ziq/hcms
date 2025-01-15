import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcms/domain/Booking.dart';
import 'package:hcms/provider/BookingController.dart';

class BookingFormPage extends StatefulWidget {
  final String? bookingID;

  BookingFormPage({super.key, this.bookingID});

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();

  final BookingController _bookingController = BookingController();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
    );
  }

  void _submitForm() {
    final String date = _dateController.text;
    final String address = _addressController.text;
    final String description = _descriptionController.text;

    final booking = Booking(
      BookingID: '', // Will be set by Firestore
      BookingDate: DateTime.now(),
      BookingStartTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        _startTime!.hour,
        _startTime!.minute,
      ),
      BookingEndTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        _endTime!.hour,
        _endTime!.minute,
      ),
      BookingHomeAddress: address,
      BookingTaskDescription: description,
      CalculatedRate: 10,
      BookingStatus: 'Pending',
      OwnerID: "owner_id", // Replace with actual owner ID
    );

    BookingController().createBooking(booking);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Theme(
      data: _buildTheme(Brightness.light),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Row(
              children: [
                Spacer(),
                Text(
                  "Add Booking",
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter date",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    hintText: "dd/mm/yyyy",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Starts",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _selectTime(context, true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                _startTime != null
                                    ? _startTime!.format(context)
                                    : "8:00 AM",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ends",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _selectTime(context, false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                _endTime != null
                                    ? _endTime!.format(context)
                                    : "8:00 AM",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Homestay Address",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: "Enter homestay address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Description",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Enter description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _submitForm();
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
