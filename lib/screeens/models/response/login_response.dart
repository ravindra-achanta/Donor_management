import 'package:vikas_app/screeens/models/enum/user_type.dart';

class LoginResponse {
  final String id;
  final String message;
  final String token;
  final String userType;

  LoginResponse({
    required this.id,
    required this.message,
    required this.token,
    required this.userType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      userType: json['userType']?.toString() ?? '',
      //userType: UserType.fromString(json['userType']?.toString() ?? 'KARYAKARTHA'),
    );
  }
}