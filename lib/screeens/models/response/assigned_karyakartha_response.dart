// lib/screeens/models/response/assigned_karyakartha_response.dart
import 'package:equatable/equatable.dart';
import 'user.dart'; // Add this import for User class

class AssignedKaryakarthaResponse extends Equatable {
  final List<AssignedKaryakartha> content;
  final int totalPages;
  final int totalElements;
  final int currentPage;

  const AssignedKaryakarthaResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.currentPage,
  });

  factory AssignedKaryakarthaResponse.fromJson(Map<String, dynamic> json) {
    return AssignedKaryakarthaResponse(
      content: (json['content'] as List? ?? [])
          .map((item) => AssignedKaryakartha.fromJson(item))
          .toList(),
      totalPages: json['totalPages'] as int? ?? 0,
      totalElements: json['totalElements'] as int? ?? 0,
      currentPage: json['currentPage'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [content, totalPages, totalElements, currentPage];
}

class AssignedKaryakartha extends Equatable {
  final String userName;
  final String id;
  final String email;
  final double profileCompletionPercentage;
  final String jeevanaadiNo;

  const AssignedKaryakartha({
    required this.userName,
    required this.id,
    required this.email,
    required this.profileCompletionPercentage,
    required this.jeevanaadiNo,
  });

  factory AssignedKaryakartha.fromJson(Map<String, dynamic> json) {
    return AssignedKaryakartha(
      userName: json['userName'] as String? ?? '',
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileCompletionPercentage: json['profileCompletionPercentage']?.toDouble() ?? 0.0,
      jeevanaadiNo: json['jeevanaadiNo'] as String? ?? '',
    );
  }

  User toUser() {
    return User(
      id: id,
      name: userName,
      email: email,
      mobileNumber: '', 
      uniqueId: jeevanaadiNo,
      userType: 'KARYAKARTHA',
      status: 'ACTIVE',
    );
  }

  @override
  List<Object?> get props => [userName, id, email, profileCompletionPercentage, jeevanaadiNo];
}