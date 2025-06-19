import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/employee_model.dart';

class LocalDatabaseService {
  static final LocalDatabaseService _instance = LocalDatabaseService._internal();
  factory LocalDatabaseService() => _instance;
  LocalDatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDB();
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'employees.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version){},
    );
  }

  Future<void> createTable(String tableName, Map<String, dynamic> json) async {
    final db = await database;

    // Generate Columns based on JSON Keys
    List<String> columns = json.keys.map((key) => "$key TEXT").toList();
    String columnString = columns.join(", ");

    // Create Table Query
    String query = "CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY, $columnString)";
    await db.execute(query);
  }

  Future<void> insertEmployee(Employee employee) async {
    final db = await database;
    await db.insert(
      'employees',
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Employee>> getEmployees() async {
    final db = await database;
    final result = await db.query('employees');
    return result.map((e) => Employee.fromMap(e)).toList();
  }

  Future<void> insertAllEmployees(List<Employee> employees) async {
    final db = await database;
    final batch = db.batch();
    for (var emp in employees) {
      batch.insert('employees', emp.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<void> clearEmployees() async {
    final db = await database;
    await db.delete('employees');
  }
}