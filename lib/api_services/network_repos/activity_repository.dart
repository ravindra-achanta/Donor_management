import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/request/ActivityMetrics.dart';
import 'package:vikas_app/screeens/models/request/activity_request.dart%20%20%E2%9C%85%20Cractivity_request.dart';
import 'package:vikas_app/screeens/models/response/activity.dart';
import 'package:vikas_app/screeens/models/response/activity_dashboard_metrics.dart';

class ActivityRepository {
  final _api = NetworkService.instance;

  Future<ApiResult<ActivityPaginatedResponse>> fetchActivities({
    required int page,
    int pageSize = 10,
    String? search,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'size': pageSize.toString(),
    };

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final uri = Uri.parse(ApiConstants.ACTIVITY_LIST)
        .replace(queryParameters: queryParams);

    final result = await _api.get(uri.toString());

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      ActivityPaginatedResponse data =
          ActivityPaginatedResponse.fromJson(result.data);
      return ApiResult.success(data);
    } catch (e) {
      return ApiResult.failure(
        ApiError(message: "Data parsing error: $e"),
      );
    }
  }

  Future<ApiResult<void>> createActivity(ActivityRequest request) async {
    final result = await _api.post(
      ApiConstants.ACTIVITY_CREATE,
      body: request.toJson(),
    );

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      return ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(
        ApiError(message: "Data parsing error: $e"),
      );
    }
  }

  
Future<ApiResult<List<ActivityDashboardMetrics>>> 
fetchUserActivityDashboard({required String userId}) async {

  final url = ApiConstants.ACTIVITY_USER_DASHBOARD.replaceAll("{id}", userId);

  final result = await _api.get(
    url,
  
  );

  if (!result.isSuccess) {
    return ApiResult.failure(result.error);
  }

  try {
    final List<dynamic> jsonList = result.data as List<dynamic>;

    final data = jsonList
        .map((e) => ActivityDashboardMetrics.fromJson(e))
        .toList();

    return ApiResult.success(data);
  } catch (e) {
    return ApiResult.failure(
      ApiError(message: "Parsing error: $e"),
    );
  }
}

Future<ApiResult<List<ActivityMetrics>>> fetchActivityMetrics() async {
  final result = await _api.get(ApiConstants.activityMetrics);

  if (!result.isSuccess) {
    return ApiResult.failure(result.error);
  }

  try {
    List<ActivityMetrics> metrics = [];
    if (result.data is List) {
      metrics = (result.data as List)
          .map((item) => ActivityMetrics.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return ApiResult.success(metrics);
  } catch (e) {
    return ApiResult.failure(
      ApiError(message: "Error parsing metrics: $e"),
    );
  }
}
}