import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

class ProfileRepo {
  final _api = NetworkService.instance;

  Future<ApiResult<User>> getProfile(String id) async {
    final result = await _api.get("${ApiConstants.GET_USER_BY_ID}/$id");
    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final data = result.data;
      User user = User.fromJson(data);
      return ApiResult.success(user);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }


Future<ApiResult<User>> editProfile(String id, User user) async {
  final result = await _api.put(
    "${ApiConstants.UPDATE_PROFILE}/$id",
    body: user.toJson(),
  );

  if (!result.isSuccess) {
    return ApiResult.failure(result.error);
    
  }

  try {
    return ApiResult.success(User.fromJson(result.data));
  } catch (e) {
    return ApiResult.failure(
      ApiError(message: "Data parsing error: $e"),
    );
  }
}

  
}
