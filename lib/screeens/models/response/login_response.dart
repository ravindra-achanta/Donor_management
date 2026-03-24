import 'package:vikas_app/screeens/models/enum/user_type.dart';

class LoginResponse {
  final String id;
  final String userNmae;
  final String message;
  final String token;
  final String userType;
  final bool? isPasswordChanged;

  LoginResponse({
    required this.id,
    required this.userNmae,
    required this.message,
    required this.token,
    required this.userType,
    this.isPasswordChanged,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id']?.toString() ?? '',
      userNmae: json['userNmae']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      userType: json['userType']?.toString() ?? '',
      isPasswordChanged: json['isPasswordChanged'],
      //userType: UserType.fromString(json['userType']?.toString() ?? 'KARYAKARTHA'),
    );
  }
}