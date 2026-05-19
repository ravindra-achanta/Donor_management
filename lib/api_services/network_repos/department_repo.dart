import 'package:nb_utils/nb_utils.dart';
import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/request/DepartmentRequest.dart';
import 'package:vikas_app/screeens/models/response/DepartmentResponse.dart';

class DepartmentRepo {
  final _api = NetworkService.instance;

  // GET ALL DEPARTMENTS
  Future<ApiResult<List<DepartmentResponse>>> getAllDepartments() async {
    final url = "${ApiConstants.VIKAS}/departments";
    final result = await _api.get(url);
    
    if (result.isSuccess) {
      final data = result.data as List;
      final departments = data
          .map((json) => DepartmentResponse.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResult.success(departments);
    }
    return ApiResult.failure(result.error ?? ApiError(message: 'Failed to fetch departments'));
  }

  // GET DEPARTMENT BY ID
  Future<ApiResult<DepartmentResponse>> getDepartmentById(int id) async {
    final url = "${ApiConstants.VIKAS}/departments/$id";
    final result = await _api.get(url);
    
    if (result.isSuccess) {
      final department = DepartmentResponse.fromJson(result.data);
      return ApiResult.success(department);
    }
    return ApiResult.failure(result.error ?? ApiError(message: 'Failed to fetch department'));
  }

  // CREATE DEPARTMENT
  Future<ApiResult<DepartmentResponse>> createDepartment(
      DepartmentRequest request) async {
    final url = "${ApiConstants.VIKAS}/departments";
    final result = await _api.post(url, body: request.toJson());
    
    if (result.isSuccess) {
      final department = DepartmentResponse.fromJson(result.data);
      return ApiResult.success(department);
    }
    return ApiResult.failure(result.error ?? ApiError(message: 'Failed to create department'));
  }

  // UPDATE DEPARTMENT
 // UPDATE DEPARTMENT
Future<ApiResult<DepartmentResponse>> updateDepartment(
    String id, DepartmentRequest request) async {  // ✅ String id
  final url = "${ApiConstants.VIKAS}/departments/$id";
  final result = await _api.put(url, body: request.toJson());
  
  if (result.isSuccess) {
    final department = DepartmentResponse.fromJson(result.data);
    return ApiResult.success(department);
  }
  return ApiResult.failure(result.error ?? ApiError(message: 'Failed to update department'));
}

// DELETE DEPARTMENT
Future<ApiResult<String>> deleteDepartment(String id) async {  // ✅ String id
  final url = "${ApiConstants.VIKAS}/departments/$id";
  final result = await _api.delete(url);
  
  if (result.isSuccess) {
    return ApiResult.success('Department deleted successfully');
  }
  return ApiResult.failure(result.error ?? ApiError(message: 'Failed to delete department'));
}
}