import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/jeevanadi/view_jeevanadi_screen.dart';
import 'package:vikas_app/screeens/models/request/JeevanaadiFullProfile.dart';
import 'package:vikas_app/screeens/models/response/donations.dart';
// import 'package:vikas_app/screeens/models/response/jeevanaadi_user.dart';
import 'package:vikas_app/screeens/models/response/user.dart';
import 'package:vikas_app/screeens/models/response/jeevanaadiView.dart';
import '../../screeens/models/response/jeevanadi_member.dart';

enum JeevanaadiApiStatus { initial, loading, loaded, error }

bool profileLoading = false;

class JeevanaadiState extends Equatable {
  final JeevanaadiApiStatus status;
  final String? errorMessage;
  final int totalElements;
  final int totalpages;
  final int currentPage;
  final bool delLoading;
  final List<JeevanaadiUser> jeevanaadisMems;
  final bool isProfileViewVisible;
  final User? jeevanaadiProfile;
  final JeevanaadiFullProfile? jeevanaadiProfileFull;
  final bool? profileLoading;
  final String? profileErrorMsg;
  final JeevanadiMember? jeevanadiMember;
  final List<JeevanaadiUser> assignedKaryakarthas;
  final List<JeevanaadiUser> unassignedKaryakarthas;
  final List<DonationEvent> allDonations;
  final bool loadingDonations;
  final String? donationsError;
  final List<String> selectedUnassignedIds;
  final bool isAssigning;
  final bool isRemoving;
  final int unassignedTotalPages;
  final int unassignedTotalElements;
  final int unassignedCurrentPage;
  final bool isLoadingUnassigned;
  final int assignedTotalPages;
  final int assignedTotalElements;
  final int assignedCurrentPage;
  final bool isLoadingAssigned;
  final bool? isUpdateLoading;
  final String? updateSuccessMsg;
  final String? updateErrorMsg;
  final Map<String, dynamic>? updateResponse;
  final bool referredByLoading;
  final List<dynamic> referredByUsers;
  final String? referredByError;
  final int referredByCurrentPage;
  final int referredByTotalPages;
  final List<String> selectedAssignedIds;
  final String? requestId;
  final String? requestStatus;
  final bool isFromRequest;
  final bool isProcessingRequest;
  final int totalDonationElements;
  final int donationCurrentPage;
  final int totalDonationpages;
  final bool isApproving;
final String? approveSuccessMsg;
final String? approveErrorMsg;
 final List<JeevanaadiUser> searchResults;
  final bool searchLoading;
  final String? searchError;
  final String? orderedBy;

  const JeevanaadiState({
    this.delLoading = false,
    this.jeevanaadisMems = const [],
    this.status = JeevanaadiApiStatus.initial,
    this.errorMessage,
    this.currentPage = 0,
    this.totalElements = 0,
    this.totalpages = 0,
    this.isProfileViewVisible = false,
    this.jeevanaadiProfile,
    this.jeevanaadiProfileFull,
    this.profileLoading = false,
    this.profileErrorMsg,
    this.totalDonationElements = 0,
    this.donationCurrentPage = 0,
    this.totalDonationpages = 0,
    this.allDonations = const [],
    this.loadingDonations = false,
    this.donationsError,
    this.jeevanadiMember,
    this.assignedKaryakarthas = const [],
    this.unassignedKaryakarthas = const [],
    this.selectedUnassignedIds = const [],
    this.isAssigning = false,
    this.isRemoving = false,
    this.unassignedTotalPages = 0,
    this.unassignedTotalElements = 0,
    this.unassignedCurrentPage = 0,
    this.isLoadingUnassigned = false,
    this.assignedTotalPages = 0,
    this.assignedTotalElements = 0,
    this.assignedCurrentPage = 0,
    this.isLoadingAssigned = false,
    this.isUpdateLoading = false,
    this.updateSuccessMsg,
    this.updateErrorMsg,
    this.updateResponse,
    this.referredByLoading = false,
    this.referredByUsers = const [],
    this.referredByError,
    this.referredByCurrentPage = 0,
    this.referredByTotalPages = 0,
    this.selectedAssignedIds = const [],
    this.requestId,
    this.requestStatus,
    this.isFromRequest = false,
    this.isProcessingRequest = false,
    this.isApproving = false,
    this.approveSuccessMsg,
    this.approveErrorMsg,
     this.searchResults = const [],
    this.searchLoading = false,
    this.searchError,
      this.orderedBy,



  });

