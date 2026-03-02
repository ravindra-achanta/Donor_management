import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/jeevanadi/view_jeevanadi_screen.dart';
import 'package:vikas_app/screeens/models/request/JeevanaadiFullProfile.dart';
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
  final List<User> assignedKaryakarthas;
  final List<User> unassignedKaryakarthas;
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


    
    
  });

  JeevanaadiState copyWith({
    JeevanaadiApiStatus? status,
    String? errorMessage,
    bool? delLoading,
    List<JeevanaadiUser>? jeevanaadisMems,
    int? totalElements,
    int? currentPage,
    int? totalpages,
    bool? isProfileViewVisible,
    User? jeevanaadiProfile,
    JeevanaadiFullProfile? jeevanaadiProfileFull,
    bool? profileLoading,
    String? profileErrorMsg,
    JeevanadiMember? jeevanadiMember,
    List<User>? assignedKaryakarthas,
    List<User>? unassignedKaryakarthas,
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
     



  }) {
    return JeevanaadiState(
      delLoading: delLoading ?? this.delLoading,
      status: status ?? this.status,
      totalElements: totalElements ?? this.totalElements,
      totalpages: totalpages ?? this.totalpages,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
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
      isAssigning: isAssigning ?? this.isAssigning,
      isRemoving: isRemoving ?? this.isRemoving,
      unassignedTotalPages: unassignedTotalPages ?? this.unassignedTotalPages,
      unassignedTotalElements: unassignedTotalElements ?? this.unassignedTotalElements,
      unassignedCurrentPage: unassignedCurrentPage ?? this.unassignedCurrentPage,
      isLoadingUnassigned: isLoadingUnassigned ?? this.isLoadingUnassigned,
      assignedTotalPages: assignedTotalPages ?? this.assignedTotalPages,
    assignedTotalElements: assignedTotalElements ?? this.assignedTotalElements,
    assignedCurrentPage: assignedCurrentPage ?? this.assignedCurrentPage,
    isLoadingAssigned: isLoadingAssigned ?? this.isLoadingAssigned,
    isUpdateLoading: isUpdateLoading ?? this.isUpdateLoading,
    updateSuccessMsg: updateSuccessMsg ?? this.updateSuccessMsg,
    updateErrorMsg: updateErrorMsg ?? this.updateErrorMsg,
    updateResponse: updateResponse ?? this.updateResponse,
    referredByLoading: referredByLoading ?? this.referredByLoading,
      referredByUsers: referredByUsers ?? this.referredByUsers,
      referredByError: referredByError ?? this.referredByError,
      referredByCurrentPage: referredByCurrentPage ?? this.referredByCurrentPage,
      referredByTotalPages: referredByTotalPages ?? this.referredByTotalPages,
      selectedAssignedIds: selectedAssignedIds ?? this.selectedAssignedIds,
          requestId: requestId ?? this.requestId,
      requestStatus: requestStatus ?? this.requestStatus,
      isFromRequest: isFromRequest ?? this.isFromRequest,
      isProcessingRequest: isProcessingRequest ?? this.isProcessingRequest,

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


  ];
}
