import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

enum JeevanaadiApiStatus { initial, loading, loaded, error }

bool profileLoading = false;

class JeevanaadiState extends Equatable {
  final JeevanaadiApiStatus status;
  final String? errorMessage;
  final int totalElements;
  final int totalpages;
  final int currentPage;
  final bool delLoading;
  final List<User>? jeevanaadisMems;
  final bool isProfileViewVisible;
  final User? jeevanaadiProfile;
  final bool? profileLoading;
  final String? profileErrorMsg;

  const JeevanaadiState({
    this.delLoading = false,
    this.jeevanaadisMems,
    this.status = JeevanaadiApiStatus.initial,
    this.errorMessage,
    this.currentPage = 0,
    this.totalElements = 0,
    this.totalpages = 0,
    this.isProfileViewVisible = false,
    this.jeevanaadiProfile,
    this.profileLoading = false,
    this.profileErrorMsg,
  });

  JeevanaadiState copyWith({
    JeevanaadiApiStatus? status,
    String? errorMessage,
    bool? delLoading,
    List<User>? jeevanaadisMems,
    int? totalElements,
    int? currentPage,
    int? totalpages,
    bool? isProfileViewVisible,
    User? jeevanaadiProfile,
    bool? profileLoading,
    String? profileErrorMsg,
  }) {
    return JeevanaadiState(
      delLoading: delLoading ?? this.delLoading,
      status: status ?? this.status,
      totalElements: totalElements ?? this.totalElements,
      totalpages: totalpages ?? this.totalpages,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      jeevanaadisMems: jeevanaadisMems ?? this.jeevanaadisMems,
      isProfileViewVisible: isProfileViewVisible ?? this.isProfileViewVisible,
      jeevanaadiProfile: jeevanaadiProfile ?? this.jeevanaadiProfile,
      profileLoading: profileLoading ?? this.profileLoading,
      profileErrorMsg: profileErrorMsg ?? this.profileErrorMsg,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    delLoading,
    totalElements,
    currentPage,
    totalpages,
    jeevanaadisMems,
    isProfileViewVisible,
    jeevanaadiProfile,
    profileLoading,
    profileErrorMsg,
  ];
}
