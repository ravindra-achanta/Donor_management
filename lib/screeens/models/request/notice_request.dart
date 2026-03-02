import 'dart:io';

class NoticeRequest {
  final String title;
  final String message;
  final String audienceType;
  final String audienceValue;
  final DateTime date;
  // new field
  final String time;
  final File? attachment;

  NoticeRequest({
    required this.title,
    required this.message,
    required this.audienceType,
    required this.audienceValue,
    required this.date,
    required this.time,           // now required
    this.attachment,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'message': message,
      'audience_type': audienceType,
      'audience_value': audienceValue,
      'date': date.toIso8601String(),
      'time': time,
    };
    if (attachment != null) {
      data['attachment'] = attachment;
    }
    return data;
  }
}