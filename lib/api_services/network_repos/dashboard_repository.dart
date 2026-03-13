import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/request/user_metrics_response.dart';

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
}