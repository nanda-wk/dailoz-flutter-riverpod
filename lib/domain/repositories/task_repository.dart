import 'package:dailoz/data/models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getAllTasks();
  Future<Task?> getTaskById(int id);
  Future<int> createTask(Task task);
  Future<int> updateTask(Task task);
  Future<int> deleteTask(int id);
  Future<List<Task>> getTaskByFilter({
    String? searchText,
    bool? isCompleted,
    int? priority,
    DateTime? dueDate,
    DateTime? dueDateStart,
    DateTime? dueDateEnd,
  });
}
