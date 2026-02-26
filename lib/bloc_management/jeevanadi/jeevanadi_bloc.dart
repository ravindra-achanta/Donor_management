import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/network_repos/jeevanadi_repo.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_event.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_state.dart';
import 'package:vikas_app/screeens/jeevanadi/view_jeevanadi_screen.dart';
import 'package:vikas_app/screeens/models/response/jeevanaadiView.dart';
import 'package:vikas_app/screeens/models/response/user.dart';


import '../../screeens/models/response/jeevanadi_member.dart';

class JeevanaadiBloc extends Bloc<JeevanaadiEvent, JeevanaadiState> {
  JeevanaadiBloc() : super(JeevanaadiState()) {
    on<FetchJeevanaadisEvent>(_onFetchJeevanaadiMems);
    on<FetchJeevanaadiProfileEvent>(_onFetchJeevanaadiProfile);
    on<FetchJeevanaadiProfileFullEvent>(_onFetchJeevanaadiProfileFull);
    on<CloseProfileView>(_closeProfileView);
    //on<FetchJeevanadiMemberEvent>(_onFetchJeevanadiMember);
    on<FetchAssignedKaryakarthasEvent>(_onFetchAssignedKaryakarthas);
    on<FetchUnassignedKaryakarthasEvent>(_onFetchUnassignedKaryakarthas);
    on<ToggleUnassignedSelectionEvent>(_onToggleUnassignedSelection);
    on<AssignSelectedKaryakarthasEvent>(_onAssignSelectedKaryakarthas);
    on<RemoveAssignedKaryakarthaEvent>(_onRemoveAssignedKaryakartha);
    //on<ClearJeevanadiDataEvent>(_onClearJeevanadiData);
    on<UpdateJeevanaadiProfileEvent>(_onUpdateProfile);
    on<ToggleAssignedSelectionEvent>(_onToggleAssignedSelection);
  on<ClearAssignedSelectionEvent>(_onClearAssignedSelection);
  on<RemoveSelectedAssignedMembersEvent>(_onRemoveSelectedAssignedMembers);
  }
  final JeevanaadiRepo = JeevanadiRepo();

  /// Event handler for fetching users
  // Future<void> _onFetchJeevanaadiMems(
  //   FetchJeevanaadisEvent event,
  //   Emitter<JeevanaadiState> emit,
  // ) async {
  //   emit(
  //     state.copyWith(
  //       status: JeevanaadiApiStatus.loading,
  //       isProfileViewVisible: false,
  //     ),
  //   );
  //   await Future.delayed(const Duration(seconds: 1), () {
  //     // Code to execute after a 3-second delay
  //     // print("3 seconds have passed!");
  //   });
  //   int size = 10;
  //   final response = await JeevanaadiRepo.getJeevanaadisMems(event.page, size);

  //   if (response.isSuccess) {
  //     final List<User> users = response.data?.content ?? [];
  //     emit(
  //       state.copyWith(
  //         status: JeevanaadiApiStatus.loaded,
  //         jeevanaadisMems: users,
  //         totalElements: response.data?.totalElements ?? 0,
  //         totalpages: response.data?.totalPages ?? 0,
  //         currentPage: response.data?.currentPage ?? 0,
  //       ),
  //     );
  //   } else {
  //     emit(
  //       state.copyWith(
  //         status: JeevanaadiApiStatus.error,
  //         errorMessage:
  //             response.error?.message ?? "Failed to fetch Jeevanaadis",
  //       ),
  //     );
  //   }
  // }

