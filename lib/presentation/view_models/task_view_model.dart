// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dailoz/data/models/task.dart';
import 'package:dailoz/domain/usecases/task_usecase.dart';

class TaskState {
  final List<Task> tasks;
  final List<Task> todayTasks;
  final bool isLoading;
  final String? errorMessage;

  TaskState({
    required this.tasks,
    required this.todayTasks,
    this.isLoading = false,
    this.errorMessage,
  });

  TaskState copyWith({
    List<Task>? tasks,
    List<Task>? todayTasks,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      todayTasks: todayTasks ?? this.todayTasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskUseCases _taskUseCases;

  TaskNotifier({
    required TaskUseCases taskUseCases,
  })  : _taskUseCases = taskUseCases,
        super(
          TaskState(
            tasks: [],
            todayTasks: [],
          ),
        );

  Future<void> _refresh() async {
    await getAllTasks();
    await getTodayTasks();
  }

  Future<void> getAllTasks() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _taskUseCases.getAllTasks();
      state = state.copyWith(tasks: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load tasks: ${e.toString()}',
      );
    }
  }

  Future<void> getTodayTasks() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result =
          await _taskUseCases.getTaskByFilter(dueDate: DateTime.now());
      state = state.copyWith(todayTasks: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load today tasks: ${e.toString()}',
      );
    }
  }

  Future<Task?> getTaskById(int id) async {
    try {
      return await _taskUseCases.getTaskById(id);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to get task by id: $id',
      );
    }
    return null;
  }

  Future<bool> createTask(Task task) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await _taskUseCases.createTask(task);
      if (result > 0) {
        await _refresh();
        return true;
      }
      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create task: ${e.toString()}',
      );
      return false;
    }
  }

  Future<bool> updateTask(Task task) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await _taskUseCases.updateTask(task);
      if (result > 0) {
        await _refresh();
        return true;
      }
      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update task: ${e.toString()}',
      );
      return false;
    }
  }

  Future<bool> deleteTask(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await _taskUseCases.deleteTask(id);
      if (result > 0) {
        await _refresh();
        return true;
      }
      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete task: ${e.toString()}',
      );
      return false;
    }
  }

  Future<void> getTasksByFilter({
    String? searchText,
    bool? isCompleted,
    int? priority,
    DateTime? dueDate,
    DateTime? dueDateStart,
    DateTime? dueDateEnd,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _taskUseCases.getTaskByFilter(
        searchText: searchText,
        isCompleted: isCompleted,
        priority: priority,
        dueDate: dueDate,
        dueDateStart: dueDateStart,
        dueDateEnd: dueDateEnd,
      );
      state = state.copyWith(tasks: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load filtered tasks: ${e.toString()}',
      );
    }
  }
}
