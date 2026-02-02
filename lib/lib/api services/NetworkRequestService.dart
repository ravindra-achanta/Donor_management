import 'dart:convert';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vikas_app/apiServices/NetworkResponseListener.dart';

class NetowrkRequestService {

  static const int timeoutDuration = 30;
  void postRequest(
      final String url,
      final Map<String, dynamic> body,
      final Map<String, String> headers,
      NetworkResponseListener responseListener,
      final String typeOfRequest) async {
    responseListener.onNetworkCallInitiated(typeOfRequest);
    print("CORS POSTTTTTTTTT");

    Response response = await post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: headers,
    ).timeout(
      const Duration(seconds: timeoutDuration),
      onTimeout: () {
        throw "Request timed out. Please try again.";
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success
      responseListener.onSuccess(response, typeOfRequest);
    } else {
      responseListener.onFailure(response.statusCode, response, typeOfRequest);
    }
  }

  void putMethod(
      final String url,
      final Map<String, dynamic> body,
      final Map<String, String> headers,
      NetworkResponseListener responseListener,
      final String typeOfRequest) async {
    responseListener.onNetworkCallInitiated(typeOfRequest);
    Response response = await put(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: headers,
    ).timeout(
      const Duration(seconds: timeoutDuration),
      onTimeout: () {
        throw "Request timed out. Please try again.";
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success
      responseListener.onSuccess(response, typeOfRequest);
    } else {
      responseListener.onFailure(response.statusCode, response, typeOfRequest);
    }
  }

  void patchRequest(
      final String url,
      final Map<String, dynamic> body,
      final Map<String, String> headers,
      NetworkResponseListener responseListener,
      String typeOfRequest) async {
    responseListener.onNetworkCallInitiated(typeOfRequest);
    Response response = await patch(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: headers,
    ).timeout(
      const Duration(seconds: timeoutDuration),
      onTimeout: () {
        throw "Request timed out. Please try again.";
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success
      responseListener.onSuccess(response, typeOfRequest);
    } else {
      responseListener.onFailure(response.statusCode, response, typeOfRequest);
    }
  }

  void deleteMethod(
      final String url,
      final Map<String, dynamic> body,
      final Map<String, String> headers,
      NetworkResponseListener responseListener,
      final String typeOfRequest) async {
    responseListener.onNetworkCallInitiated(typeOfRequest);
    Response response = await delete(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: headers,
    ).timeout(
      const Duration(seconds: timeoutDuration),
      onTimeout: () {
        throw "Request timed out. Please try again.";
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success
      responseListener.onSuccess(response, typeOfRequest);
    } else {
      responseListener.onFailure(response.statusCode, response, typeOfRequest);
    }
  }

  void deleteMethod2(
      final String url,
      final Map<String, String> headers,
      NetworkResponseListener responseListener,
      final String typeOfRequest) async {
    responseListener.onNetworkCallInitiated(typeOfRequest);
    Response response = await delete(
      Uri.parse(url),
      headers: headers,
    ).timeout(
      const Duration(seconds: timeoutDuration),
      onTimeout: () {
        throw "Request timed out. Please try again.";
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success
      responseListener.onSuccess(response, typeOfRequest);
    } else {
      responseListener.onFailure(response.statusCode, response, typeOfRequest);
    }
  }

  void getRequest(final String url, final Map<String, String> headers,
      NetworkResponseListener responseListener, String typeOfRequest) async {
    responseListener.onNetworkCallInitiated(typeOfRequest);
    Response response = await get(
      Uri.parse(url),
      headers: headers,
    ).timeout(
      const Duration(seconds: timeoutDuration),
      onTimeout: () {
        throw "Request timed out. Please try again.";
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success
      responseListener.onSuccess(response, typeOfRequest);
    } else {
      responseListener.onFailure(response.statusCode, response, typeOfRequest);
    }
  }

  void fileUpload(
    final String url,
    XFile imageFile,
    final Map<String, String> headers,
    NetworkResponseListener responseListener,
    final String typeOfRequest,
  ) async {
    responseListener.onNetworkCallInitiated(typeOfRequest);
    var request =
        MultipartRequest('POST', Uri.parse(url)); // Create a MultipartRequest
    request.headers.addAll(headers); // Attach the headers
    var fileBytes = await imageFile.readAsBytes(); // Attach the file
    request.files.add(MultipartFile.fromBytes(
      'file', // The field name for the file in the form-data
      fileBytes,
      filename: imageFile.name,
    ));

    // Send the request
    var response = await request.send().timeout(
      const Duration(seconds: timeoutDuration),
      onTimeout: () {
        throw "Request timed out. Please try again.";
      },
    );

    var responseBody = await response.stream
        .bytesToString(); // Get the response body as a string

    var finalResponse = Response(responseBody, response.statusCode,
        headers: response
            .headers); // Create a Response object to handle status and response body

    if (response.statusCode >= 200 && response.statusCode < 300) {
      responseListener.onSuccess(
          finalResponse, typeOfRequest); // Success: Call onSuccess
    } else {
      responseListener.onFailure(finalResponse.statusCode, finalResponse,
          typeOfRequest); // Failure: Call onFailure
    }
  }
}



