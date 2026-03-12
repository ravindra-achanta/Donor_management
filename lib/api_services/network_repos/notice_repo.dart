import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/request/notice_request.dart';
import 'package:vikas_app/screeens/models/response/notice_response.dart';

class NoticeRepo {
  final NetworkService _api = NetworkService.instance;


  Future<ApiResult<List<NoticeResponse>>> getNotices() async {
    final result = await _api.get(ApiConstants.noticesList);

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final List<NoticeResponse> notices = (result.data as List)
          .map((e) => NoticeResponse.fromJson(e))
          .toList();
      return ApiResult.success(notices);
    } catch (e) {
      print("Error parsing notices: $e");
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  /// CREATE NOTICE
  Future<ApiResult<NoticeResponse>> createNotice(NoticeRequest request) async {
    final result = await _api.post(
      ApiConstants.noticesCreate,
      body: request.toJson(),
    );

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final notice = NoticeResponse.fromJson(result.data);
      return ApiResult.success(notice);
    } catch (e) {
      print("Error parsing created notice: $e");
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  /// UPDATE NOTICE
Future<ApiResult<NoticeResponse>> updateNotice(
    String id, NoticeRequest request) async {
  
  final updatePayload = {
    'image': request.image,         
    'title': request.title,
    'description': request.description,
    'status': 'ACTIVE',             
  };

 
  final url = '${ApiConstants.noticesUpdate}?id=$id';

  final result = await _api.put(
    url,
    body: updatePayload,              
  );

  if (!result.isSuccess) {
    return ApiResult.failure(result.error);
  }

  try {
    final notice = NoticeResponse.fromJson(result.data);
    return ApiResult.success(notice);
  } catch (e) {
    print("Error parsing updated notice: $e");
    return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
  }
}

 
  /// MARK NOTICE AS READ
Future<ApiResult<bool>> markNoticeAsRead(String id) async {
  final url = ApiConstants.noticesRead.replaceAll("{id}", id);

  print("REQUEST → PUT $url");

  final result = await _api.put(url);

 

  if (!result.isSuccess) {
    return ApiResult.failure(result.error);
  }

  return ApiResult.success(true);
}

  /// DELETE NOTICE
  /// Assumes you have defined `noticesDelete` in `ApiConstants` as:
  /// `static const String noticesDelete = "$VIKAS/notice/{id}";`
  // Future<ApiResult<bool>> deleteNotice(String id) async {
  //   final url = ApiConstants.noticesDelete.replaceAll("{id}", id);
  //   final result = await _api.delete(url);

  //   if (!result.isSuccess) {
  //     return ApiResult.failure(result.error);
  //   }

  //   return ApiResult.success(true);
  // }
}