  JeevanaadiState copyWith({
    JeevanaadiApiStatus? status,
    String? errorMessage,
    bool? delLoading,
    List<JeevanaadiUser>? jeevanaadisMems,
    int? totalElements,
    int? currentPage,
    int? totalpages,
    int? totalDonationElements,
    int? donationCurrentPage,
    int? totalDonationpages,
    bool? isProfileViewVisible,
    User? jeevanaadiProfile,
    JeevanaadiFullProfile? jeevanaadiProfileFull,
    bool? profileLoading,
    String? profileErrorMsg,
    List<DonationEvent>? allDonations,
    bool? loadingDonations,
    String? donationsError,
    JeevanadiMember? jeevanadiMember,
    List<JeevanaadiUser>? assignedKaryakarthas,
    List<JeevanaadiUser>? unassignedKaryakarthas,
    List<String>? selectedUnassignedIds,
    bool? isAssigning,
    bool? isRemoving,
    int? unassignedTotalPages,
    int? unassignedTotalElements,
    int? unassignedCurrentPage,
    bool? isLoadingUnassigned,
    int? assignedTotalPages,
    int? assignedTotalElements,
    int? assignedCurrentPage,
    bool? isLoadingAssigned,
    bool? isUpdateLoading,
    String? updateSuccessMsg,
    String? updateErrorMsg,
    Map<String, dynamic>? updateResponse,
    bool? referredByLoading,
    List<dynamic>? referredByUsers,
    String? referredByError,
    int? referredByCurrentPage,
    int? referredByTotalPages,
    List<String>? selectedAssignedIds,
    String? requestId,
    String? requestStatus,
    bool? isFromRequest,
    bool? isProcessingRequest,
    bool? isApproving,
    String? approveSuccessMsg,
    String? approveErrorMsg,
     List<JeevanaadiUser>? searchResults,
    bool? searchLoading,
    String? searchError,
    String? orderedBy,

  }) {
    return JeevanaadiState(
      delLoading: delLoading ?? this.delLoading,
      status: status ?? this.status,
      totalElements: totalElements ?? this.totalElements,
      totalpages: totalpages ?? this.totalpages,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalDonationElements:
          totalDonationElements ?? this.totalDonationElements,
      donationCurrentPage: donationCurrentPage ?? this.donationCurrentPage,
      totalDonationpages: totalDonationpages ?? this.totalDonationpages,
      //jeevanaadisMems: jeevanaadisMems ?? this.jeevanaadisMems,
      jeevanaadisMems: jeevanaadisMems ?? this.jeevanaadisMems,
      isProfileViewVisible: isProfileViewVisible ?? this.isProfileViewVisible,
      jeevanaadiProfile: jeevanaadiProfile ?? this.jeevanaadiProfile,
      jeevanaadiProfileFull:
          jeevanaadiProfileFull ?? this.jeevanaadiProfileFull,
      profileLoading: profileLoading ?? this.profileLoading,
      profileErrorMsg: profileErrorMsg ?? this.profileErrorMsg,
      jeevanadiMember: jeevanadiMember ?? this.jeevanadiMember,
      assignedKaryakarthas: assignedKaryakarthas ?? this.assignedKaryakarthas,
      unassignedKaryakarthas:
          unassignedKaryakarthas ?? this.unassignedKaryakarthas,
      selectedUnassignedIds:
          selectedUnassignedIds ?? this.selectedUnassignedIds,
      allDonations: allDonations ?? this.allDonations,
      loadingDonations: loadingDonations ?? this.loadingDonations,
      donationsError: donationsError ?? this.donationsError,
      isAssigning: isAssigning ?? this.isAssigning,
      isRemoving: isRemoving ?? this.isRemoving,
      unassignedTotalPages: unassignedTotalPages ?? this.unassignedTotalPages,
      unassignedTotalElements:
          unassignedTotalElements ?? this.unassignedTotalElements,
      unassignedCurrentPage:
          unassignedCurrentPage ?? this.unassignedCurrentPage,
      isLoadingUnassigned: isLoadingUnassigned ?? this.isLoadingUnassigned,
      assignedTotalPages: assignedTotalPages ?? this.assignedTotalPages,
      assignedTotalElements:
          assignedTotalElements ?? this.assignedTotalElements,
      assignedCurrentPage: assignedCurrentPage ?? this.assignedCurrentPage,
      isLoadingAssigned: isLoadingAssigned ?? this.isLoadingAssigned,
      isUpdateLoading: isUpdateLoading ?? this.isUpdateLoading,
      updateSuccessMsg: updateSuccessMsg ?? this.updateSuccessMsg,
      updateErrorMsg: updateErrorMsg ?? this.updateErrorMsg,
      updateResponse: updateResponse ?? this.updateResponse,
      referredByLoading: referredByLoading ?? this.referredByLoading,
      referredByUsers: referredByUsers ?? this.referredByUsers,
      referredByError: referredByError ?? this.referredByError,
      referredByCurrentPage:
          referredByCurrentPage ?? this.referredByCurrentPage,
      referredByTotalPages: referredByTotalPages ?? this.referredByTotalPages,
      selectedAssignedIds: selectedAssignedIds ?? this.selectedAssignedIds,
      requestId: requestId ?? this.requestId,
      requestStatus: requestStatus ?? this.requestStatus,
      isFromRequest: isFromRequest ?? this.isFromRequest,
      isProcessingRequest: isProcessingRequest ?? this.isProcessingRequest,
      isApproving: isApproving ?? this.isApproving,
      approveSuccessMsg: approveSuccessMsg ?? this.approveSuccessMsg,
      approveErrorMsg: approveErrorMsg ?? this.approveErrorMsg,
      searchResults: searchResults ?? this.searchResults,
      searchLoading: searchLoading ?? this.searchLoading,
      searchError: searchError ?? this.searchError,
      orderedBy: orderedBy ?? this.orderedBy,
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
    jeevanaadiProfileFull,
    allDonations,
    loadingDonations,
    totalDonationElements,
    donationCurrentPage,
    totalDonationpages,
    donationsError,
    profileLoading,
    profileErrorMsg,
    jeevanadiMember,
    assignedKaryakarthas,
    unassignedKaryakarthas,
    selectedUnassignedIds,
    isAssigning,
    isRemoving,
    unassignedTotalPages,
    unassignedTotalElements,
    unassignedCurrentPage,
    isLoadingUnassigned,
    assignedTotalPages,
    assignedTotalElements,
    assignedCurrentPage,
    isLoadingAssigned,
    isUpdateLoading,
    updateSuccessMsg,
    updateErrorMsg,
    updateResponse,
    referredByLoading,
    referredByUsers,
    referredByError,
    referredByCurrentPage,
    referredByTotalPages,
    selectedAssignedIds,
    requestId,
    requestStatus,
    isFromRequest,
    isProcessingRequest,
    isApproving,
    approveSuccessMsg,
    approveErrorMsg,
    searchResults,
    searchLoading,
    searchError,
    orderedBy,
  ];
}
