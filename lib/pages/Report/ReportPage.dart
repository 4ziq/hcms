import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ReportDetailPage.dart';

class ReportPage extends StatefulWidget {
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _dateController = TextEditingController();
  String? selectedHomestay;
  bool _isLoading = false;
  List<String> _homestays = [];

  @override
  void initState() {
    super.initState();
    _fetchHomestays();
  }

  Future<void> _fetchHomestays() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('bookings').get();

      final homestaysSet = <String>{};
      for (var doc in querySnapshot.docs) {
        homestaysSet.add(doc['BookingHomeAddress']);
      }

      setState(() {
        _homestays = homestaysSet.toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching homestays: $e')),
      );
    }
  }

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

    try {
      // Parse the selected date
      final selectedDate = DateTime.parse(
          '${_dateController.text.split('/').reversed.join('-')}');

      // Query Firestore for matching bookings
      final querySnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('BookingHomeAddress', isEqualTo: selectedHomestay)
          .where('BookingDate',
              isGreaterThanOrEqualTo:
                  Timestamp.fromDate(selectedDate)) // Start of the day
          .where('BookingDate',
              isLessThanOrEqualTo: Timestamp.fromDate(
                  selectedDate.add(const Duration(days: 1)))) // End of the day
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No result found')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportDetailPage(
            bookingData: querySnapshot.docs.first.data(),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching report: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
            _homestays.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
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
