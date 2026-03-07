import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/response/Dharmasetu_view.dart';

class DharmasetuRepository {
  final _api = NetworkService.instance;

  Future<ApiResult<Map<String, dynamic>>> getDharmasetuList({
    required int page,
    int size = 10,
  }) async {
    final result = await _api.get(
      "${ApiConstants.DHARMASETU_LIST}?page=$page&size=$size",
    );

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      return ApiResult.success(result.data);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  Future<ApiResult<DharmasetuView>> getDharmasetuById(String id) async {
    final url = "${ApiConstants.DHARMASETU_GET_BY_ID}/$id";
    final result = await _api.get(url);

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final data = result.data;
      if (data is! Map<String, dynamic>) {
        throw FormatException(
          'Unexpected response format: ${data.runtimeType}',
        );
      }

      final dharmasetu = DharmasetuView.fromJson(data);
      return ApiResult.success(dharmasetu);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  Future<ApiResult<DharmasetuView>> createDharmasetu(
    Map<String, dynamic> dharmasetuData,
  ) async {
    final result = await _api.post(
      "${ApiConstants.DHARMASETU_CREATE}/create",
      body: dharmasetuData,
    );

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final data = result.data;
      if (data is! Map<String, dynamic>) {
        throw FormatException(
          'Unexpected response format: ${data.runtimeType}',
        );
      }

      final dharmasetu = DharmasetuView.fromJson(data);
      return ApiResult.success(dharmasetu);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  Future<ApiResult<DharmasetuView>> updateDharmasetu({
    required String id,
    required Map<String, dynamic> updateData,
  }) async {
    final url = "${ApiConstants.DHARMASETU_UPDATE}/$id/update";

    // Remove null values from update data
    updateData.removeWhere((key, value) => value == null);

    final result = await _api.put(url, body: updateData);

    if (!result.isSuccess) {
      debugPrint('🔵 DHARMASETU UPDATE FAILED: ${result.error?.message}');
      return ApiResult.failure(result.error);
    }

    try {
      final data = result.data;
      if (data is! Map<String, dynamic>) {
        throw FormatException(
          'Unexpected response format: ${data.runtimeType}',
        );
      }

      final dharmasetu = DharmasetuView.fromJson(data);
      debugPrint('🔵 DHARMASETU UPDATE SUCCESS: ${dharmasetu.id}');
      return ApiResult.success(dharmasetu);
    } catch (e) {
      debugPrint('🔵 DHARMASETU UPDATE PARSE ERROR: $e');
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  Future<ApiResult<void>> deleteDharmasetu(String id) async {
    if (id.isEmpty) {
      return ApiResult.failure(ApiError(message: "ID cannot be empty"));
    }

    // Properly format the URL with the ID
    final url = ApiConstants.DHARMASETU_DELETE.replaceFirst("{id}", id);
    final result = await _api.delete(url);

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    return ApiResult.success(null);
  }
}
