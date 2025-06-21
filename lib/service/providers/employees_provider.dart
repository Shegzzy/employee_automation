import 'package:flutter/material.dart';
import 'package:mobile_assessment/service/api_services/api_services.dart';
import 'package:mobile_assessment/service/local_db_service/local_db_helper.dart';
import '../../models/employee_model.dart';

class EmployeeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalDatabaseService _dbService = LocalDatabaseService();

  List<Employee> _employees = [];
  List<Employee> get employees => _employees;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadEmployees({bool simulateError = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      List<Employee> fetched = [];
      await _dbService.createTable('employees', Employee.sampleJson());

      fetched = await _dbService.getEmployees();

      if (fetched.isEmpty) {
        if (simulateError) {
          fetched = await _apiService.errorResponse();
        } else {
          fetched = await _apiService.successResponse();
          await _dbService.insertAllEmployees(fetched);
        }
      }

      _employees = fetched;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterEmployees(String query) {
    final all = _employees;
    _employees = all.where((e) =>
    e.firstName.toLowerCase().contains(query.toLowerCase()) || e.lastName.toLowerCase().contains(query.toLowerCase()) ||
        e.designation.toLowerCase().contains(query.toLowerCase()) ||
        e.level.toString().contains(query)
    ).toList();
    notifyListeners();
  }

  void resetFilter() async {
    _employees = await _dbService.getEmployees();
    notifyListeners();
  }

  Future<void> refresh() async {
    try {
      final fetched = await _dbService.getEmployees();
      _employees = fetched;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> saveChanges(Employee employee) async {
    await _dbService.insertEmployee(employee);
    await refresh();
  }

}
