import 'package:flutter/material.dart';
import 'package:hcms/pages/Report/ReportFormPage.dart';

class ReportPageDemo extends StatefulWidget {
  @override
  State<ReportPageDemo> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPageDemo> {
  final TextEditingController _dateController = TextEditingController();
  String? selectedHomestay;
  bool _isLoading = false;

  final List<String> _homestays = [
    'Teratak Bonda',
    'Homestay Indah',
    'Villa Aman'
  ];

  Future<void> _searchReport() async {
    if (_dateController.text.isEmpty || selectedHomestay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and homestay')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Dummy data for testing
    final bookingData = {
      'BookingDate': _dateController.text,
      'BookingStartTime': '1:00 PM',
      'BookingEndTime': '3:00 PM',
      'duration': 2,
      'BookingTaskDescription':
          'Basic cleaning such as sweeping the floors, making the bed, cleaning the house inside and cleaning the toilet. Mop the floors too.',
      'CalculatedRate': '20.00',
      'activityPhotos': [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150',
      ],
      'additionalNotes':
          'Suggest scheduling deep cleaning of carpets next month. One of the lightbulbs in the bedroom needs replacing.',
      'cleanerInfo': {
        'CleanerName': 'Emily Zhang',
        'CleanerPhoneNum': '0123456789',
        'CleanerEmail': 'emily.zhang@gmail.com',
        'CleanerProfilePic': 'https://via.placeholder.com/150',
        'Experience': '4 years',
        'Specialties':
            'Bathroom sanitization, window cleaning, and organizing.',
        'Rating': '4.9/5',
      },
    };

    // Simulate delay for better UX
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportDetailPage(bookingData: bookingData),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter date'),
            const SizedBox(height: 8.0),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                hintText: 'dd/mm/yyyy',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('Select Homestay'),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: selectedHomestay,
              items: _homestays
                  .map((homestay) => DropdownMenuItem(
                        value: homestay,
                        child: Text(homestay),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedHomestay = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _searchReport,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
