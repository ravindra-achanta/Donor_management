import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

enum UserScreenState { initial, loading, loaded, error }

class UserState extends Equatable {
  final UserScreenState status;
  final String? errorMessage;
  final int totalElements;
  final int totalpages;
  final int currentPage;
  final bool delLoading;
  final List<User>? users;
  final bool isProfileViewVisible;
  final User? user;
  final bool? profileLoading;
  final String? profileErrorMsg;

  UserState({
    this.status = UserScreenState.initial,
    this.delLoading = false,
    this.users,
    this.errorMessage,
    this.currentPage = 0,
    this.totalElements = 0,
    this.totalpages = 0,
    this.isProfileViewVisible = false,
    this.user,
    this.profileLoading = false,
    this.profileErrorMsg,
  });

  UserState copyWith({
    UserScreenState? status,
    String? errorMessage,
    bool? delLoading,
    List<User>? users,
    int? totalElements,
    int? currentPage,
    int? totalpages,
    bool? isProfileViewVisible,
    User? user,
    bool? profileLoading,
    String? profileErrorMsg,
  }) {
    return UserState(
      status: status ?? this.status,
      totalElements: totalElements ?? this.totalElements,
      totalpages: totalpages ?? this.totalpages,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      users: users ?? this.users,
      isProfileViewVisible: isProfileViewVisible ?? this.isProfileViewVisible,
      user: user ?? this.user,
      profileLoading: profileLoading ?? this.profileLoading,
      profileErrorMsg: profileErrorMsg ?? this.profileErrorMsg,
    );
  }

  List<Object?> get props => [
    status,
    errorMessage,
    totalElements,
    totalpages,
    currentPage,
    delLoading,
    users,
    isProfileViewVisible,
    user,
    profileLoading,
    profileErrorMsg,
  ];
}
