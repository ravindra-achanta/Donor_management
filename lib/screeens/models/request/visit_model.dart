// lib/screeens/models/request/visit_model.dart

class VisitModel {
  final String id;
  final String jeevandNum;
  final String name;
  final String phone;
  final String email;
  final String visitPurpose;
  final int noOfGuests;
  final String comments;
  final String date;
  final String status;

  VisitModel({
    required this.id,
    required this.jeevandNum,
    required this.name,
    required this.phone,
    required this.email,
    required this.visitPurpose,
    required this.noOfGuests,
    required this.comments,
    required this.date,
    required this.status,
  });

  // Factory method to create from JSON
  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id'] ?? '',
      jeevandNum: json['jeevandNum'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      visitPurpose: json['visitPurpose'] ?? '',
      noOfGuests: json['noOfGuests'] ?? 0,
      comments: json['comments'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? 'Pending',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jeevandNum': jeevandNum,
      'name': name,
      'phone': phone,
      'email': email,
      'visitPurpose': visitPurpose,
      'noOfGuests': noOfGuests,
      'comments': comments,
      'date': date,
      'status': status,
    };
  }
}