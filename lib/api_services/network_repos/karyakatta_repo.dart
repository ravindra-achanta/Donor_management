import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

class KaryakattaRepo {
  final _api = NetworkService.instance;

  // Future<ApiResult<PaginatedView>> getKaryakarthas(int page, int size) async {
  //   final result = await _api.get(
  //     "${ApiConstants.GET_KARYAKARTHAS}?userType=KARYAKARTHA&page=${page}&size=${size} ",
      
  //   );
  //   if (!result.isSuccess) {
  //     return ApiResult.failure(result.error);
  //   }

  //   try {
  //     PaginatedView data = PaginatedView.fromJson(result.data);
  //     return ApiResult.success(data);
  //   } catch (e) {
  //     return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
  //   }
  // }
  Future<ApiResult<PaginatedView>> getKaryakarthas(
  int page,
  int size,
  String? search,
) async {
  String url =
      "${ApiConstants.GET_KARYAKARTHAS}?userType=KARYAKARTHA&page=$page&size=$size";

  if (search != null && search.isNotEmpty) {
    url += "&searchValue=$search"; 
  }

  final result = await _api.get(url);

  if (!result.isSuccess) {
    return ApiResult.failure(result.error);
  }

  try {
    PaginatedView data = PaginatedView.fromJson(result.data);
    return ApiResult.success(data);
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
      print("Error parsing user data: $e");
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  Future<ApiResult<Map<String, dynamic>>> deleteKaryakartha(String id) async {
    final result = await _api.delete("${ApiConstants.DELETE_USER}/$id");
    
    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final data = result.data as Map<String, dynamic>;
      return ApiResult.success(data);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }
}
