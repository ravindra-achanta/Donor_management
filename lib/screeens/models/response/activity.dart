class Activity {
  final String id;
  final int jeevanaadiId;
  final String date;
  final String callStatus;
  final String description;
  final String createdTime;
  final String updatedTime;
  final String createdUserID;
  final String updatedUserID;

  Activity({
    required this.id,
    required this.jeevanaadiId,
    required this.date,
    required this.callStatus,
    required this.description,
    required this.createdTime,
    required this.updatedTime,
    required this.createdUserID,
    required this.updatedUserID,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '',
      jeevanaadiId: json['jeevanaadiId'] ?? 0,
      date: json['date'] ?? '',
      callStatus: json['callStatus'] ?? '',
      description: json['description'] ?? '',
      createdTime: json['createdTime'] ?? '',
      updatedTime: json['updatedTime'] ?? '',
      createdUserID: json['createdUserID'] ?? '',
      updatedUserID: json['updatedUserID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jeevanaadiId': jeevanaadiId,
      'date': date,
      'callStatus': callStatus,
      'description': description,
      'createdTime': createdTime,
      'updatedTime': updatedTime,
      'createdUserID': createdUserID,
      'updatedUserID': updatedUserID,
    };
  }
}

class ActivityPaginatedResponse {
  final List<Activity> content;
  final int totalPages;
  final int totalElements;
  final int currentPage;

  ActivityPaginatedResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.currentPage,
  });

  factory ActivityPaginatedResponse.fromJson(Map<String, dynamic> json) {
    return ActivityPaginatedResponse(
      content: (json['content'] as List?)
          ?.map((x) => Activity.fromJson(x as Map<String, dynamic>))
          .toList() ?? [],
      totalPages: json['totalPages']?.toInt() ?? 0,
      totalElements: json['totalElements']?.toInt() ?? 0,
      currentPage: json['currentPage']?.toInt() ?? 0,
    );
  }
}