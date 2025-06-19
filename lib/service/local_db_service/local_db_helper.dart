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
    final path = join(dbPath, 'xzy_employees.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version){},
    );
  }

  Future<void> createTable(String tableName, Map<String, dynamic> json) async {
    try {
      final db = await database;

      List<String> columns = json.entries.map((entry) {
        final key = entry.key;
        final value = entry.value;
        if (key == 'id') return null;
        final type = value is int
            ? 'INTEGER'
            : value is double
            ? 'REAL'
            : 'TEXT';
        return "$key $type";
      }).whereType<String>().toList();
      String columnString = columns.join(", ");

      String query = "CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY, $columnString)";
      await db.execute(query);
    } catch (e) {
      print(e);
    }
  }

  Future<void> insertEmployee(Employee employee) async {
    final db = await database;
    await db.insert(
      'employees',
      employee.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Employee>> getEmployees() async {
    try {
      final db = await database;
      final result = await db.query('employees');
      return result.map((e) => Employee.fromJson(e)).toList();
    } catch (e) {
      print('Fetch Error: $e');
      return [];
    }
  }

  Future<void> insertAllEmployees(List<Employee> employees) async {
    final db = await database;
    final batch = db.batch();
    for (var emp in employees) {
      batch.insert('employees', emp.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<void> clearEmployees() async {
    final db = await database;
    await db.delete('employees');
  }

  Future<void> dropTable(String tableName) async {
    final db = await database;
    await db.execute("DROP TABLE IF EXISTS $tableName");
  }
}