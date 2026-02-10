import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/enum/user_type.dart';
import 'package:vikas_app/screeens/models/request/login_request.dart';

import 'package:vikas_app/screeens/models/response/login_response.dart';

class AuthRepository {
  final _api = NetworkService.instance;

  Future<ApiResult<LoginResponse>> login(
    String mobileNumber,
    String password,
    UserType userType,
  ) async {
    final request = LoginRequest(
      mobileNumber: mobileNumber,
      password: password,
    );

    final result = await _api.post(
      "${ApiConstants.IDM_URI}/user/login/${userType.toPath}",
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

  Future<dynamic> isAuthenticated() async {}

  Future<dynamic> getStoredAuthData() async {}
}