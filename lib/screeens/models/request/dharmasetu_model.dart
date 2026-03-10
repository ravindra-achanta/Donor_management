import 'package:vikas_app/screeens/models/response/Dharmasetu_view.dart';

class DharmasetuModel {
  final String id;
  final String dharmasetuId;
  final String type;
  final String? communityName;
  final String? pointOfContact;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? meetingLink;
  final String feedback;
  final String date;
  final String referredBy;
  final String dharmasetuStatus;

  DharmasetuModel({
    required this.id,
    required this.dharmasetuId,
    required this.type,
    this.communityName,
    this.pointOfContact,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.meetingLink,
    required this.feedback,
    required this.date,
    required this.referredBy,
    required this.dharmasetuStatus,
  });

  factory DharmasetuModel.fromJson(Map<String, dynamic> json) {
    return DharmasetuModel(
      id: json['id'] ?? '',
      dharmasetuId: json['dharmasetuId'] ?? '',
      type: json['type'] ?? '',
      communityName: json['communityName'],
      pointOfContact: json['pointOfContact'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pincode: json['pincode'],
      meetingLink: json['meetingLink'],
      feedback: json['feedback'] ?? '',
      date: json['date'] ?? '',
      referredBy: json['referredBy'] ?? '',
      dharmasetuStatus: json['dharmasetuStatus'] ?? '',
    );
  }
  factory DharmasetuModel.fromView(DharmasetuView view) {
  return DharmasetuModel(
    id: view.id,
    dharmasetuId: view.dharmasetuId,
    type: view.type,
    communityName: view.communityName,
    pointOfContact: view.pointOfContact,
    address: view.address,
    city: view.city,
    state: view.state,
    country: view.country,
    pincode: view.pincode,
    meetingLink: view.meetingLink,
    feedback: view.feedback,
    date: view.date,
    referredBy: view.referredBy,
    dharmasetuStatus: view.dharmasetuStatus,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dharmasetuId': dharmasetuId,
      'type': type,
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
}




// Optional: Create a wrapper class for the paginated response
class DharmasetuPaginatedResponse {
  final List<DharmasetuModel> content;
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
    List<DharmasetuModel> contentList = list.map((i) => DharmasetuModel.fromJson(i)).toList();

    return DharmasetuPaginatedResponse(
      content: contentList,
      totalPages: json['totalPages'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
    );
  }
}