import 'package:equatable/equatable.dart';
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
  final bool? profileLoading;
  final String? profileErrorMsg;
  final JeevanadiMember? jeevanadiMember;
  final List<User> assignedKaryakarthas;
  final List<User> unassignedKaryakarthas;
  final List<String> selectedUnassignedIds;
  final bool isAssigning;
  final bool isRemoving;

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
    this.profileLoading = false,
    this.profileErrorMsg,
    this.jeevanadiMember,
    this.assignedKaryakarthas = const [],
    this.unassignedKaryakarthas = const [],
    this.selectedUnassignedIds = const [],
    this.isAssigning = false,
    this.isRemoving = false,
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
    bool? profileLoading,
    String? profileErrorMsg,
    JeevanadiMember? jeevanadiMember,
    List<User>? assignedKaryakarthas,
    List<User>? unassignedKaryakarthas,
    List<String>? selectedUnassignedIds,
    bool? isAssigning,
    bool? isRemoving,
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
    jeevanadiMember,
    assignedKaryakarthas,
    unassignedKaryakarthas,
    selectedUnassignedIds,
    isAssigning,
    isRemoving,
  ];
}