  Future<void> _onFetchJeevanaadiMems(
  FetchJeevanaadisEvent event,
  Emitter<JeevanaadiState> emit,
) async {
  emit(state.copyWith(status: JeevanaadiApiStatus.loading));
  try {
    final response = await JeevanaadiRepo.getJeevanaadisMems(event.page, 10);
    if (response.isSuccess) {
      final data = response.data;
      final members = data?.content ?? [];

      emit(state.copyWith(
        status: JeevanaadiApiStatus.loaded,
        jeevanaadisMems: members,
        totalElements: response.data?.totalElements ?? 0,
           totalpages: response.data?.totalPages ?? 0,
           currentPage: response.data?.currentPage ?? 0,
      ));
    } else {
      emit(state.copyWith(
        status: JeevanaadiApiStatus.error,
        errorMessage: response.error?.message ?? 'Failed to fetch members',
      ));
    }
  } catch (e, stack) {
    //debugPrint('Error parsing Jeevanaadi list: $e\n$stack');
    emit(state.copyWith(
      status: JeevanaadiApiStatus.error,
      errorMessage: 'Data parsing error: ${e.toString()}',
    ));
  }
}

//getbyid jeevandi profile:
Future<void> _onFetchJeevanaadiProfile(
  FetchJeevanaadiProfileEvent event,
  Emitter<JeevanaadiState> emit,
) async {
  emit(
    state.copyWith(
      isProfileViewVisible: true,
      profileLoading: true,
      profileErrorMsg: null,
    ),
  );

  try {
    final response = await JeevanaadiRepo.getJeevanaadiProfileFull(event.id);
    
    if (response.isSuccess) {
      emit(
        state.copyWith(
          profileLoading: false,
          jeevanaadiProfileFull: response.data, // Store full profile
          jeevanaadiProfile: null, // Clear old profile type
          profileErrorMsg: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          profileLoading: false,
          profileErrorMsg: response.error?.message ?? 'Failed to fetch profile',
        ),
      );
    }
  } catch (e) {
    emit(
      state.copyWith(
        profileLoading: false,
        profileErrorMsg: 'Error: ${e.toString()}',
      ),
    );
  }
}


  
   //assgned member list for karyakatha
  Future<void> _onFetchAssignedKaryakarthas(
  FetchAssignedKaryakarthasEvent event,
  Emitter<JeevanaadiState> emit,
) async {
  if (event.page == 0) {
    emit(state.copyWith(
      isLoadingAssigned: true,
      errorMessage: null,
    ));
  }

  try {
    print('🔵 Fetching assigned karyakarthas - MemberId: ${event.memberId}, Page: ${event.page}');
    
    final response = await JeevanaadiRepo.getAssignedKaryakarthas(
      karyakarthaId: event.memberId,
      page: event.page,
      size: 10, 
    );

    if (response.isSuccess) {
      final data = response.data;
      
      final List<User> users = data?.content.map((item) => item.toUser()).toList() ?? [];

      print('🔵 Received ${users.length} assigned users on page ${event.page}');
      
      final updatedList = event.page == 0
          ? users
          : [...state.assignedKaryakarthas, ...users];

      emit(state.copyWith(
        assignedKaryakarthas: updatedList,
        assignedTotalPages: data?.totalPages ?? 0,
        assignedTotalElements: data?.totalElements ?? 0,
        assignedCurrentPage: data?.currentPage ?? 0,
        isLoadingAssigned: false,
        errorMessage: null,
      ));
      
    } else {
      emit(state.copyWith(
        isLoadingAssigned: false,
        errorMessage: response.error?.message ?? 'Failed to fetch assigned karyakarthas',
      ));
    }
  } catch (e) {
    print('❌ Exception in _onFetchAssignedKaryakarthas: $e');
    emit(state.copyWith(
      isLoadingAssigned: false,
      errorMessage: 'Failed to fetch assigned karyakarthas: ${e.toString()}',
    ));
  }
}
  

//UNASSIGNED MEMBER
Future<void> _onFetchUnassignedKaryakarthas(
  FetchUnassignedKaryakarthasEvent event,
  Emitter<JeevanaadiState> emit,
) async {
  if (event.page == 0) {
    emit(state.copyWith(
      isLoadingUnassigned: true, 
      errorMessage: null,
      unassignedKaryakarthas: [],
    ));
  }

  try {
    print('🔵 Fetching unassigned - Page: ${event.page}');
    
    final response = await JeevanaadiRepo.getUnassignedJeevanadiUsers(
      page: event.page,
      size: 10,
    );

    if (response.isSuccess) {
      final data = response.data;
      
      final List<User> users = data?.content.map((unassignedUser) {
        return User(
          id: unassignedUser.id,
          name: unassignedUser.userName,
          email: unassignedUser.email,
          mobileNumber: '',
          uniqueId: unassignedUser.jeevanaadiNo,
          userType: 'JEEVANAADI',
          status: 'ACTIVE',
        );
      }).toList() ?? [];

      print('🔵 Received ${users.length} users on page ${event.page}');
      
      final updatedList = event.page == 0
          ? users
          : [...state.unassignedKaryakarthas, ...users];

      emit(state.copyWith(
        unassignedKaryakarthas: updatedList,
        unassignedTotalPages: data?.totalPages ?? 0,
        unassignedTotalElements: data?.totalElements ?? 0,
        unassignedCurrentPage: data?.currentPage ?? 0,
        isLoadingUnassigned: false,
        errorMessage: null,
      ));
      
    
    } else {
      emit(state.copyWith(
        isLoadingUnassigned: false,
        errorMessage: response.error?.message ?? 'Failed to fetch unassigned users',
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      isLoadingUnassigned: false,
      errorMessage: 'Failed to fetch unassigned karyakarthas: ${e.toString()}',
    ));
  }
}


  void _onToggleUnassignedSelection(
    ToggleUnassignedSelectionEvent event,
    Emitter<JeevanaadiState> emit,
  ) {
    final currentSelection = List<String>.from(state.selectedUnassignedIds);

    if (currentSelection.contains(event.userId)) {
      currentSelection.remove(event.userId);
    } else {
      currentSelection.add(event.userId);
    }

    emit(state.copyWith(selectedUnassignedIds: currentSelection));
  }

  

  //assign members to karyakatha

  Future<void> _onAssignSelectedKaryakarthas(
  AssignSelectedKaryakarthasEvent event,
  Emitter<JeevanaadiState> emit,
) async {
  if (event.memberIds.isEmpty) return;

  emit(state.copyWith(isAssigning: true, errorMessage: null));

  try {
    print('🔵 Assigning ${event.memberIds.length} members to karyakartha: ${event.karyakarthaId}');
    
    final response = await JeevanaadiRepo.allocateMembersToKaryakartha(
      karyakarthaId: event.karyakarthaId,
      memberIds: event.memberIds,
    );

    if (response.isSuccess) {
      emit(state.copyWith(
        isAssigning: false,
        selectedUnassignedIds: [], 
      ));
      
    
      add(FetchAssignedKaryakarthasEvent(event.karyakarthaId, 0, 10));
      add(FetchUnassignedKaryakarthasEvent(0));
      
    } else {
      emit(state.copyWith(
        isAssigning: false,
        errorMessage: response.error?.message ?? 'Failed to assign members',
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      isAssigning: false,
      errorMessage: 'Failed to assign members: ${e.toString()}',
    ));
  }
}


//deallocate member from karyakatha
  Future<void> _onRemoveAssignedKaryakartha(
  RemoveAssignedKaryakarthaEvent event,
  Emitter<JeevanaadiState> emit,
) async {
  emit(state.copyWith(isRemoving: true, errorMessage: null));

  try {
    
    final response = await JeevanaadiRepo.deallocateMembersFromKaryakartha(
      karyakarthaId: event.karyakarthaId,
      memberIds: [event.memberId], 
    );

    if (response.isSuccess) {
      emit(state.copyWith(isRemoving: false));
      
      
      add(FetchAssignedKaryakarthasEvent(event.karyakarthaId, 0, 10));
      add(FetchUnassignedKaryakarthasEvent(0));
      
    } else {
      emit(state.copyWith(
        isRemoving: false,
        errorMessage: response.error?.message ?? 'Failed to remove member',
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      isRemoving: false,
      errorMessage: 'Failed to remove member: ${e.toString()}',
    ));
  }
}

  Future<void> _closeProfileView(
    CloseProfileView event,
    Emitter<JeevanaadiState> emit,
  ) async {
    emit(state.copyWith(isProfileViewVisible: false));
  }


//full jeevandi view:
Future<void> _onFetchJeevanaadiProfileFull(
  FetchJeevanaadiProfileFullEvent event,
  Emitter<JeevanaadiState> emit,
) async {
  emit(state.copyWith(
    isProfileViewVisible: true,
    profileLoading: true,
    profileErrorMsg: null,
  ));

  try {
    final response = await JeevanaadiRepo.getJeevanaadiProfileFull(event.jeevanadiNo);

    if (response.isSuccess) {
      emit(state.copyWith(
        profileLoading: false,
        jeevanaadiProfileFull: response.data,
        profileErrorMsg: null,
      ));
    } else {
      emit(state.copyWith(
        profileLoading: false,
        profileErrorMsg: response.error?.message ?? 'Failed to fetch full profile',
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      profileLoading: false,
      profileErrorMsg: 'Data parsing error: ${e.toString()}',
    ));
  }
}


Future<void> _onUpdateProfile(
  UpdateJeevanaadiProfileEvent event,
  Emitter<JeevanaadiState> emit,
) async {
  emit(state.copyWith(
    isUpdateLoading: true,
    updateErrorMsg: null,
    updateSuccessMsg: null,
  ));

  try {
    final result = await JeevanaadiRepo.updateJeevanaadiProfile(
      jeevanadiId: event.userid,
      updateData: event.updateData,
    );

    if (result.isSuccess) {
      emit(state.copyWith(
        isUpdateLoading: false,
        updateSuccessMsg: "Profile updated successfully",
        updateResponse: result.data,
      ));
      
      add(FetchJeevanaadiProfileFullEvent(event.userid));
    } else {
      emit(state.copyWith(
        isUpdateLoading: false,
        updateErrorMsg: result.error?.message ?? "Update failed",
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      isUpdateLoading: false,
      updateErrorMsg: "Error: ${e.toString()}",
    ));
  }
}

void _onToggleAssignedSelection(
  ToggleAssignedSelectionEvent event,
  Emitter<JeevanaadiState> emit,
) {
  final currentSelection = List<String>.from(state.selectedAssignedIds);

  if (currentSelection.contains(event.userId)) {
    currentSelection.remove(event.userId);
  } else {
    currentSelection.add(event.userId);
  }

  emit(state.copyWith(selectedAssignedIds: currentSelection));
}

void _onClearAssignedSelection(
  ClearAssignedSelectionEvent event,
  Emitter<JeevanaadiState> emit,
) {
  emit(state.copyWith(selectedAssignedIds: const []));
}

Future<void> _onRemoveSelectedAssignedMembers(
  RemoveSelectedAssignedMembersEvent event,
  Emitter<JeevanaadiState> emit,
) async {
  if (state.selectedAssignedIds.isEmpty) {
    emit(state.copyWith(
      errorMessage: 'Please select members to remove',
    ));
    return;
  }

  emit(state.copyWith(isRemoving: true, errorMessage: null));

  try {
    final response = await JeevanaadiRepo.deallocateMembersFromKaryakartha(
      karyakarthaId: event.karyakarthaId,
      memberIds: state.selectedAssignedIds,
    );

    if (response.isSuccess) {
      emit(state.copyWith(
        isRemoving: false,
        selectedAssignedIds: const [],
        errorMessage: null,
      ));
      
      add(FetchAssignedKaryakarthasEvent(event.karyakarthaId, 0, 10));
      add(FetchUnassignedKaryakarthasEvent(0));
      
    } else {
      emit(state.copyWith(
        isRemoving: false,
        errorMessage: response.error?.message ?? 'Failed to remove members',
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      isRemoving: false,
      errorMessage: 'Failed to remove members: ${e.toString()}',
    ));
  }
}

}
