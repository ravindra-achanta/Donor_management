import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/enum/user_type.dart';
import 'package:vikas_app/screeens/models/request/identity_request.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// class LoginEvent extends AuthEvent {
//   final String mobileNumber;
//   final String password;
//   //final String roleName;

//   LoginEvent({
//     required this.mobileNumber,
//     required this.password,
//     //required this.roleName,
//   });

//   @override
//   List<Object?> get props => [mobileNumber, password];
// }

class CheckLoginEvent extends AuthEvent {
  final String mobileNumber;
  final String password;
   CheckLoginEvent({required this.mobileNumber, required this.password});
  @override
  List<Object?> get props => [mobileNumber, password];
}
class ResetAuthEvent extends AuthEvent {}
class LoginWithRoleEvent extends AuthEvent {
  final String mobileNumber;
  final String roleName;
   LoginWithRoleEvent({required this.mobileNumber, required this.roleName});
  @override
  List<Object?> get props => [mobileNumber, roleName];
}

class CreateUserEvent extends AuthEvent {
  final IdentityRequest request;

  CreateUserEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

// class FetchAllUsersEvent extends AuthEvent {
//   final int page;
//   final int size;

//   FetchAllUsersEvent({
//     this.page = 0,
//     this.size = 10,
//   });

//   @override
//   List<Object?> get props => [page, size];
// }
class FetchRolesEvent extends AuthEvent {}

class FetchRolesEventByType extends AuthEvent {}

class ChangePasswordEvent extends AuthEvent {
  final String newPassword;
  final String mobileNumber;

  ChangePasswordEvent({required this.newPassword, required this.mobileNumber});

  @override
  List<Object?> get props => [newPassword, mobileNumber];
}

class CheckAuthStatusEvent extends AuthEvent {}
