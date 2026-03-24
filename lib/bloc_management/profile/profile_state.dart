

import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

enum ProfileStatus { initial, loading, success, updating, updated, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final User? user;
  final String? profileErrorMsg;
  final String? successMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.profileErrorMsg,
    this.successMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    User? user,
    String? profileErrorMsg,
    bool clearError = false, 
    String? successMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      profileErrorMsg:
          clearError ? null : profileErrorMsg ?? this.profileErrorMsg,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, profileErrorMsg, successMessage];
}
