import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/screeens/models/request/change_password_request.dart';
import 'package:vikas_app/screeens/models/request/identity_request.dart';
import 'package:vikas_app/screeens/models/request/login_request.dart';
import 'package:vikas_app/screeens/models/response/login_response.dart';
import 'package:vikas_app/screeens/models/response/role_response.dart';
import 'package:vikas_app/screeens/models/response/users_response.dart';

class AuthRepository {
  final _api = NetworkService.instance;

  Future<ApiResult<LoginResponse>> login(
  String mobileNumber,
  String password,  
  String roleName,    
) async {
  final request = LoginRequest(
    mobileNumber: mobileNumber,
    password: password,
  );

  final result = await _api.post(
    "${ApiConstants.IDM_URI}/user/login/$roleName",  // ← use rolePath
    body: request.toJson(),
  );

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      LoginResponse data = LoginResponse.fromJson(result.data);
      return ApiResult.success(data);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }
Future<ApiResult<LoginResponse>> createUser(
    IdentityRequest request,
  ) async {
    final result = await _api.post(
      "${ApiConstants.IDM_URI}/user/create",
      body: request.toJson(),
    );

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      LoginResponse data = LoginResponse.fromJson(result.data);
      return ApiResult.success(data);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  Future<ApiResult<UsersResponse>> getAllUsers({
    int page = 0,
    int size = 10,
  }) async {
    final result = await _api.get(
      "${ApiConstants.GET_USERS}?page=$page&size=$size",
    );

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      UsersResponse data = UsersResponse.fromJson(result.data);
      return ApiResult.success(data);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }


   Future<ApiResult<List<Role>>> getRoles() async {
    final result = await _api.get(
      "${ApiConstants.GET_ROLES}",
    );

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      List<Role> roles = [];
      for (var item in result.data) {
        try {
          final role = Role.fromJson(item);
          if (role.status == 'ACTIVE') {
            roles.add(role);
          }
        } catch (e) {
          print('Error parsing role: $e');
        }
      }
      
      return ApiResult.success(roles);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  Future<ApiResult<bool>> changePassword(
    String newPassword,
    String mobileNumber,
  ) async {
    final request = ChangePasswordRequest(
      newPassword: newPassword,
      mobileNumber: mobileNumber,
    );

    final result = await _api.put(
      ApiConstants.CHANGE_PASSWORD,
     
      body: request.toJson(),
    );

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      // Assuming the API returns a success message or boolean
      return ApiResult.success(true);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final token = await Vikasdb().getString("TOKEN");
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, String?>> getStoredAuthData() async {
    try {
      final token = await Vikasdb().getString("TOKEN");
      final userId = await Vikasdb().getString("USER_ID");
      final userType = await Vikasdb().getString("USER_TYPE");
      
      return {
        'token': token,
        'userId': userId,
        'userType': userType,
      };
    } catch (e) {
      return {};
    }
  }
}
