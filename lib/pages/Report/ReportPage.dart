import 'package:flutter/material.dart';
import 'ReportDetailPage.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _dateController = TextEditingController();
  String? _selectedHomestay;

  final List<String> homestays = ['Teratak Bonda', 'Taman Maluri Homestay'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Picker
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter date',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dateController.text =
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Homestay Dropdown
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Homestay',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedHomestay,
                    hint: Text('Homestay'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedHomestay = newValue;
                      });
                    },
                    items: homestays.map((String homestay) {
                      return DropdownMenuItem<String>(
                        value: homestay,
                        child: Text(homestay),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_dateController.text.isEmpty || _selectedHomestay == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select date and homestay')),
                  );
                  return;
                }

                // Navigate to ReportDetailPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportDetailPage(
                      date: _dateController.text,
                      homestay: _selectedHomestay!,
                    ),
                  ),
                );
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
