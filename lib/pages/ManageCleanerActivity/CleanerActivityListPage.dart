import 'package:flutter/material.dart';
import 'TaskDetailPage.dart'; // Adjust the path if necessary

class CleanerActivityListPage extends StatelessWidget {
  final List<Map<String, String>> tasks = [
    {
      "date": "14/09/2024",
      "time": "1:00 PM - 3:00 PM",
      "homestay": "TERATAK BONDA",
      "description":
          "Basic cleaning such as sweeping floors, making the bed, cleaning the house...",
      "payment": "RM 20"
    },
    {
      "date": "18/09/2024",
      "time": "1:00 PM - 3:00 PM",
      "homestay": "TAMAN MALURI HOMESTAY",
      "description":
          "Basic cleaning such as sweeping floors, making the bed, cleaning the house...",
      "payment": "RM 20"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Activity'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            color: Colors.white, // Set the card's background color to white
            elevation: 4.0,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${task["date"]}   ${task["time"]}',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    task["homestay"] ?? "",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    task["description"] ?? "",
                    style: TextStyle(fontSize: 14.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Payment: ${task["payment"]}',
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailPage(task: task),
                            ),
                          );
                        },
                        child: Text('Update Activity'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // Button background color
                          textStyle: TextStyle(fontSize: 14.0),
                          foregroundColor: Colors.white,
                          iconColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
