// CleanerActivityController.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CleanerActivityController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = false;

  // Getter to expose tasks
  List<Map<String, dynamic>> get tasks => _tasks;

  // Getter to check loading state
  bool get isLoading => _isLoading;

  // Fetch tasks from Firestore
  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore.collection('bookings').get();
      _tasks = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print('Failed to fetch tasks: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Update task in Firestore
  Future<void> updateTask(String taskId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('bookings').doc(taskId).update(updatedData);
      final index = _tasks.indexWhere((task) => task['id'] == taskId);
      if (index != -1) {
        _tasks[index] = {'id': taskId, ...updatedData};
        notifyListeners();
      }
    } catch (e) {
      print('Failed to update task: $e');
    }
  }

  // Add a new task (optional feature)
  Future<void> addTask(Map<String, dynamic> newTask) async {
    try {
      final docRef = await _firestore.collection('bookings').add(newTask);
      _tasks.add({'id': docRef.id, ...newTask});
      notifyListeners();
    } catch (e) {
      print('Failed to add task: $e');
    }
  }

  // Delete task (optional feature)
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('bookings').doc(taskId).delete();
      _tasks.removeWhere((task) => task['id'] == taskId);
      notifyListeners();
    } catch (e) {
      print('Failed to delete task: $e');
    }
  }
}
