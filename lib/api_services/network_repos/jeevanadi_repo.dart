import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/assignmembers/assign_members_page.dart';
import 'package:vikas_app/screeens/models/request/JeevanaadiFullProfile.dart';
import 'package:vikas_app/screeens/models/request/allocate_members_request.dart';
import 'package:vikas_app/screeens/models/request/unassigned_users_response.dart';
import 'package:vikas_app/screeens/models/response/assigned_karyakartha_response.dart';
import 'package:vikas_app/screeens/models/response/jeevanaadi_paginated_view.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

class JeevanadiRepo {
  final _api = NetworkService.instance;

  Future<ApiResult<JeevanaadiPaginatedView>> getJeevanaadisMems(
    int page,
    int size,
  ) async {
    final result = await _api.get(
      "${ApiConstants.GET_JEEVANAADIS}?page=${page}&size=${size}",
    );
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
Future<ApiResult<User>> getJeevanaadiProfile(String id) async {
    
    final url = "${ApiConstants.jeevanadi_fullview}/$id";
    
    final result = await _api.get(url);
    
    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final fullProfile = JeevanaadiFullProfile.fromJson(result.data);
      
      final user = User(
        id: fullProfile.basicDetails.id.toString(),
        name: fullProfile.profileDetails.fullName,
        email: fullProfile.basicDetails.email,
        mobileNumber: fullProfile.profileDetails.phoneNumber, status: '',
        uniqueId: fullProfile.basicDetails.jeevanadiNo, 

        //userType: fullProfile.basicDetails.usertype,
      );
      
      return ApiResult.success(user);
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


  //unassigned jeevandi members
  Future<ApiResult<UnassignedUsersResponse>> getUnassignedJeevanadiUsers({
    required int page,
    required int size,
  }) async {
    final url =
        "${ApiConstants.jeevanadi_nonallocated_users}?page=$page&size=$size";

    final result = await _api.get(url);

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      final data = UnassignedUsersResponse.fromJson(result.data);

      return ApiResult.success(data);
    } catch (e) {
      print('❌ Parsing error: $e');
      print('📦 Response data: ${result.data}');
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }

  //assigned jeevandi member list to karyakatha:

  Future<ApiResult<AssignedKaryakarthaResponse>> getAssignedKaryakarthas({
    required String karyakarthaId,
    required int page,
    required int size,
  }) async {
    final url =
        "${ApiConstants.jeevanadi_allocate_user}/karyakartha/$karyakarthaId?page=$page&size=$size";

    print('📡 Fetching assigned karyakarthas from: $url');

    final result = await _api.get(url);

    if (!result.isSuccess) {
      print(
        '❌ Failed to fetch assigned karyakarthas: ${result.error?.message}',
      );
      return ApiResult.failure(result.error);
    }

    try {
      print('📦 Response data: ${result.data}');
      final data = AssignedKaryakarthaResponse.fromJson(result.data);
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
  
  final requestBody = {
    'membersList': memberIds,
  };
  
  print('📡 Deallocating members from karyakartha: $url');
  print('📦 Request body: $requestBody');
  
  final result = await _api.put(
    url,
    body: requestBody,
  );

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
  final url = ApiConstants.getJeevanaadiUpdate  + jeevanadiId + "/update";
  
  updateData.removeWhere((key, value) => value == null);
  
  final result = await _api.put(
    url,
    body: updateData,
  );

  if (!result.isSuccess) {
    return ApiResult.failure(result.error);
  }

  
  return ApiResult.success(result.data);
}




  Future<void> deleteKaryakartha(String id) async {
    await _api.delete("${ApiConstants.GET_KARYAKARTHAS_BY_ID}/$id");
  }
}
