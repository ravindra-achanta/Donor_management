

import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

enum ProfileStatus { initial, loading, success, updating, updated, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final User? user;
  final String? profileErrorMsg;
  final String? successMessage;
  final bool isUpdateError;
  final bool isUpdateSuccess;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.profileErrorMsg,
    this.successMessage,
    this.isUpdateError = false,
    this.isUpdateSuccess = false,
    this.errorMessage,
    
  });

  ProfileState copyWith({
    ProfileStatus? status,
    User? user,
    String? profileErrorMsg,
    bool clearError = false, 
    String? successMessage,
    bool? isUpdateError,
    bool? isUpdateSuccess,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      profileErrorMsg:
          clearError ? null : profileErrorMsg ?? this.profileErrorMsg,
      successMessage: successMessage ?? this.successMessage,
      isUpdateError: isUpdateError ?? this.isUpdateError,
      isUpdateSuccess: isUpdateSuccess ?? this.isUpdateSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, profileErrorMsg, successMessage, isUpdateError, isUpdateSuccess, errorMessage];
}
