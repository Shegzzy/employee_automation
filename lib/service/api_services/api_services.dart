import '../../common/io/data.dart';
import '../../models/employee_model.dart';

class ApiService {
  Future<List<Employee>> successResponse() async {
    await Future.delayed(const Duration(seconds: 3));

    final List<dynamic> rawData = Api.successResponse['data'] ?? [];
    return rawData.map((e) => Employee.fromJson(e)).toList();
  }

  Future<List<Employee>> errorResponse() async {
    await Future.delayed(const Duration(seconds: 2));
    throw Exception(Api.errorResponse['message'] ?? 'Unknown error');
  }
}
