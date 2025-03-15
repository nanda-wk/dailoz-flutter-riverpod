import 'package:dailoz/data/models/task.dart';
import 'package:dailoz/domain/repositories/task_repository.dart';

class TaskUseCases {
  final TaskRepository _repository;

  TaskUseCases(this._repository);

  Future<List<Task>> getAllTasks() async {
    return await _repository.getAllTasks();
  }

  Future<Task?> getTaskById(int id) async {
    return await _repository.getTaskById(id);
  }

  Future<int> createTask(Task task) async {
    return await _repository.createTask(task);
  }

  Future<int> updateTask(Task task) async {
    return await _repository.updateTask(task);
  }

  Future<int> deleteTask(int id) async {
    return await _repository.deleteTask(id);
  }

  Future<List<Task>> getTaskByFilter({
    String? searchText,
    bool? isCompleted,
    int? priority,
    DateTime? dueDate,
    DateTime? dueDateStart,
    DateTime? dueDateEnd,
  }) async {
    return await _repository.getTaskByFilter(
      searchText: searchText,
      isCompleted: isCompleted,
      priority: priority,
      dueDate: dueDate,
      dueDateStart: dueDateStart,
      dueDateEnd: dueDateEnd,
    );
  }
}
