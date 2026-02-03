import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

class KaryakattaRepo {
  final _api = NetworkService.instance;

  Future<ApiResult<List<User>>> getKaryakarthas() async {
    final result = await _api.get(ApiConstants.GET_KARYAKARTHAS);
    // print("data----------------------: ${result.data} ?? ${result.error}");
    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final data = result.data;
      final usersData = data["listView"] as List;

      final users = usersData.map((json) => User.fromJson(json)).toList();

      return ApiResult.success(users);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  Future<ApiResult<User>> getKaryakarthaProfile(String id) async {
    final result = await _api.get("${ApiConstants.GET_KARYAKARTHAS_BY_ID}/$id");
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

  Future<void> deleteKaryakartha(String id) async {
    await _api.delete("${ApiConstants.GET_KARYAKARTHAS_BY_ID}/$id");
  }
}
