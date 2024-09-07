import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/model/taskProvider.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Map<String, dynamic>? task;

  AddEditTaskScreen({this.task});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!['title'];
      _descriptionController.text = widget.task!['description'];
      _dueDate = DateTime.parse(widget.task!['dueDate']);
      _dueDateController.text = _dueDate.toLocal().toString().split(' ')[0];
      _isCompleted = widget.task!['isCompleted'] == 1;
    } else {
      _dueDateController.text = _dueDate.toLocal().toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dueDateController,
                decoration: InputDecoration(
                  labelText: 'Due Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _selectDueDate,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveTask();
                  }
                },
                child: Text(widget.task == null ? 'Save Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate),
      );
      if (pickedTime != null) {
        setState(() {
          _dueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dueDateController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(_dueDate);
        });
      }
    }
  }

  Future<void> _saveTask() async {
    final task = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'dueDate': DateFormat('yyyy-MM-dd HH:mm').format(_dueDate),
      'isCompleted': _isCompleted ? 1 : 0,
    };
    if (widget.task == null) {
      await Provider.of<TaskProvider>(context, listen: false).addTask(task);
    } else {
      task['id'] = widget.task!['id'];
      await Provider.of<TaskProvider>(context, listen: false).updateTask(task);
    }
    Navigator.pop(context); // Return to the home page
  }
}
