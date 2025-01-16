import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:typed_data';

///ni paling last 

class TaskDetailPage extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> bookingData;

  const TaskDetailPage(
      {super.key, required this.documentId, required this.bookingData});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TextEditingController _notesController = TextEditingController();
  List<Uint8List> _photos = [];
  bool _isSubmitting = false;

  // Method to pick an image (Flutter Web compatible)
  Future<void> _pickImage() async {
    if (_photos.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only upload up to 4 photos')),
      );
      return;
    }

    final Uint8List? pickedFile = await ImagePickerWeb.getImageAsBytes();
    if (pickedFile != null) {
      setState(() {
        _photos.add(pickedFile);
      });
    }
  }

  // Method to submit and update the activity
  Future<void> _submitUpdate() async {
    if (_photos.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload 4 photos')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Generate unique cleanerActivityID
      final cleanerActivityID = 'CA${DateTime.now().millisecondsSinceEpoch}';

      // Upload photos to Firebase Storage and get URLs
      List<String> photoUrls = [];
      for (int i = 0; i < _photos.length; i++) {
        final photoRef = FirebaseStorage.instance
            .ref()
            .child('cleanerActivities')
            .child('$cleanerActivityID/photo_$i.jpg');

        try {
          // Upload the photo and get its URL
          await photoRef.putData(_photos[i]);
          final photoUrl = await photoRef.getDownloadURL();
          photoUrls.add(photoUrl);
        } catch (e) {
          // Catch individual photo upload errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload photo $i: $e')),
          );
          throw e; // Re-throw the error to stop execution
        }
      }

      // Save the data in Firestore
      await FirebaseFirestore.instance
          .collection('cleanerActivities')
          .doc(cleanerActivityID)
          .set({
        'cleanerActivityID': cleanerActivityID,
        'activityPhotos': photoUrls,
        'additionalNotes': _notesController.text,
        'cleaningScheduleID': widget.documentId,
        'bookingID': widget.bookingData['BookingID'],
        'jobID': 'job_id_placeholder', // Replace with actual job ID if needed
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update Successful')),
      );

      Navigator.pop(context);
    } catch (e) {
      // Display any general errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update activity: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Activity'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.bookingData['BookingHomeAddress'],
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Upload Photos (4 required)',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _photos
                  .map((photo) => Stack(
                        children: [
                          Image.memory(
                            photo,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _photos.remove(photo);
                                });
                              },
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Add Photo'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Additional Notes',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter additional notes',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitUpdate,
                child: _isSubmitting
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
