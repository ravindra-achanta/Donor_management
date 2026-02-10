import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/enum/user_type.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String mobileNumber;
  final String password;
  final UserType userType;

  LoginEvent({
    required this.mobileNumber,
    required this.password,
    required this.userType,
  });

  @override
  List<Object?> get props => [mobileNumber, password, userType];
}

class CheckAuthStatusEvent extends AuthEvent {}