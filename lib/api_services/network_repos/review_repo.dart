import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_service.dart';
import 'package:vikas_app/screeens/models/response/review_request_response.dart'; // Correct import

class ReviewRepo {
  final _api = NetworkService.instance;

  Future<ApiResult<ReviewRequestResponse>> getReviewRequests({
    required int page,
    int size = 10,
  }) async {
    final url = "${ApiConstants.REVIEW_REQUESTS}/staff/requests?page=$page&size=$size";
    
    print('📡 Fetching review requests from: $url');
    
    final result = await _api.get(url);
    
    if (!result.isSuccess) {
      print('❌ Failed to fetch review requests: ${result.error?.message}');
      return ApiResult.failure(result.error);
    }

    try {
      print('📦 Response data: ${result.data}');
      final data = ReviewRequestResponse.fromJson(result.data);
      print('✅ Parsed ${data.content.length} requests');
      return ApiResult.success(data);
    } catch (e) {
      
      return ApiResult.failure(ApiError(message: "Data parsing error: $e"));
    }
  }
}