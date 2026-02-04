import 'package:vikas_app/api_services/api_error.dart';

class ApiResult<T> {
  final T? data;
  final ApiError? error;
  final bool isSuccess;

  ApiResult.success(this.data)
      : error = null,
        isSuccess = true;

  ApiResult.failure(this.error)
      : data = null,
        isSuccess = false;
}
