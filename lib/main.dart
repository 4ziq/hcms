import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms/firebase_options.dart';
import 'package:hcms/ManageCleanerActivity/CleanerActivityListPage.dart';
import 'package:hcms/pages/ManageCleaningSchedule/CleaningScheduleListPage.dart';
import 'package:hcms/pages/ManageBooking/BookingListPage.dart';
import 'package:hcms/pages/ManagePayment/CompletedTaskPage.dart';
import 'package:hcms/pages/ManageRating/RatingListPage.dart'; // Ensure RatingListPage is properly imported
import 'package:hcms/pages/Report/ReportPage.dart';
import 'package:provider/provider.dart';
import 'package:hcms/provider/CleanerActivityController.dart';
import 'package:hcms/provider/PaymentController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
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
        Provider(create: (_) => PaymentController()),
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
        routes: {
          '/rating': (context) => RatingListPage(ownerID: 'ownerId'),
        },
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userID = 'ownerId'; // Set your hardcoded user ID here

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDashboardButton(
                context: context,
                label: 'Booking',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingListPage()),
                ),
              ),
              const SizedBox(height: 20),
              _buildDashboardButton(
                context: context,
                label: 'Cleaning Activity',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CleanerActivityListPage()),
                ),
              ),
              const SizedBox(height: 20),
              _buildDashboardButton(
                context: context,
                label: 'Cleaner Schedule',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CleaningScheduleListPage()),
                ),
              ),
              const SizedBox(height: 20),
              _buildDashboardButton(
                context: context,
                label: 'Reports',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportPage()),
                ),
              ),
              const SizedBox(height: 20),
              _buildDashboardButton(
                context: context,
                label: 'Payments',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompletedTaskPage(ownerID: userID),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildDashboardButton(
                context: context,
                label: 'Rate Bookings',
                onPressed: () {
                  Navigator.pushNamed(context, '/rating');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(69, 151, 246, 1),
        fixedSize: Size(300, 50), // Set a consistent button size
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
