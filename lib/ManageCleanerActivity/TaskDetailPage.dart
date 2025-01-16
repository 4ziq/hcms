import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:typed_data';

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
      final cleanerActivityID = 'CA${DateTime.now().millisecondsSinceEpoch}';

      List<String> photoUrls = [];
      for (int i = 0; i < _photos.length; i++) {
        final photoRef = FirebaseStorage.instance
            .ref()
            .child('cleanerActivities')
            .child('$cleanerActivityID/photo_$i.jpg');

        await photoRef.putData(_photos[i]);
        final photoUrl = await photoRef.getDownloadURL();
        photoUrls.add(photoUrl);
      }

      await FirebaseFirestore.instance
          .collection('cleanerActivities')
          .doc(cleanerActivityID)
          .set({
        'cleanerActivityID': cleanerActivityID,
        'activityPhotos': photoUrls,
        'additionalNotes': _notesController.text,
        'cleaningScheduleID': widget.documentId,
        'bookingID': widget.bookingData['BookingID'],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update Successful')),
      );

      // Pass the document ID back to CleanerActivityListPage
      Navigator.pop(context, widget.documentId);
    } catch (e) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.bookingData['BookingHomeAddress'],
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Upload Photos (4 required)',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1,
              ),
              itemCount: _photos.length + 1,
              itemBuilder: (context, index) {
                if (index == _photos.length) {
                  return GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Icon(Icons.add_a_photo,
                          size: 40.0, color: Colors.grey),
                    ),
                  );
                }
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(
                        _photos[index],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4.0,
                      right: 4.0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _photos.removeAt(index);
                          });
                        },
                        child: const Icon(Icons.close, color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
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
                    : const Text('Submit', style: TextStyle(fontSize: 16.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
