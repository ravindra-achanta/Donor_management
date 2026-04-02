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


Future<ApiResult<User>> updateUser(String id, User user) async {
  final url = "${ApiConstants.UPDATE_USER}/$id";
  final body = user.toJson();
  
  print("🔄 [ProfileRepo] Updating user at: $url");
  print("📦 [ProfileRepo] Request body: $body");
  
  final result = await _api.put(url, body: body);

  if (!result.isSuccess) {
    print("❌ [ProfileRepo] Update failed - Error: ${result.error?.message}");
    print("❌ [ProfileRepo] Raw error: ${result.error}");
    return ApiResult.failure(result.error);
  }

  try {
    print("✅ [ProfileRepo] Update successful");
    return ApiResult.success(User.fromJson(result.data));
  } catch (e) {
    print("❌ [ProfileRepo] Parse error: $e");
    return ApiResult.failure(
      ApiError(message: "Data parsing error: $e"),
    );
  }
}

 Future<ApiResult<User>> updateProfile(String id, User user) async {
    final url = "${ApiConstants.UPDATE_PROFILE}/$id";
    final body = user.toJson();
    
    print("🔄 [ProfileRepo] Updating profile at: $url");
    print("📦 [ProfileRepo] Request body: $body");
    
    final result = await _api.put(url, body: body);

    if (!result.isSuccess) {
      print("❌ [ProfileRepo] Profile update failed - Error: ${result.error?.message}");
      return ApiResult.failure(result.error);
    }
     try {
      print("✅ [ProfileRepo] Profile update successful");
      return ApiResult.success(User.fromJson(result.data));
    } catch (e) {
      print("❌ [ProfileRepo] Parse error: $e");
      return ApiResult.failure(
        ApiError(message: "Data parsing error: $e"),
      );
    }
  }

  
}
