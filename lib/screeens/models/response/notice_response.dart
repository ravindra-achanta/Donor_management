class NoticeResponse {
  final String id;
  final String? image;
  final String title;
  final String description;
  final DateTime? sendTime;
  final String? sendTo;
  final DateTime? createdTime;
  final DateTime? updatedTime;
  final String? createdUserID;
  final String? updatedUserID;
  final String? status;

  NoticeResponse({
    required this.id,
    this.image,
    required this.title,
    required this.description,
    this.sendTime,
    this.sendTo,
    this.createdTime,
    this.updatedTime,
    this.createdUserID,
    this.updatedUserID,
    this.status,
  });

  factory NoticeResponse.fromJson(Map<String, dynamic> json) {
    return NoticeResponse(
      id: json['id'] ?? '',
      image: json['image'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      sendTime:
          json['sendTime'] != null ? DateTime.parse(json['sendTime']) : null,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "image": image,
      "title": title,
      "description": description,
      "sendTime": sendTime?.toIso8601String(),
      "sendTo": sendTo,
      "createdTime": createdTime?.toIso8601String(),
      "updatedTime": updatedTime?.toIso8601String(),
      "createdUserID": createdUserID,
      "updatedUserID": updatedUserID,
      "status": status,
    };
  }
}