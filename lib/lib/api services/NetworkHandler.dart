import 'dart:convert';

import 'package:flutter/widgets.dart'; // Correct import for Flutter framework.
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:vikas_app/apiServices/NetworkResponseListener.dart';

class NetworkHandler<T extends StatefulWidget> extends State<T>
    implements NetworkResponseListener {
  @override
  void onFailure(int responseCode, Response response, String typeOfRequest) {
    // Handle failure case
  }

  @override
  void onNetworkCallInitiated(String typeOfRequest) {
    // Handle network call initiation
  }

  @override
  void onSuccess(Response response, String typeOfRequest) {
    // Handle success case
    // print("Profile API called successfully..! $typeOfRequest");
  }

  @override
  Widget build(BuildContext context) {
    // Provide implementation for build method
    return Container();
  }

  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      // Add other headers as needed
    };
  }

  void patch(NetworkHandler networkHandler, String url,
      Map<String, dynamic> body, String typeOfRequest,
      {Map<String, String>? headers}) async {
    try {
      headers ??= getHeaders();

      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        networkHandler.onSuccess(response, typeOfRequest);
      } else {
        networkHandler.onFailure(response.statusCode, response, typeOfRequest);
      }
    } catch (e) {
      networkHandler.onFailure(
        500,
        Response(jsonEncode({'error': e.toString()}), 500),
        typeOfRequest,
      );
    }
  }

  void handleAPIExceptions(int responseCode, Response response) {
    String? contentType = response.headers['content-type'];
    if (contentType!.contains('application/json')) {
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      String? errorMessage = errorResponse['message'];

      if (response.statusCode == 400) {
        throw errorMessage ?? "Bad Request";
      } else if (response.statusCode == 401) {
        throw errorMessage ?? "Unauthorized";
      } else if (response.statusCode == 403) {
        throw errorMessage ?? "Forbidden";
      } else if (response.statusCode == 404) {
        throw errorMessage ?? "Not Found";
      } else if (response.statusCode == 413) {
        throw errorMessage ?? "File Size is too Long";
      } else if (response.statusCode == 500) {
        throw errorMessage ?? "Internal Server Error";
      } else {
        throw "Error: ${response.statusCode} ${response.body}";
      }
    } else {
      // Handle non-JSON error responses
      throw "Error: ${response.statusCode}, Response: ${response.body}";
    }
  }
}
