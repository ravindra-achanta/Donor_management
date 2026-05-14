// lib/screeens/models/response/visit_view.dart

class VisitModel {
  final String id;
  final String visitorName;
  final String createdByName;
  final String phoneNumber;

  final String email;
  final String visitPurpose;
  final String comments;
  final int noOfGuests;
  final String? jeevanaadiId; 

  VisitModel({
    required this.id,
    required this.visitorName,
    required this.createdByName,
    required this.phoneNumber,
    required this.email,
    required this.visitPurpose,
    required this.comments,
    required this.noOfGuests,
    this.jeevanaadiId,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id']?.toString() ?? '',
      visitorName: json['visitorName'] ?? '',
      createdByName: json['createdByName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      visitPurpose: json['visitPurpose'] ?? '',
      comments: json['comments'] ?? '',
      noOfGuests: json['noOfGuests'] ?? 0,
      jeevanaadiId: json['jeevanaadiId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visitorName': visitorName,
      'createdByName': createdByName,
      'phoneNumber': phoneNumber,
      'email': email,
      'visitPurpose': visitPurpose,
      'comments': comments,
      'noOfGuests': noOfGuests,
      'jeevanaadiId': jeevanaadiId,
    };
  }
}