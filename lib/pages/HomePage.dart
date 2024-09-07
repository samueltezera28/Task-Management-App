import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/model/quoteService.dart';
import 'package:task_management_app/model/taskProvider.dart';
import 'package:task_management_app/pages/AddTaskPage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _quote = 'Fetching quote...';
  final QuoteService _quoteService = QuoteService();

  @override
  void initState() {
    super.initState();
    _fetchQuote();
  }

  Future<void> _fetchQuote() async {
    try {
      final quote = await _quoteService.fetchQuote();
      setState(() {
        _quote = quote;
      });
    } catch (e) {
      setState(() {
        _quote = 'Oops! No internet. Even the best of us need a break!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '"${_quote}"',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Consumer<TaskProvider>(
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
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddEditTaskScreen(task: task)));
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                              onPressed: () {
                                taskProvider.deleteTask(task['id']);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
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
