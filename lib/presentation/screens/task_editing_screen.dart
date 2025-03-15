import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:dailoz/core/di/dependency_injection.dart';
import 'package:dailoz/data/models/task.dart';

class TaskEditingScreen extends ConsumerStatefulWidget {
  final int? id;
  const TaskEditingScreen({this.id, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TaskEditingScreenState();
}

class _TaskEditingScreenState extends ConsumerState<TaskEditingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priorities = Priority.values.map((e) => e.name).toList();

  Task? _existingTask;
  String _priority = Priority.low.name;
  DateTime? _dueDate;
  bool _isEditing = false;
  bool _isCompleted = false;

  Future<void> _loadTaskIfEditing() async {
    if (widget.id == null) return;

    setState(() {
      _isEditing = true;
    });

    try {
      final todo =
          await ref.read(taskNotifierProvider.notifier).getTaskById(widget.id!);
      if (todo != null) {
        setState(() {
          _existingTask = todo;
          _titleController.text = todo.title;
          _descriptionController.text = todo.description;
          _isCompleted = todo.isCompleted;
          _priority = todo.priority;
          _dueDate = todo.dueDate;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading task: $e')),
      );
    }
  }

  void _onSelection(Set<String> newSelections) {
    setState(() {
      _priority = newSelections.first;
    });
  }

  Future<void> _selectDueDate() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year + 100),
    );

    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final task = Task(
        id: _isEditing ? _existingTask!.id : null,
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: _isCompleted,
        priority: _priority,
        dueDate: _dueDate,
        createdAt: _isEditing ? _existingTask!.createdAt : null,
      );
      bool success = _isEditing
          ? await ref.read(taskNotifierProvider.notifier).updateTask(task)
          : await ref.read(taskNotifierProvider.notifier).createTask(task);

      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save task.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving task: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTaskIfEditing();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Task' : 'Add Task',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 30,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text('Title'),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        controller: _titleController,
                      ),
                      TextFormField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          label: Text('Description'),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                        controller: _descriptionController,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<String>(
                          segments: _priorities
                              .map((priority) => ButtonSegment(
                                    value: priority,
                                    label: Text(
                                      priority.toUpperCase(),
                                    ),
                                  ))
                              .toList(),
                          selected: {_priority},
                          onSelectionChanged: _onSelection,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(_dueDate == null
                                ? 'No due date.'
                                : 'Due Date: ${DateFormat('MMM d, yyyy').format(_dueDate!)}'),
                          ),
                          TextButton(
                            onPressed: _selectDueDate,
                            child: Text(
                              _dueDate == null ? 'Set Due Date' : 'Change',
                            ),
                          ),
                        ],
                      ),
                      if (_isEditing)
                        CheckboxListTile(
                          title: const Text('Mark as completed'),
                          value: _isCompleted,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _isCompleted = value;
                              });
                            }
                          },
                        )
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _saveTask,
                    child: Text(
                      _isEditing ? 'Update' : 'Create',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum Priority { low, medium, high }
