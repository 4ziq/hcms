import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hcms/domain/Booking.dart';
import 'package:hcms/provider/BookingController.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
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
    final String time = _startTimeController.text;
    final String description = _descriptionController.text;
    final String endTime = _endTimeController.text;
    final String startTime = _startTimeController.text;

    final dateTimeString = '$date $time';
    final dateTime = DateFormat('yyyy-MM-dd h:mm a').parse(dateTimeString);

    final startdateTimeString = '$date $startTime';
    final startdateTime =
        DateFormat('yyyy-MM-dd h:mm a').parse(startdateTimeString);

    final endTimeString = '$date $endTime';
    final endTimefin = DateFormat('yyyy-MM-dd h:mm a').parse(endTimeString);

    final rate =
        (widget._bookingController.calculateRate(startdateTime, endTimefin, 10))
            .toStringAsFixed(2);

    final booking = Booking(
      BookingID: '', // Will be set by Firestore
      BookingDate: dateTime,
      BookingStartTime: startdateTime,
      BookingEndTime: endTimefin,
      BookingHomeAddress: address,
      BookingTaskDescription: description,
      CalculatedRate: double.parse(rate),
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
                          TextFormField(
                            controller: _startTimeController,
                            validator: (String? value) =>
                                value != null && value.isEmpty
                                    ? 'Please choose a time'
                                    : null,
                            keyboardType: TextInputType.datetime,
                            decoration: const InputDecoration(
                              hintText: "Select Time",
                              border: OutlineInputBorder(),
                            ),
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  _startTimeController.text =
                                      pickedTime.format(context);
                                });
                              }
                            },
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
                          TextFormField(
                            controller: _endTimeController,
                            validator: (String? value) =>
                                value != null && value.isEmpty
                                    ? 'Please choose a time'
                                    : null,
                            keyboardType: TextInputType.datetime,
                            decoration: const InputDecoration(
                              hintText: "Select Time",
                              border: OutlineInputBorder(),
                            ),
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  _endTimeController.text =
                                      pickedTime.format(context);
                                });
                              }
                            },
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
