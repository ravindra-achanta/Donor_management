import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

class OfficeStaffRepo {
  final _api = NetworkService.instance;


  Future<ApiResult<PaginatedView>> getOfficeStaff(
    int page,
    int size,
    String? search,
  ) async {
    String url =
        "${ApiConstants.GET_OFFICE_STAFF}?userType=OFFICE_STAFF&page=$page&size=$size";

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
      return ApiResult.failure(
        ApiError(message: "Data parsing error: $e"),
      );
    }
  }
  Future<ApiResult<User>> getOfficeStaffProfile(String id) async {
  final result =
      await _api.get("${ApiConstants.GET_OFFICE_STAFF_BY_ID}/$id");

  if (!result.isSuccess) {
    return ApiResult.failure(result.error);
  }

  try {
    User user = User.fromJson(result.data);
    return ApiResult.success(user);
  } catch (e) {
    return ApiResult.failure(
      ApiError(message: "Data parsing error: $e"),
    );
  }
}
}