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
    this.attachment, String? image,
  });

  Map<String, dynamic> toJson() {
    // Combine date and time into sendDate (ISO format with Z)
    final DateTime sendDateTime = DateTime(
      date.year,
      date.month,
      date.day,
    );
    
    // Format as ISO 8601 with Z suffix (UTC)
    final String sendDateString = sendDateTime.toIso8601String() + 'Z';
    
    // Parse audienceValue based on audienceType
    List<String>? specificUsers;
    String sendTo;

    if (audienceType == 'USER_TYPE') {
      // Map to correct backend enum values
      switch (audienceValue) {
        case 'TO_ADMIN':
          sendTo = 'TO_ADMINS';
          break;
        case 'TO_KARYAKATHA':
          sendTo = 'TO_KARYAKARTHAS';
          break;
        case 'TO_STAFF':
          sendTo = 'TO_OFFICESTAFF';
          break;
        case 'TO_ALL':
        default:
          sendTo = 'TO_ALL';
          break;
      }
      specificUsers = null;
    } else if (audienceType == 'SPECIFIC_USERS') {
      sendTo = 'TO_SPECIFIC';
      specificUsers = audienceValue.split(',').map((s) => s.trim()).toList();
    } else {
      sendTo = 'TO_ALL';
    }

    final Map<String, dynamic> data = {
      'title': title,
      'description': message, // API expects 'description', not 'message'
      'sendDate': sendDateString,
      'sendTo': sendTo,
    };

    if (specificUsers != null && specificUsers.isNotEmpty) {
      data['specificUsers'] = specificUsers;
    }

    return data;
  }
}