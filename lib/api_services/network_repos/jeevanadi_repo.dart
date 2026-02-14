import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/request/JeevanaadiFullProfile.dart';
import 'package:vikas_app/screeens/models/response/jeevanaadi_paginated_view.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

class JeevanadiRepo {
  final _api = NetworkService.instance;

  Future<ApiResult<JeevanaadiPaginatedView>> getJeevanaadisMems(int page, int size) async {
    final result = await _api.get(
      "${ApiConstants.GET_JEEVANAADIS}?page=${page}&size=${size}",
    );
    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      JeevanaadiPaginatedView data = JeevanaadiPaginatedView.fromJson(result.data);
      return ApiResult.success(data);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  Future<ApiResult<User>> getJeevanaadiProfile(String id) async {
    final result = await _api.get("${ApiConstants.GET_JEEVANAADIS}/$id");
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

  //full view jeevandi
  Future<ApiResult<JeevanaadiFullProfile>> getJeevanaadiProfileFull(String id) async {
    final result = await _api.get("${ApiConstants.JEEVANADI_URI}/4883");


    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final profile = JeevanaadiFullProfile.fromJson(result.data);
      return ApiResult.success(profile);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  

  Future<void> deleteKaryakartha(String id) async {
    await _api.delete("${ApiConstants.GET_KARYAKARTHAS_BY_ID}/$id");
  }
}
