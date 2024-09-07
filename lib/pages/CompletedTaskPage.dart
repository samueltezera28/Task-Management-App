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
            return const Center(
                child:
                    Text('No completed tasks yet!\nTime to get to work! 💪'));
          } else {
            return ListView.builder(
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                final task = completedTasks[index];
                return ListTile(
                  title: Text(
                    '${index + 1}. ${task['title']}',
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
