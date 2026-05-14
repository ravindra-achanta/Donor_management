import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/request/donations_all_metrics.dart';
import 'package:vikas_app/screeens/models/request/user_metrics_response.dart';
import 'package:vikas_app/screeens/models/response/donationMetrics.dart';

class DashboardRepo {
  final _api = NetworkService.instance;

  Future<ApiResult<UserMetricsResponse>> getDashboardMetrics() async {
    final result = await _api.get(ApiConstants.metrics);

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      UserMetricsResponse data = UserMetricsResponse.fromJson(result.data);
      return ApiResult.success(data);
    } catch (e) {
      return ApiResult.failure(
        ApiError(message: "Data parsing error: $e"),
      );
    }
  }

  Future<ApiResult<ContributionResponse>> getDonationMetrics(int id) async {
    final result =
        await _api.get("${ApiConstants.VIKAS}/donations/metrics/$id");

    if (!result.isSuccess) {
      return ApiResult.failure(result.error);
    }

    try {
      ContributionResponse data = ContributionResponse.fromJson(result.data);
      return ApiResult.success(data);
    } catch (e) {
      return ApiResult.failure(
        ApiError(message: "Data parsing error: $e"),
      );
    }
  }


  Future<ApiResult<Map<String, dynamic>>> postActivityDashboard() async {
    final url = ApiConstants.ACTIVITY_DASHBOARD;
    
    
    final result = await _api.post(url, body: {});

    if (!result.isSuccess) {
      print("❌ [DashboardRepo] Failed to fetch dashboard - Error: ${result.error?.message}");
      return ApiResult.failure(result.error);
    }

    try {
      print("✅ [DashboardRepo] Activity dashboard fetched successfully");
      print("📦 [DashboardRepo] Response: ${result.data}");
      final data = result.data as Map<String, dynamic>;
      return ApiResult.success(data);
    } catch (e) {
      print("❌ [DashboardRepo] Parse error: $e");
      return ApiResult.failure(
        ApiError(message: "Data parsing error: $e"),
      );
    }
  }

  Future<ApiResult<DonationsAllMetrics>> getDonationsMetricsAll() async {
  final result = await _api.get(ApiConstants.DONATIONS_METRICS_ALL);

  if (!result.isSuccess) {
    print("❌ [DashboardRepo] Failed to fetch all donations metrics - Error: ${result.error?.message}");
    return ApiResult.failure(result.error);
  }

  try {
    print("✅ [DashboardRepo] All donations metrics fetched successfully");
    DonationsAllMetrics data = DonationsAllMetrics.fromJson(result.data);
    print("📦 [DashboardRepo] Metrics: ${result.data}");
    return ApiResult.success(data);
  } catch (e) {
    print("❌ [DashboardRepo] Parse error: $e");
    return ApiResult.failure(
      ApiError(message: "Data parsing error: $e"),
    );
  }
}

  
}
