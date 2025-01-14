import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TaskDetailPage extends StatefulWidget {
  final Map<String, String> task;

  TaskDetailPage({required this.task});

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final List<File?> _images = [null, null, null, null];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images[index] = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Activity'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task["homestay"] ?? "",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _pickImage(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: _images[index] == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt,
                                    size: 40.0, color: Colors.grey),
                                SizedBox(height: 8.0),
                                Text('Photo'),
                              ],
                            )
                          : kIsWeb
                              ? Image.network(
                                  'https://via.placeholder.com/150', // Placeholder for web
                                  fit: BoxFit.cover,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.file(
                                    _images[index]!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Additional Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Update Successful')),
                    );
                    Navigator.pop(context);
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
