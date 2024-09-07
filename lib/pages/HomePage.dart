import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/services/quoteService.dart';
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
          _buildQuoteSection(),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                return taskProvider.tasks.isEmpty
                    ? _buildNoTasksMessage()
                    : _buildTaskList(taskProvider);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildQuoteSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        '"$_quote"',
        style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildNoTasksMessage() {
    return const Center(
      child: Text(
        'No tasks available!\nTime to add some tasks and get productive! 🚀',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTaskList(TaskProvider taskProvider) {
    return ListView.builder(
      itemCount: taskProvider.tasks.length,
      itemBuilder: (context, index) {
        final task = taskProvider.tasks[index];
        return _buildDismissibleTask(taskProvider, task);
      },
    );
  }

  Widget _buildDismissibleTask(
      TaskProvider taskProvider, Map<String, dynamic> task) {
    return Dismissible(
      key: Key(task['id'].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        taskProvider.deleteTask(task['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task "${task['title']}" deleted'),
          ),
        );
      },
      background: _buildDismissibleBackground(),
      child: _buildTaskTile(taskProvider, task),
    );
  }

  Widget _buildDismissibleBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTaskTile(TaskProvider taskProvider, Map<String, dynamic> task) {
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
      subtitle: _buildTaskSubtitle(task),
      trailing: _buildTaskActions(context, taskProvider, task),
    );
  }

  Widget _buildTaskSubtitle(Map<String, dynamic> task) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${task['description']}\nDue Date: ${task['dueDate']}\n',
            style: TextStyle(
              decoration: task['isCompleted'] == 1
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          TextSpan(
            text:
                'Status: ${task['isCompleted'] == 1 ? 'Completed' : 'Incomplete'}',
            style: const TextStyle(
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskActions(BuildContext context, TaskProvider taskProvider,
      Map<String, dynamic> task) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditTaskScreen(task: task),
              ),
            );
          },
          icon: const Icon(Icons.edit),
        ),
        IconButton(
          onPressed: () {
            taskProvider.deleteTask(task['id']);
          },
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AddEditTaskScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
