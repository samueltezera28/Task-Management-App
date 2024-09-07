import 'package:flutter/material.dart';
import 'package:task_management_app/model/database_helper.dart';

class TaskProvider with ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> get tasks => _tasks;

  TaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _tasks = await DatabaseHelper().getTasks();
    notifyListeners();
  }

  Future<void> addTask(Map<String, dynamic> task) async {
    await DatabaseHelper().insertTask(task);
    _loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper().deleteTask(id);
    _loadTasks();
  }

  Future<void> updateTask(Map<String, dynamic> task) async {
    await DatabaseHelper().updateTask(task);
    _loadTasks();
  }
}
