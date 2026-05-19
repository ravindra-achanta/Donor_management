import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/request/JeevanaadiFullProfile.dart';
import 'package:vikas_app/screeens/models/request/VisitMetrics.dart';
import 'package:vikas_app/screeens/models/request/allocate_members_request.dart';
import 'package:vikas_app/screeens/models/response/donations_pagination.dart';
import 'package:vikas_app/screeens/models/response/jeevanaadiView.dart';
import 'package:vikas_app/screeens/models/response/jeevanaadi_paginated_view.dart';

class JeevanadiRepo {
  final _api = NetworkService.instance;

  Future<ApiResult<JeevanaadiPaginatedView>> getJeevanaadisMems(
    int page,
    int size,
    String? searchQuery,
    String? orderedBy,
  ) async {
    final queryParams = {'page': page.toString(), 'size': size.toString()};

    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParams['searchValue'] = searchQuery;
    }
    if (orderedBy != null && orderedBy.isNotEmpty) {
      queryParams['orderedBy'] = orderedBy;
    }

    final uri = Uri.parse(
      ApiConstants.GET_JEEVANAADIS,
    ).replace(queryParameters: queryParams);
    final result = await _api.get(uri.toString());
    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      JeevanaadiPaginatedView data = JeevanaadiPaginatedView.fromJson(
        result.data,
      );
      return ApiResult.success(data);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  Future<ApiResult<JeevanaadiDonationView>> getJeevanaadisDonations(
    int page,
    int size,
    String? id,
  ) async {
    final result = await _api.get(
      "${ApiConstants.VIKAS}/donations/${id}?page=${page}&size=${size}",
    );
    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      JeevanaadiDonationView data = JeevanaadiDonationView.fromJson(
        result.data,
      );
      return ApiResult.success(data);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  // In your JeevanadiRepo class
  // Future<ApiResult<User>> getJeevanaadiProfile(
  //   String userId, {
  //   Map<String, String>? customHeaders, required Map<String, String> headers,
  // }) async {
  //   try {
  //     final headers = {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       ...?customHeaders, // Merge with custom headers
  //     };

  //     final response = await http.get(
  //       Uri.parse('${ApiConstants.GET_JEEVANAADIS}/$userId'),
  //       headers: headers,
  //     );

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       return ApiResult.success(User.fromJson(data));
  //     } else {
  //       return ApiResult.failure(
  //         ApiError(message: 'Failed to load profile: ${response.statusCode}'),
  //       );
  //     }
  //   } catch (e) {
  //     return ApiResult.failure(
  //       ApiError(message: 'Network error: ${e.toString()}'),
  //     );
  //   }
  // }

  // In Jeevanadi getby id
  Future<ApiResult<JeevanaadiFullProfile>> getJeevanaadiProfile(
    String id,
  ) async {
    final url = "${ApiConstants.JEEVANADI_URI}/$id";
    final result = await _api.get(url);

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      dynamic data = result.data;
      if (data is List && data.isNotEmpty) {
        data = data[0];
      }

      if (data is! Map<String, dynamic>) {
        throw FormatException(
          'Unexpected response format for profile: ${data.runtimeType}',
        );
      }

      final fullProfile = JeevanaadiFullProfile.fromJson(data);
      return ApiResult.success(fullProfile);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  //full view jeevandi::
  Future<ApiResult<JeevanaadiFullProfile>> getJeevanaadiProfileFull(
    String id,
  ) async {
    final result = await _api.get("${ApiConstants.JEEVANADI_URI}/$id");
    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      dynamic data = result.data;
      if (data is List && data.isNotEmpty) {
        data = data[0];
      }

      if (data is! Map<String, dynamic>) {
        throw FormatException(
          'Unexpected response format for full profile: ${data.runtimeType}',
        );
      }

      final profile = JeevanaadiFullProfile.fromJson(data);
      return ApiResult.success(profile);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  //unassigned jeevandi members
  Future<ApiResult<JeevanaadiPaginatedView>> getUnassignedJeevanadiUsers({
    required int page,
    required int size,
    String? searchQuery,
    String? orderedBy,
  }) async {
    // final url =
    //     "${ApiConstants.jeevanadi_nonallocated_users}?page=$page&size=$size";

    // final result = await _api.get(url);
    final baseUrl = ApiConstants.jeevanadi_nonallocated_users;

    final queryParams = {'page': page.toString(), 'size': size.toString()};
    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParams['searchValue'] = searchQuery;
    }
    if (orderedBy != null && orderedBy.isNotEmpty) {
      // ← add
      queryParams['orderedBy'] = orderedBy;
    }

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    final result = await _api.get(uri.toString());

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final data = JeevanaadiPaginatedView.fromJson(result.data);

      return ApiResult.success(data);
    } catch (e) {
      print('❌ Parsing error: $e');
      print('📦 Response data: ${result.data}');
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  //assigned jeevandi member list to karyakatha:

  Future<ApiResult<JeevanaadiPaginatedView>> getAssignedJeevanaadis({
    required String karyakarthaId,
    required int page,
    required int size,
    String? searchQuery,
    String? orderedBy,
  }) async {
    final queryParams = {'page': page.toString(), 'size': size.toString()};
    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParams['searchValue'] = searchQuery;
    }
    if (orderedBy != null && orderedBy.isNotEmpty) {
      // ← add
      queryParams['orderedBy'] = orderedBy;
    }
    final url = Uri.parse(
      '${ApiConstants.jeevanadi_allocate_user}/karyakartha/$karyakarthaId',
    ).replace(queryParameters: queryParams);

    print('📡 Fetching assigned karyakarthas from: $url');

    final result = await _api.get(url.toString());

    if (!result.isSuccess) {
      print('❌ Failed to fetch assigned jeevanaadis: ${result.error?.message}');
      return ApiResult.failure(result.error);
    }

    try {
      print('📦 Response data: ${result.data}');
      final data = JeevanaadiPaginatedView.fromJson(result.data);
      return ApiResult.success(data);
    } catch (e) {
      print('❌ Parsing error: $e');
      print('📦 Response data: ${result.data}');
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  //allocate jeevandi member to karyakartha

  Future<ApiResult<void>> allocateMembersToKaryakartha({
    required String karyakarthaId,
    required List<String> memberIds,
  }) async {
    final url = "${ApiConstants.jeevanadi_allocate_assignees}/$karyakarthaId";

    final requestBody = AllocateMembersRequest(membersList: memberIds);
    final result = await _api.put(url, body: requestBody.toJson());

    if (!result.isSuccess) {
      print('❌ Failed to allocate members: ${result.error?.message}');
      return ApiResult.failure(result.error);
    }

    print('✅ Members allocated successfully');
    return ApiResult.success(null);
  }

  //deallocate member from karyakartha

  Future<ApiResult<Map<String, dynamic>>> deallocateMembersFromKaryakartha({
    required String karyakarthaId,
    required List<String> memberIds,
  }) async {
    final url = "${ApiConstants.jeevanadi_deallocate_assignees}/$karyakarthaId";

    final requestBody = {'membersList': memberIds};

    print('📡 Deallocating members from karyakartha: $url');
    print('📦 Request body: $requestBody');

    final result = await _api.put(url, body: requestBody);

    if (!result.isSuccess) {
      print('❌ Failed to deallocate members: ${result.error?.message}');
      return ApiResult.failure(result.error);
    }

    print('✅ Members deallocated successfully');
    return ApiResult.success(result.data);
  }

  //update jeevandi profile
  Future<ApiResult<Map<String, dynamic>>> updateJeevanaadiProfile({
    required String jeevanadiId,
    required Map<String, dynamic> updateData,
  }) async {
    final url = ApiConstants.getJeevanaadiUpdate + jeevanadiId + "/update";

    final result = await _api.put(url, body: updateData);

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    return ApiResult.success(result.data);
  }

  Future<ApiResult<JeevanaadiFullProfile>> getJeevanaadiProfileFromRequest(
    String jeevanadiId,
  ) async {
    print('🔍 Getting profile for ID: $jeevanadiId'); // DEBUG
    final url = "${ApiConstants.getrequestviewbyid}/$jeevanadiId";
    final result = await _api.get(url);
    print('📡 Full URL: ${ApiConstants.baseUrl}$url'); // DEBUG

    if (!result.isSuccess) {
      print('❌ Error: ${result.error?.message}');
      return ApiResult.failure(result.error);
    }

    try {
      final data = result.data;
      if (data is! Map<String, dynamic>) {
        throw FormatException(
          'Unexpected response format: ${data.runtimeType}',
        );
      }

      final profile = JeevanaadiFullProfile.fromJson(data);
      return ApiResult.success(profile);
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  Future<void> deleteKaryakartha(String id) async {
    await _api.delete("${ApiConstants.GET_KARYAKARTHAS_BY_ID}/$id");
  }

  Future<ApiResult<Map<String, dynamic>>> approveJeevanaadi(
    String jeevanadiId,
  ) async {
    final url = ApiConstants.approverequest + "$jeevanadiId/approve";

    final result = await _api.put(url, body: {});

    if (!result.isSuccess) {
      print('❌ Approval failed: ${result.error?.message}');
      return ApiResult.failure(result.error);
    }

    print('✅ Jeevanaadi approved successfully');
    return ApiResult.success(result.data);
  }

  // Future<ApiResult<List<JeevanaadiUser>>> searchJeevanaadiUsers(
  //   String query,
  // ) async {
  //   final url = "${ApiConstants.jeevandi_search}search/{value}";
  //   final result = await _api.get(url);

  //   if (!result.isSuccess) {
  //     return ApiResult.failure(result.error);
  //   }

  //   try {
  //     final List<dynamic> data = result.data;
  //     final users = data.map((json) => JeevanaadiUser.fromJson(json)).toList();
  //     return ApiResult.success(users);
  //   } catch (e) {
  //     return ApiResult.failure(ApiError(message: "Parsing error: $e"));
  //   }
  // }
  Future<ApiResult<List<JeevanaadiUser>>> searchJeevanaadiUsers(
  String query,
) async {
  final url = "${ApiConstants.jeevandi_search}/$query";

  print("🔍 Search URL: $url");

  final result = await _api.get(url);

  if (!result.isSuccess) {
    return ApiResult.failure(result.error);
  }

  try {
    final List<dynamic> data = result.data;

    final users = data
        .map((json) => JeevanaadiUser.fromJson(json))
        .toList();

    return ApiResult.success(users);
  } catch (e) {
    return ApiResult.failure(
      ApiError(message: "Parsing error: $e"),
    );
  }
}

Future<ApiResult<Map<String, dynamic>>> rejectJeevanaadi(
  String jeevanadiId,
  String rejectReason,
) async {

  final url =
      "${ApiConstants.rejectrequest}$jeevanadiId/reject";

  print("🔴 Reject URL: $url");
  print("🔴 Reject Reason: $rejectReason");

  final body = {
    "rejectReason": rejectReason,
  };

  final result = await _api.put(
    url,
    body: body,
  );

  if (!result.isSuccess) {

    print(
      "❌ Rejection failed: ${result.error?.message}",
    );

    return ApiResult.failure(
      result.error,
    );
  }

  print(
    "✅ Jeevanaadi rejected successfully",
  );

  return ApiResult.success(
    result.data,
  );
}
}
