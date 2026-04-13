import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

enum OfficeStaffApiStatus { initial, loading, loaded, error }

class OfficeStaffState extends Equatable {
  final OfficeStaffApiStatus status;
  final List<User>? officeStaff;
  final int currentPage;
  final int totalPages;
  final int totalElements;
  final String? errorMessage;

  final bool isProfileViewVisible;
  final User? profile;
  final bool profileLoading;
  final String? profileError;
  
final String? profileErrorMsg;
final User? officeStaffProfile;

  const OfficeStaffState({
    this.status = OfficeStaffApiStatus.initial,
    this.officeStaff,
    this.currentPage = 0,
    this.totalPages = 0,
    this.totalElements = 0,
    this.errorMessage,
    this.isProfileViewVisible = false,
    this.profile,
    this.profileLoading = false,
    this.profileError,
    
this.profileErrorMsg,
this.officeStaffProfile,
  });

  OfficeStaffState copyWith({
    OfficeStaffApiStatus? status,
    List<User>? officeStaff,
    int? currentPage,
    int? totalPages,
    int? totalElements,
    String? errorMessage,
    bool? isProfileViewVisible,
    User? profile,
    bool? profileLoading,
    String? profileError,
    String? profileErrorMsg,
    User? officeStaffProfile,
  }) {
    return OfficeStaffState(
      status: status ?? this.status,
      officeStaff: officeStaff ?? this.officeStaff,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalElements: totalElements ?? this.totalElements,
      errorMessage: errorMessage ?? this.errorMessage,
      isProfileViewVisible:
          isProfileViewVisible ?? this.isProfileViewVisible,
      profile: profile ?? this.profile,
      profileLoading: profileLoading ?? this.profileLoading,
      profileError: profileError ?? this.profileError,
      profileErrorMsg: profileErrorMsg ?? this.profileErrorMsg,
      officeStaffProfile: officeStaffProfile ?? this.officeStaffProfile,

    );


  }

  @override
  List<Object?> get props => [
        status,
        officeStaff,
        currentPage,
        totalPages,
        totalElements,
        errorMessage,
        isProfileViewVisible,
        profile,
        profileLoading,
        profileError,
        profileErrorMsg,
        officeStaffProfile,
      ];


}