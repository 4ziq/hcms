import 'package:flutter/material.dart';

class TaskDetailPage extends StatefulWidget {
  final Map<String, dynamic> activity;

  const TaskDetailPage({Key? key, required this.activity}) : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TextEditingController _notesController = TextEditingController();
  String _status = "Pending";

  @override
  void initState() {
    super.initState();
    _status = widget.activity['status'];
  }

  void _updateStatus(String newStatus) {
    setState(() {
      _status = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status updated to $newStatus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Task: ${widget.activity['taskDescription']}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Date: ${widget.activity['date']}'),
            const SizedBox(height: 16),
            const Text('Update Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _status,
              items: ['Pending', 'In Progress', 'Completed']
                  .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  _updateStatus(value);
                }
              },
            ),
            const SizedBox(height: 16),
            const Text('Additional Notes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter notes',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle save action
                Navigator.pop(context, {
                  'status': _status,
                  'notes': _notesController.text,
                });
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
