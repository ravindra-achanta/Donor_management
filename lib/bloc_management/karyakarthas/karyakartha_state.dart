import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

enum KaryakattaApiStatus { initial, loading, loaded, error }

bool profileLoading = false;

class KaryakarthaState extends Equatable {
  final KaryakattaApiStatus status;
  final int totalElements;
  final int totalpages;
  final int currentPage;
  final String? errorMessage;
  final bool delLoading;
  final List<User>? karyakarthas;
  final bool isProfileViewVisible;
  final User? karyakarthaProfile;
  final bool? profileLoading;
  final String? profileErrorMsg;

  const KaryakarthaState({
    this.delLoading = false,
    this.karyakarthas,
    this.totalElements = 0,
    this.totalpages = 0,
    this.currentPage = 0,
    this.status = KaryakattaApiStatus.initial,
    this.errorMessage,
    this.isProfileViewVisible = false,
    this.karyakarthaProfile,
    this.profileLoading = false,
    this.profileErrorMsg,
  });

  KaryakarthaState copyWith({
    KaryakattaApiStatus? status,
    String? errorMessage,
    bool? delLoading,
    List<User>? users,
    int? currentPage,
    bool? isProfileViewVisible,
    User? karyakarthaProfile,
    bool? profileLoading,
    int? totalElements,
    int? totalpages,
    String? profileErrorMsg,
  }) {
    return KaryakarthaState(
      delLoading: delLoading ?? this.delLoading,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      karyakarthas: users ?? this.karyakarthas,
      currentPage: currentPage ?? this.currentPage,
      totalElements: totalElements ?? this.totalElements,
      totalpages: totalpages ?? this.totalpages,
      isProfileViewVisible: isProfileViewVisible ?? this.isProfileViewVisible,
      karyakarthaProfile: karyakarthaProfile ?? this.karyakarthaProfile,
      profileLoading: profileLoading ?? this.profileLoading,
      profileErrorMsg: profileErrorMsg ?? this.profileErrorMsg,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    delLoading,
    karyakarthas,
    currentPage,
    isProfileViewVisible,
    karyakarthaProfile,
    totalElements,
    totalpages,
    profileLoading,
    profileErrorMsg,
  ];
}
