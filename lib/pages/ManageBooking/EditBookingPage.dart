import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditBookingPage extends StatefulWidget {
  final Map<String, dynamic> booking;
  const EditBookingPage({super.key, required this.booking});

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _addressController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.booking['date']);
    _startTimeController =
        TextEditingController(text: widget.booking['startTime']);
    _endTimeController = TextEditingController(text: widget.booking['endTime']);
    _addressController = TextEditingController(text: widget.booking['address']);
    _descriptionController =
        TextEditingController(text: widget.booking['description']);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitUpdate() {
    // Handle the booking update logic here (e.g., database update)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking updated successfully!')),
    );
    Navigator.pop(context); // Return to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Enter date'),
                keyboardType: TextInputType.datetime,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startTimeController,
                      decoration: const InputDecoration(labelText: 'Starts'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _endTimeController,
                      decoration: const InputDecoration(labelText: 'Ends'),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _addressController,
                decoration:
                    const InputDecoration(labelText: 'Homestay Address'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitUpdate,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
