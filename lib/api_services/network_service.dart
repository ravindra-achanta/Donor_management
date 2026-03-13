import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';

import 'api_constants.dart';

class NetworkService {
  NetworkService._();
  static final NetworkService instance = NetworkService._();

  Future<Map<String, String>> _defaultHeaders() async {
    final token = await Vikasdb().getString("TOKEN");
    // final token =
    //     "eyJhbGciOiJIUzI1NiJ9.eyJ1dWlkVG9rZW4iOiI5MzFlOWM4Mi1lMDhiLTQ2MTktOGVjMy1hNWJjYzQyOTA3OWEiLCJpZGVudGl0eUlkIjoiMSIsInVzZXJUeXBlIjoiU1VQRVJBRE1JTiIsImlhdCI6MTc2OTc3OTE3MywiZXhwIjoxNzcwMzgzOTczfQ.AzXljLvTirWjHZWRg7oN2DAm9S7NQucQ0SAMkk0tRKk";
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer ${token}",
    };
  }

  // -------------------- GET --------------------
  Future<ApiResult<dynamic>> get(String endpoint) async {
    try {
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");
      final headers = await _defaultHeaders();

      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: ApiConstants.connectTimeout));

      // print("API Response: ${response.body} ${response.statusCode}");

      return _handleResponse(response);
    } on SocketException {
      return ApiResult.failure(ApiError(message: "No Internet Connection"));
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Unexpected Error: $e"));
    }
  }

  // -------------------- POST --------------------
  Future<ApiResult<dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");
      final headers = await _defaultHeaders();

      final response = await http
          .post(uri, headers: headers, body: jsonEncode(body ?? {}))
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on SocketException {
      return ApiResult.failure(ApiError(message: "No Internet Connection"));
    } on FormatException {
      return ApiResult.failure(ApiError(message: "Invalid Response Format"));
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Unexpected Error: $e"));
    }
  }

  // -------------------- PUT --------------------
  Future<ApiResult<dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");
      final headers = await _defaultHeaders();

      final response = await http
          .put(uri, headers: headers, body: jsonEncode(body ?? {}))
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on SocketException {
      return ApiResult.failure(ApiError(message: "No Internet Connection"));
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Unexpected Error: $e"));
    }
  }
  // -------------------- MULTIPART UPLOAD --------------------

  Future<String> fileUpload(
  final String endpoint,   // Changed from 'url' to 'endpoint'
  XFile imageFile,
) async {
  final headers = await _defaultHeaders();
  final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");  // Build full URL
  var request = MultipartRequest('POST', uri);
  request.headers.addAll(headers);
  var fileBytes = await imageFile.readAsBytes();
  request.files.add(MultipartFile.fromBytes(
    'file',
    fileBytes,
    filename: imageFile.name,
  ));

  var response = await request.send().timeout(
    const Duration(seconds: 30),
    onTimeout: () {
      throw "Request timed out. Please try again.";
    },
  );

  var responseBody = await response.stream.bytesToString();
  var finalResponse = Response(responseBody, response.statusCode,
      headers: response.headers);

  return finalResponse.body; // Return the response body directly, or you can handle it as needed
}
// Future<ApiResult<dynamic>> fileUpload(
//     final String url,
//     XFile imageFile,
//   ) async {
//     final headers = await _defaultHeaders();
//     var request =
//         MultipartRequest('POST', Uri.parse(url)); 
//     request.headers.addAll(headers); // Attach the headers
//     var fileBytes = await imageFile.readAsBytes(); // Attach the file
//     request.files.add(MultipartFile.fromBytes(
//       'file', // The field name for the file in the form-data
//       fileBytes,
//       filename: imageFile.name,
//     ));

//     // Send the request
//     var response = await request.send().timeout(
//       const Duration(seconds:30 ),
//       onTimeout: () {
//         throw "Request timed out. Please try again.";
//       },
//     );

//     var responseBody = await response.stream
//         .bytesToString(); // Get the response body as a string

//     var finalResponse = Response(responseBody, response.statusCode,
//         headers: response
//             .headers); // Create a Response object to handle status and response body

//      return _handleResponse(finalResponse);
//   }

  // -------------------- DELETE --------------------
  Future<ApiResult<dynamic>> delete(String endpoint) async {
    try {
      final uri = Uri.parse("${ApiConstants.baseUrl}$endpoint");
      final headers = await _defaultHeaders();

      final response = await http
          .delete(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on SocketException {
      return ApiResult.failure(ApiError(message: "No Internet Connection"));
    } catch (e) {
      return ApiResult.failure(ApiError(message: "Unexpected Error: $e"));
    }
  }

  // -------------------- RESPONSE HANDLER --------------------
  ApiResult<dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    // print("API [$statusCode]: $body");

    if (statusCode >= 200 && statusCode < 300) {
      if (body.isEmpty) {
        return ApiResult.success(null);
      }

      try {
        final decoded = jsonDecode(body);
        return ApiResult.success(decoded);
      } catch (_) {
        return ApiResult.failure(
          ApiError(
            message: "Response Parsing Failed",
            statusCode: statusCode,
            rawBody: body,
          ),
        );
      }
    } else {
      return ApiResult.failure(
        ApiError(
          message: _extractErrorMessage(body) ?? "Request Failed",
          statusCode: statusCode,
          rawBody: body,
        ),
      );
    }
  }

  String? _extractErrorMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['message'] != null) {
        return decoded['message'].toString();
      }
    } catch (_) {}
    return null;
  }
}
