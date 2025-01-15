import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskDetailPage extends StatefulWidget {
  final String cleanerActivityID;

  const TaskDetailPage({Key? key, required this.cleanerActivityID}) : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TextEditingController _notesController = TextEditingController();
  List<String> _photoUrls = []; // Placeholder for uploaded photos

  Future<void> fetchTaskDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('CleanerActivities')
          .doc(widget.cleanerActivityID)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _photoUrls = List<String>.from(data['activityPhotos'] ?? []);
          _notesController.text = data['additionalNotes'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load task details: $e')),
      );
    }
  }

  Future<void> updateTaskDetails() async {
    try {
      await FirebaseFirestore.instance
          .collection('CleanerActivities')
          .doc(widget.cleanerActivityID)
          .update({
        'additionalNotes': _notesController.text,
        'activityPhotos': _photoUrls,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update Successful')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTaskDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Activity'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'KAK AIN HOMESTAY',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Handle photo upload logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Photo upload coming soon')),
                    );
                  },
                  child: Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.camera_alt, size: 40),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Additional Notes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter additional notes...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateTaskDetails,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
