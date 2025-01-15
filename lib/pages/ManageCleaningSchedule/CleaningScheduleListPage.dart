import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore package
import 'CleaningScheduleDetailsPage.dart'; // Import JobDetailPage
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';

class CleaningScheduleListPage extends StatelessWidget {
  const CleaningScheduleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildCalendar(),
            _buildCalendarSection(),
            const SizedBox(height: 20),
            _buildDailyEarnings(),
            const SizedBox(height: 20),
            //_buildTodaysJobs(context),
          ],
        ),
      ),
    );
  }

  // Weekly calendar widget
  // Widget _buildCalendar() {
  //   return TableCalendar(
  //     firstDay: DateTime.utc(2024, 1, 1),
  //     lastDay: DateTime.utc(2024, 12, 31),
  //     focusedDay: _selectedDate,
  //     calendarFormat: CalendarFormat.week, // Show only one week
  //     startingDayOfWeek: StartingDayOfWeek.monday,
  //     selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
  //     onDaySelected: (selectedDay, focusedDay) {
  //       setState(() {
  //         _selectedDate = selectedDay;
  //       });
  //     },
  //   );
  // }

  Widget _buildCalendarSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "November 2024",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              7,
              (index) => Column(
                children: [
                  Text(
                    ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"][index],
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: index == 5 ? Colors.blue : Colors.grey.shade300,
                    child: Text(
                      (3 + index).toString(),
                      style: TextStyle(
                        color: index == 5 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyEarnings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Daily Earnings",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          "RM 40",
          style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Widget _buildTodaysJobs(BuildContext context) {
  //   return Expanded(
  //     child: StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         }
  //         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //           return const Center(
  //             child: Text(
  //               "No Jobs Found",
  //               style: TextStyle(fontSize: 16, color: Colors.grey),
  //             ),
  //           );
  //         }
  //         final jobs = snapshot.data!.docs;
  //         return ListView.builder(
  //           itemCount: jobs.length,
  //           itemBuilder: (context, index) {
  //             final job = jobs[index].data() as Map<String, dynamic>;
  //             return _buildJobCard(context, job);
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget _buildJobCard(BuildContext context, Map<String, dynamic> job) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 10),
  //     padding: const EdgeInsets.all(16.0),
  //     decoration: BoxDecoration(
  //       color: Colors.grey.shade200,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "${job['date']} | ${job['time']}",
  //           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 5),
  //         Text(
  //           job['description'],
  //           style: const TextStyle(fontSize: 12),
  //         ),
  //         const SizedBox(height: 10),
  //         Align(
  //           alignment: Alignment.centerRight,
  //           child: ElevatedButton(
  //             onPressed: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => CleaningScheduleDetailsPage(job: job),
  //                 ),
  //               );
  //             },
  //             style: ElevatedButton.styleFrom(
  //               primary: Colors.blue,
  //             ),
  //             child: const Text("View"),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
