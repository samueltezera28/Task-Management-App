import 'package:flutter/material.dart';
import 'package:task_management_app/model/database_helper.dart';
import 'package:task_management_app/services/notification_Service.dart';

class TaskProvider with ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> get tasks => _tasks;

  final NotificationService _notificationService = NotificationService();

  TaskProvider() {
    _loadTasks();
    _notificationService.init();
  }

  Future<void> _loadTasks() async {
    _tasks = await DatabaseHelper().getTasks();
    notifyListeners();
  }

  Future<void> addTask(Map<String, dynamic> task) async {
    await DatabaseHelper().insertTask(task);
    _loadTasks();
    _scheduleNotification(task);
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper().deleteTask(id);
    _loadTasks();
  }

  Future<void> updateTask(Map<String, dynamic> task) async {
    await DatabaseHelper().updateTask(task);
    _loadTasks();
    _scheduleNotification(task);
  }

  void _scheduleNotification(Map<String, dynamic> task) {
    final dueDate = DateTime.parse(task['dueDate']);
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    // print(difference.inMinutes);

    if (difference.inMinutes <= 60 && difference.inMinutes > 0) {
      _notificationService.scheduleNotification(
        task['id'],
        'Task Reminder',
        'Your task "${task['title']}" is due soon!',
        dueDate,
      );
    }
  }
}
