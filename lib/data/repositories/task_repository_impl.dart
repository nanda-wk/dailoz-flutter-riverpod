import 'package:dailoz/data/datasources/local/database_helper.dart';
import 'package:dailoz/data/models/task.dart';
import 'package:dailoz/domain/repositories/task_repository.dart';

class TaskRepositoryImpl extends TaskRepository {
  final DatabaseHelper _databaseHelper;

  TaskRepositoryImpl({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  @override
  Future<int> createTask(Task task) async {
    return await _databaseHelper.insert(task: task);
  }

  @override
  Future<int> deleteTask(int id) async {
    return await _databaseHelper.delete(id: id);
  }

  @override
  Future<List<Task>> getAllTasks() async {
    return await _databaseHelper.getTasks();
  }

  @override
  Future<List<Task>> getTaskByFilter({
    String? searchText,
    bool? isCompleted,
    int? priority,
    DateTime? dueDate,
    DateTime? dueDateStart,
    DateTime? dueDateEnd,
  }) async {
    return await _databaseHelper.getTasksByFilter(
      searchText: searchText,
      isCompleted: isCompleted,
      priority: priority,
      dueDate: dueDate,
      dueDateStart: dueDateStart,
      dueDateEnd: dueDateEnd,
    );
  }

  @override
  Future<Task?> getTaskById(int id) async {
    return await _databaseHelper.getTaskById(id);
  }

  @override
  Future<int> updateTask(Task task) async {
    return await _databaseHelper.update(task: task);
  }
}
