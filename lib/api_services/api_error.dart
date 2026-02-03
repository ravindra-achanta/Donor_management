class ApiError {
  final String message;
  final int? statusCode;
  final String? rawBody;

  ApiError({required this.message, this.statusCode, this.rawBody});

  @override
  String toString() => "ApiError(statusCode: $statusCode, message: $message)";
}
