import 'package:intl/intl.dart';

import 'package:dailoz/core/app_constants.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Task {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final String priority;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.priority,
    this.dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      AppConstants.columnId: id,
      AppConstants.columnTitle: title,
      AppConstants.columnDescription: description,
      AppConstants.columnIsCompleted: isCompleted ? 1 : 0,
      AppConstants.columnPriority: priority,
      AppConstants.columnDueDate:
          dueDate != null ? DateFormat('yyyy-MM-dd').format(dueDate!) : null,
      AppConstants.columnCreatedAt: createdAt.toIso8601String(),
      AppConstants.columnUpdatedAt: updatedAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map[AppConstants.columnId],
      title: map[AppConstants.columnTitle],
      description: map[AppConstants.columnDescription],
      isCompleted: map[AppConstants.columnIsCompleted] == 1,
      priority: map[AppConstants.columnPriority],
      dueDate: map[AppConstants.columnDueDate] != null
          ? DateTime.parse(map[AppConstants.columnDueDate])
          : null,
      createdAt: DateTime.parse(map[AppConstants.columnCreatedAt]),
      updatedAt: DateTime.parse(map[AppConstants.columnUpdatedAt]),
    );
  }
}
