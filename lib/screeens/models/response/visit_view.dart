// lib/screeens/models/response/visit_view.dart

class VisitView {
  final String id;
  final String visitorName;      
  final String phoneNumber;      
  final String email;
  final String visitPurpose;
  final String comments;        
  final int noOfGuests;
 // final bool existVisitor;       
 

  VisitView({
    required this.id,
    required this.visitorName,
    required this.phoneNumber,
    required this.email,
    required this.visitPurpose,
    required this.comments,
    required this.noOfGuests,
   // required this.existVisitor,
  });

  factory VisitView.fromJson(Map<String, dynamic> json) {
    return VisitView(
      id: json['id']?.toString() ?? '',
      visitorName: json['visitorName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      visitPurpose: json['visitPurpose'] ?? '',
      comments: json['comments'] ?? '',
      noOfGuests: json['noOfGuests'] ?? 0,
      //existVisitor: json['existVisitor'] ?? false,
    );
  }

  // For backward compatibility with existing code
  factory VisitView.fromVisitModel(dynamic model) {
    return VisitView(
      id: model.id ?? '',
      visitorName: model.visitorName ?? model.name ?? '',
      phoneNumber: model.phoneNumber ?? model.phone ?? '',
      email: model.email ?? '',
      visitPurpose: model.visitPurpose ?? '',
      comments: model.comments ?? '',
      noOfGuests: model.noOfGuests ?? 0,
     // existVisitor: model.existVisitor ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visitorName': visitorName,
      'phoneNumber': phoneNumber,
      'email': email,
      'visitPurpose': visitPurpose,
      'comments': comments,
      'noOfGuests': noOfGuests,
     // 'existVisitor': existVisitor,
    };
  }
}