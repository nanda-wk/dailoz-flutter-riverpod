import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:dailoz/core/di/dependency_injection.dart';
import 'package:dailoz/data/models/task.dart';
import 'package:dailoz/presentation/screens/task_editing_screen.dart';

class TaskListCard extends ConsumerWidget {
  final Task task;

  const TaskListCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(taskNotifierProvider.notifier);
    final dateFormat = DateFormat('MMM dd, yyyy');
    final priorityColors = {
      Priority.low.name: Colors.green,
      Priority.medium.name: Colors.orange,
      Priority.high.name: Colors.red,
    };

    Future<void> toggleCompletion() async {
      final updatedTask = task.copyWith(
        isCompleted: !task.isCompleted,
      );
      await notifier.updateTask(updatedTask);
    }

    void showDeleteConfirmation() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Task'),
          content: Text('Are you sure you want to delete "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref.read(taskNotifierProvider.notifier).deleteTask(task.id!);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColors[task.priority],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.priority.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.description,
              style: TextStyle(
                color: Colors.grey[700],
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            const SizedBox(height: 8),
            if (task.dueDate != null)
              Text(
                'Due: ${dateFormat.format(task.dueDate!)}',
                style: TextStyle(
                  color: task.dueDate!.isBefore(DateTime.now()) &&
                          !task.isCompleted
                      ? Colors.red
                      : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Created: ${dateFormat.format(task.createdAt)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        task.isCompleted
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: task.isCompleted ? Colors.green : Colors.grey,
                      ),
                      onPressed: toggleCompletion,
                      tooltip: task.isCompleted
                          ? 'Mark as incomplete'
                          : 'Mark as complete',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TaskEditingScreen(
                              id: task.id,
                            ),
                          ),
                        );
                      },
                      tooltip: 'Edit task',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: showDeleteConfirmation,
                      tooltip: 'Delete task',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
