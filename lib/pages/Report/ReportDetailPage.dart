import 'package:flutter/material.dart';

class ReportDetailPage extends StatelessWidget {
  final String date;
  final String homestay;

  ReportDetailPage({required this.date, required this.homestay});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<Map<String, dynamic>> reports = [
      {
        "date": "12/11/2024",
        "homestay": "Teratak Bonda",
        "description": "Basic cleaning such as sweeping floors, make the bed, clean the house inside and clean the toilet.",
        "total": "RM 20.00",
        "photos": ["photo1.jpg", "photo2.jpg", "photo3.jpg", "photo4.jpg"],
        "notes": "Suggest scheduling deep cleaning of carpets in the next month.",
        "cleaner": {
          "name": "Emily Zhang",
          "phone": "01234567890",
          "email": "emily.zhang@gmail.com",
          "experience": "4 years",
          "specialties": "Bathroom sanitization, window cleaning, organizing",
          "rating": "4.9/5"
        },
      }
    ];

    final filteredReports = reports.where((report) {
      return report['date'] == date && report['homestay'] == homestay;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
        backgroundColor: Colors.blue,
      ),
      body: filteredReports.isEmpty
          ? Center(child: Text('No Result Found :('))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${filteredReports[0]["date"]}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Homestay: ${filteredReports[0]["homestay"]}'),
                  SizedBox(height: 10),
                  Text('Description: ${filteredReports[0]["description"]}'),
                  SizedBox(height: 10),
                  Text('Total: ${filteredReports[0]["total"]}'),
                  SizedBox(height: 10),
                  Text('Photos:'),
                  SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ),
                    itemCount: filteredReports[0]["photos"].length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(child: Text('Photo ${index + 1}')),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text('Additional Notes: ${filteredReports[0]["notes"]}'),
                  SizedBox(height: 10),
                  Text('Cleaner Information:'),
                  Text('Name: ${filteredReports[0]["cleaner"]["name"]}'),
                  Text('Phone: ${filteredReports[0]["cleaner"]["phone"]}'),
                  Text('Email: ${filteredReports[0]["cleaner"]["email"]}'),
                  Text('Experience: ${filteredReports[0]["cleaner"]["experience"]}'),
                  Text('Specialties: ${filteredReports[0]["cleaner"]["specialties"]}'),
                  Text('Rating: ${filteredReports[0]["cleaner"]["rating"]}'),
                ],
              ),
            ),
    );
  }
}
