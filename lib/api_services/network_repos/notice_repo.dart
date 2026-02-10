import 'dart:io';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/request/notice_request.dart';
import 'package:vikas_app/screeens/models/response/notice_response.dart';

class NoticeRepo {
  final _api = NetworkService.instance;

  Future<ApiResult<PaginatedNotices>> getNotices({
    int page = 0,
    int size = 10,
    String? searchQuery,
    String? filterType,
    String? userType,
  }) async {
    String url = "${ApiConstants.NOTICES_BASE}?page=$page&size=$size";

    if (searchQuery != null && searchQuery.isNotEmpty) {
      url += "&search=$searchQuery";
    }
    if (filterType != null && filterType != 'All') {
      url += "&filter=$filterType";
    }
    if (userType != null && userType != 'All Users') {
      url += "&userType=$userType";
    }

    final result = await _api.get(url);
    
    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final data = PaginatedNotices.fromJson(result.data);
      return ApiResult.success(data);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  // Future<ApiResult<NoticeResponse>> createNotice(NoticeRequest request) async {
  //   if (request.filePath != null || request.fileBytes != null) {
  //     return await _createNoticeWithFile(request);
  //   } else {
  //     return await _createNoticeWithoutFile(request);
  //   }
  // }

 
  Future<ApiResult<NoticeResponse>> _createNoticeWithoutFile(
    NoticeRequest request,
  ) async {
    final result = await _api.post(
      ApiConstants.NOTICES_BASE,
      body: request.toJson(),
    );

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final data = NoticeResponse.fromJson(result.data);
      return ApiResult.success(data);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  // Future<ApiResult<NoticeResponse>> _createNoticeWithFile(
  //   NoticeRequest request,
  // ) async {
  //   final formData = FormData.fromMap({
  //     'title': request.title,
  //     'message': request.message,
  //     'audienceType': request.audienceType,
  //     'audienceValue': request.audienceValue,
  //     'date': request.date.toIso8601String(),
  //     if (request.fileName != null) 'fileName': request.fileName,
  //   });

    // Add file if exists
  //   if (request.filePath != null) {
  //     final file = await MultipartFile.fromPath('file', request.filePath!);
  //     formData.files.add(MapEntry('file', file));
  //   } else if (request.fileBytes != null && request.fileName != null) {
  //     final file = MultipartFile.fromBytes(
  //       request.fileBytes!,
  //       filename: request.fileName,
  //     );
  //     formData.files.add(MapEntry('file', file));
  //   }

  //   final result = await _api.postMultipart(
  //     ApiConstants.NOTICES_BASE,
  //     formData: formData,
  //   );

  //   if (!result.isSuccess) {
  //     return ApiResult.failure(result.error);
  //   }

  //   try {
  //     final data = NoticeResponse.fromJson(result.data);
  //     return ApiResult.success(data);
  //   } catch (e) {
  //     return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
  //   }
  // }

  // Get notice by ID
  Future<ApiResult<NoticeResponse>> getNoticeById(String id) async {
    final result = await _api.get("${ApiConstants.NOTICES_BASE}/$id");
    
    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final data = NoticeResponse.fromJson(result.data);
      return ApiResult.success(data);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  // Delete notice
  Future<ApiResult<bool>> deleteNotice(String id) async {
    final result = await _api.delete("${ApiConstants.NOTICES_BASE}/$id");
    
    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    return ApiResult.success(true);
  }
}