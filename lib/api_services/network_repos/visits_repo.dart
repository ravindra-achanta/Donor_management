// lib/api_services/network_repos/visit_repository.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/request/VisitMetrics.dart';
import 'package:vikas_app/screeens/models/response/visit_view.dart';

class VisitRepository {
  final _api = NetworkService.instance;

  
  Future<ApiResult<Map<String, dynamic>>> getVisits({
    required int page,
    int size = 10,
  }) async {
    final result = await _api.get(
      "${ApiConstants.visitsList}?page=$page&size=$size",
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

  // GET /visits/{id} - Get visit details by ID
  Future<ApiResult<VisitView>> getVisitDetails(String id) async {
    final url = "${ApiConstants.visitsDetails}/$id";
    final result = await _api.get(url);

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final data = result.data;
      if (data is! Map<String, dynamic>) {
        throw FormatException('Unexpected response format: ${data.runtimeType}');
      }

      final visit = VisitView.fromJson(data);
      return ApiResult.success(visit);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

 // POST /visits/create - Create a new visit
  Future<ApiResult<VisitView>> createVisit(Map<String, dynamic> visitData) async {
    final result = await _api.post(
      ApiConstants.visitsCreate,
      body: visitData,
    );

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final data = result.data;
      if (data is! Map<String, dynamic>) {
        throw FormatException('Unexpected response format: ${data.runtimeType}');
      }

      final visit = VisitView.fromJson(data);
      return ApiResult.success(visit);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  // PUT /visits/{id}/update - Update a visit
    Future<ApiResult<VisitView>> updateVisit({
    required String id,
    required Map<String, dynamic> updateData,
  }) async {
    // Using visitsUpdate base path and adding /update
    final url = "${ApiConstants.visitsUpdate}/$id/update";
    
        

    updateData.removeWhere((key, value) => value == null);

    final result = await _api.put(url, body: updateData);

    if (!result.isSuccess) {
      debugPrint('🔵 UPDATE FAILED: ${result.error?.message}');
      return ApiResult.failure(result.error);
    }

    try {
      final data = result.data;
      if (data is! Map<String, dynamic>) {
        throw FormatException('Unexpected response format: ${data.runtimeType}');
      }

      final visit = VisitView.fromJson(data);
      debugPrint('🔵 UPDATE SUCCESS: ${visit.id}');
      return ApiResult.success(visit);
    } catch (e) {
      debugPrint('🔵 UPDATE PARSE ERROR: $e');
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  // DELETE /visits/{id}/delete - Delete a visit
  // DELETE /visits/{id}/delete - Delete a visit
Future<ApiResult<void>> deleteVisit(String id) async {
  debugPrint('🔴 ===== DELETE VISIT =====');
  debugPrint('🔴 ID: $id');
  
  if (id.isEmpty) {
    return ApiResult.failure(ApiError(message: "ID cannot be empty"));
  }
  
  final url = "${ApiConstants.visitsDelete}/$id/delete";
  final result = await _api.delete(url);

  if (!result.isSuccess) {
    return ApiResult.failure(result.error);
  }

  return ApiResult.success(null);
}
Future<ApiResult<List<VisitMetrics>>> getVisitMetrics() async {
  final result = await _api.get(ApiConstants.visitMetrics);

  if (!result.isSuccess) {
    return ApiResult.failure(result.error);
  }

  try {
    final List list = result.data;
    return ApiResult.success(
      list.map((e) => VisitMetrics.fromJson(e)).toList(),
    );
  } catch (e) {
    return ApiResult.failure(ApiError(message: "Parsing error: $e"));
  }
}
}