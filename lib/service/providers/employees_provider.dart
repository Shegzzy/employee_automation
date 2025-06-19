import 'package:flutter/material.dart';
import 'package:mobile_assessment/service/local_db_service/local_db_helper.dart';
import '../../common/io/data.dart';
import '../../models/employee_model.dart';

class EmployeeProvider extends ChangeNotifier {
  final Api _apiService = Api();
  final LocalDatabaseService _dbService = LocalDatabaseService();

  List<Employee> _employees = [];
  List<Employee> get employees => _employees;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Initial load (from DB or API)
  Future<void> loadEmployees({bool fromApi = true, bool simulateError = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      List<Employee> fetched;

      if (fromApi) {
        if (simulateError) {
          fetched = await _apiService.errorResponse();
        } else {
          fetched = await _apiService.successResponse();
          await _dbService.clearEmployees();
          await _dbService.insertAllEmployees(fetched);
        }
      } else {
        fetched = await _dbService.getEmployees();
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
}
