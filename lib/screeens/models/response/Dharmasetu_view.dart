// lib/screens/models/response/dharmasetu_view.dart

class DharmasetuView {
  final String id;
  final String dharmasetuId;
  final String createdByName;
  final String type;
  final String communityName;
  final String pointOfContact;
  final String address;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final String meetingLink;
  final String feedback;
  final String date;
  final String referredBy;
  final String dharmasetuStatus;

  DharmasetuView({
    required this.id,
    required this.dharmasetuId,
    required this.createdByName,
    required this.type,
    required this.communityName,
    required this.pointOfContact,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.meetingLink,
    required this.feedback,
    required this.date,
    required this.referredBy,
    required this.dharmasetuStatus,
  });

  factory DharmasetuView.fromJson(Map<String, dynamic> json) {
    return DharmasetuView(
      id: json['id'] ?? '',
      dharmasetuId: json['dharmasetuId'] ?? '',
      createdByName: json['createdByName'] ?? '',
      type: json['type'] ?? '',
      communityName: json['communityName'] ?? '',
      pointOfContact: json['pointOfContact'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      pincode: json['pincode'] ?? '',
      meetingLink: json['meetingLink'] ?? '',
      feedback: json['feedback'] ?? '',
      date: json['date'] ?? '',
      referredBy: json['referredBy'] ?? '',
      dharmasetuStatus: json['dharmasetuStatus'] ?? '',
    );
  }
  

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dharmasetuId': dharmasetuId,
      'type': type,
      'createdByName': createdByName,
      'communityName': communityName,
      'pointOfContact': pointOfContact,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'meetingLink': meetingLink,
      'feedback': feedback,
      'date': date,
      'referredBy': referredBy,
      'dharmasetuStatus': dharmasetuStatus,
    };
  }

  // CopyWith method for easy updates
  DharmasetuView copyWith({
    String? id,
    String? dharmasetuId,
    String? createdByName,
    String? type,
    String? communityName,
    String? pointOfContact,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? meetingLink,
    String? feedback,
    String? date,
    String? referredBy,
    String? dharmasetuStatus,
  }) {
    return DharmasetuView(
      id: id ?? this.id,
      dharmasetuId: dharmasetuId ?? this.dharmasetuId,
      createdByName: createdByName ?? this.createdByName,
      type: type ?? this.type,
      communityName: communityName ?? this.communityName,
      pointOfContact: pointOfContact ?? this.pointOfContact,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
      meetingLink: meetingLink ?? this.meetingLink,
      feedback: feedback ?? this.feedback,
      date: date ?? this.date,
      referredBy: referredBy ?? this.referredBy,
      dharmasetuStatus: dharmasetuStatus ?? this.dharmasetuStatus,
    );
  }
}

// Optional: Create a wrapper class for paginated response
class DharmasetuPaginatedResponse {
  final List<DharmasetuView> content;
  final int totalPages;
  final int totalElements;
  final int currentPage;

  DharmasetuPaginatedResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.currentPage,
  });

  factory DharmasetuPaginatedResponse.fromJson(Map<String, dynamic> json) {
    var list = json['content'] as List? ?? [];
    List<DharmasetuView> contentList = list.map((item) => DharmasetuView.fromJson(item)).toList();

    return DharmasetuPaginatedResponse(
      content: contentList,
      totalPages: json['totalPages'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content.map((item) => item.toJson()).toList(),
      'totalPages': totalPages,
      'totalElements': totalElements,
      'currentPage': currentPage,
    };
  }
}