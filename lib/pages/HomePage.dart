import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/model/taskProvider.dart';
import 'package:task_management_app/pages/AddTaskPage.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.tasks.isEmpty) {
            return const Center(child: Text('No tasks available'));
          } else {
            return ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return ListTile(
                  leading: Checkbox(
                    value: task['isCompleted'] == 1,
                    onChanged: (bool? value) {
                      final updatedTask = {
                        ...task,
                        'isCompleted': value! ? 1 : 0,
                      };
                      taskProvider.updateTask(updatedTask);
                    },
                  ),
                  title: Text(
                    task['title'],
                    style: TextStyle(
                      decoration: task['isCompleted'] == 1
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    '${task['description']}\nDue Date: ${task['dueDate']}\nStatus: ${task['isCompleted'] == 1 ? 'Completed' : 'Incomplete'}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddEditTaskScreen(task: task),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => taskProvider.deleteTask(task['id']),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
