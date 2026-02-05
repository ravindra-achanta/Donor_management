import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final User? user;
  final String? profileErrorMsg;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.profileErrorMsg,
  });

  ProfileState copyWith({ProfileStatus? status, User? user, String? profileErrorMsg}) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      profileErrorMsg: profileErrorMsg ?? this.profileErrorMsg,
    );
  }

  @override
  List<Object?> get props => [status, user, profileErrorMsg];
}
