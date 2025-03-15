import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:dailoz/core/app_constants.dart';
import 'package:dailoz/data/models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path =
        join(await getDatabasesPath(), AppConstants.databaseName);
    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE ${AppConstants.taskTable} (
        ${AppConstants.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.columnTitle} TEXT NOT NULL,
        ${AppConstants.columnDescription} TEXT NOT NULL,
        ${AppConstants.columnIsCompleted} INTEGER NOT NULL,
        ${AppConstants.columnCreatedAt} TEXT NOT NULL,
        ${AppConstants.columnUpdatedAt} TEXT NOT NULL,
        ${AppConstants.columnDueDate} TEXT,
        ${AppConstants.columnPriority} TEXT NOT NULL
      )
      ''',
    );
  }

  Future<int> insert({
    String table = AppConstants.taskTable,
    required Task task,
  }) async {
    final db = await database;
    return db.insert(
      table,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update({
    String table = AppConstants.taskTable,
    required Task task,
  }) async {
    final db = await database;
    return db.update(
      table,
      task.toMap(),
      where: '${AppConstants.columnId} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete({
    String table = AppConstants.taskTable,
    required int id,
  }) async {
    final db = await database;
    return db.delete(
      table,
      where: '${AppConstants.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(AppConstants.taskTable);
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<Task?> getTaskById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.taskTable,
      where: '${AppConstants.columnId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Task>> getTasksByFilter({
    String? searchText,
    bool? isCompleted,
    int? priority,
    DateTime? dueDate,
    DateTime? dueDateStart,
    DateTime? dueDateEnd,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    final formattedDueDate =
        dueDate != null ? DateFormat('yyyy-MM-dd').format(dueDate) : '';
    final formattedDueDateStart = dueDateStart != null
        ? DateFormat('yyyy-MM-dd').format(dueDateStart)
        : '';
    final formattedDueDateEnd =
        dueDateEnd != null ? DateFormat('yyyy-MM-dd').format(dueDateEnd) : '';

    if (searchText != null) {
      whereClause +=
          '${AppConstants.columnTitle} LIKE ? OR ${AppConstants.columnDescription} LIKE ?';
      whereArgs.add(searchText);
      whereArgs.add(searchText);
    }

    if (isCompleted != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += '${AppConstants.columnIsCompleted} = ?';
      whereArgs.add(isCompleted ? 1 : 0);
    }

    if (priority != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += '${AppConstants.columnPriority} = ?';
      whereArgs.add(priority);
    }

    if (dueDateStart != null && dueDateEnd != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += '${AppConstants.columnDueDate} BETWEEN ? AND ?';
      whereArgs.add(formattedDueDateStart);
      whereArgs.add(formattedDueDateEnd);
    } else if (dueDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += '${AppConstants.columnDueDate} = ?';
      whereArgs.add(formattedDueDate);
    } else if (dueDateStart != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += '${AppConstants.columnDueDate} >= ?';
      whereArgs.add(formattedDueDateStart);
    } else if (dueDateEnd != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += '${AppConstants.columnDueDate} <= ?';
      whereArgs.add(formattedDueDateEnd);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.taskTable,
      where: whereClause,
      whereArgs: whereArgs,
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }
}
