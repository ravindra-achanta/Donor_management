import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:vikas_app/api_services/api_constants.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';


class ImageRepo {
  final String baseUrl;

  ImageRepo({required this.baseUrl});

 
  Future<String?> uploadImage(Uint8List imageBytes, String fileName) async {
    final url = Uri.parse('$baseUrl/vikas/api/v1/idm/image');
    var request = http.MultipartRequest('POST', url);

    final token = await Vikasdb().getString("TOKEN");
    request.headers['Authorization'] = 'Bearer $token';

    // Attach file
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'), 
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
       
        return json['image'] as String?;
      } else {
        print('Image upload failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
}