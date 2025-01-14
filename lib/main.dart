import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms/firebase_options.dart';
import 'package:hcms/pages/ManageCleaningSchedule/CleaningScheduleListPage.dart';
import 'pages/ManageBooking/BookingListPage.dart';
import 'pages/ManageCleanerActivity/CleanerActivityListPage.dart';
import 'package:provider/provider.dart';
import 'package:hcms/provider/CleanerActivityController.dart';
import 'pages/Report/ReportPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CleanerActivityController()),
      ],
      child: MaterialApp(
        title: 'HCMS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme:
              GoogleFonts.latoTextTheme(Theme.of(context).textTheme).copyWith(
            bodyMedium: GoogleFonts.oswald(
                textStyle: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        home: DashboardScreen(),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: <Widget>[
              Text(
                "Homestay Cleaner Management System",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  height: 2.5,
                ),
              ),
              Text(
                "HCMS",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingListPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(69, 151, 246, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Booking',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CleanerActivityListPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(69, 151, 246, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Cleaning Activity',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CleaningScheduleListPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(69, 151, 246, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Cleaner Schedule',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(69, 151, 246, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Reports',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder for other features
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(69, 151, 246, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Other Feature (Placeholder)',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
