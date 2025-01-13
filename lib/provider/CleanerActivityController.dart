import 'package:flutter/material.dart';

class CleanerActivityController with ChangeNotifier {
  // List to hold the cleaning tasks
  final List<Map<String, dynamic>> _tasks = [];

  // Getter to expose tasks
  List<Map<String, dynamic>> get tasks => _tasks;

  // Add a new cleaning task
  void addTask(Map<String, dynamic> newTask) {
    _tasks.add(newTask);
    notifyListeners(); // Notify listeners about the state change
  }

  // Update an existing task
  void updateTask(int index, Map<String, dynamic> updatedTask) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  // Remove a task by index
  void removeTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
      notifyListeners();
    }
  }
}
