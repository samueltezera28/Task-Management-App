import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/model/taskProvider.dart';

class CompletedTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final completedTasks = taskProvider.tasks
              .where((task) => task['isCompleted'] == 1)
              .toList();

          if (completedTasks.isEmpty) {
            return Center(child: Text('No completed tasks available'));
          } else {
            return ListView.builder(
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                final task = completedTasks[index];
                return ListTile(
                  title: Text(
                    task['title'],
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  subtitle: Text(
                    '${task['description']}\nDue Date: ${task['dueDate']}\nStatus: Completed',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
