import 'dart:typed_data';

class NoticeRequest {
  final String title;
  final String message;
  final String audienceType; // 'User Type' or 'User'
  final String audienceValue; // 'Admin' or user IDs list as JSON
  final DateTime date;
  final String? filePath;
  final Uint8List? fileBytes;
  final String? fileName;

  NoticeRequest({
    required this.title,
    required this.message,
    required this.audienceType,
    required this.audienceValue,
    required this.date,
    this.filePath,
    this.fileBytes,
    this.fileName,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'audienceType': audienceType,
      'audienceValue': audienceValue,
      'date': date.toIso8601String(),
      if (fileName != null) 'fileName': fileName,
      // File will be sent as multipart form data
    };
  }
}