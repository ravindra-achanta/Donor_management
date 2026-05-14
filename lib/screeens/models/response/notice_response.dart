class NoticeResponse {
  final String id;
  final String? image;
  final String title;
  final String description;
  final String sendDate;         
  final String sendTime;
  final String? sendTo;
  final DateTime? createdTime;
  final DateTime? updatedTime;
  final String? createdUserID;
  final String? updatedUserID;
  final String? status;
  final String? sentStatus;

  NoticeResponse({
    required this.id,
    this.image,
    required this.title,
    required this.description,
    required this.sendDate,
    required this.sendTime,
    this.sendTo,
    this.createdTime,
    this.updatedTime,
    this.createdUserID,
    this.updatedUserID,
    this.status,
    this.sentStatus,
  });

  factory NoticeResponse.fromJson(Map<String, dynamic> json) {
    return NoticeResponse(
      id: json['id'] ?? '',
      image: json['image'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      sendDate: json['sendDate'] ?? '',
      sendTime: json['sendTime'] ?? '',
      sendTo: json['sendTo'],
      createdTime: json['createdTime'] != null
          ? DateTime.parse(json['createdTime'])
          : null,
      updatedTime: json['updatedTime'] != null
          ? DateTime.parse(json['updatedTime'])
          : null,
      createdUserID: json['createdUserID'],
      updatedUserID: json['updatedUserID'],
      status: json['status'],
      sentStatus: json['sentStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "image": image,
      "title": title,
      "description": description,
      "sendDate": sendDate,
      "sendTime": sendTime,
      "sendTo": sendTo,
      "createdTime": createdTime?.toIso8601String(),
      "updatedTime": updatedTime?.toIso8601String(),
      "createdUserID": createdUserID,
      "updatedUserID": updatedUserID,
      "status": status,
      "sentStatus": sentStatus,
    };
  }
  
 DateTime? get sendDateTime {
  try {
    final dateParts = sendDate.split('-');   // "DD-MM-YYYY"
    if (dateParts.length != 3) return null;
    final day = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final year = int.parse(dateParts[2]);

    final timeParts = sendTime.split(':');  
    if (timeParts.length < 2) return null;
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final second = timeParts.length > 2 ? int.parse(timeParts[2]) : 0;

    return DateTime(year, month, day, hour, minute, second);
  } catch (e) {
    return null;
  }
}
}