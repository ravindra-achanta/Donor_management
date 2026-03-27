import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/api_result.dart';
import 'package:vikas_app/api_services/network_repos/jeevanadi_repo.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_event.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_state.dart';
import 'package:vikas_app/screeens/models/response/jeevanaadi_paginated_view.dart';

class JeevanaadiBloc extends Bloc<JeevanaadiEvent, JeevanaadiState> {
  JeevanaadiBloc() : super(JeevanaadiState()) {
    on<FetchJeevanaadisEvent>(_onFetchJeevanaadiMems);
    on<FetchJeevanaadiProfileEvent>(_onFetchJeevanaadiProfile);
    on<FetchJeevanaadiProfileFullEvent>(_onFetchJeevanaadiProfileFull);
    on<FetchJeevanaadiDonationEvent>(_onFetchJeevanaadiDonations);
    on<FetchJeevanaadiProfileFromRequestEvent>(
      _onFetchJeevanaadiProfileFromRequest,
    );
    on<CloseProfileView>(_closeProfileView);
    on<FetchAssignedKaryakarthasEvent>(_onFetchAssignedJeevanadis);
    on<FetchUnassignedKaryakarthasEvent>(_onFetchUnassignedJeevanaadies);
    on<ToggleUnassignedSelectionEvent>(_onToggleUnassignedSelection);
    on<AssignSelectedKaryakarthasEvent>(_onAssignSelectedKaryakarthas);
    on<RemoveAssignedKaryakarthaEvent>(_onRemoveAssignedKaryakartha);
    on<UpdateJeevanaadiProfileEvent>(_onUpdateProfile);
    on<ToggleAssignedSelectionEvent>(_onToggleAssignedSelection);
    on<ClearAssignedSelectionEvent>(_onClearAssignedSelection);
    on<RemoveSelectedAssignedMembersEvent>(_onRemoveSelectedAssignedMembers);
    on<ApproveJeevanaadiEvent>(_onApproveJeevanaadi);
    on<SearchJeevanaadiUsersEvent>(_onSearchJeevanaadiUsers);
  }
  final JeevanaadiRepo = JeevanadiRepo();

  Future<void> _onFetchJeevanaadiDonations(
    FetchJeevanaadiDonationEvent event,
    Emitter<JeevanaadiState> emit,
  ) async {
    emit(state.copyWith(loadingDonations: true, donationsError: null));
    try {
      final response = await JeevanaadiRepo.getJeevanaadisDonations(
        event.page,
        10,
        event.jeevanadiId,
      );
      if (response.isSuccess) {
        final data = response.data;
        final donations = data?.content ?? [];

        emit(
          state.copyWith(
            loadingDonations: false,
            allDonations: donations,
            donationsError: null,
            totalDonationElements: response.data?.totalElements ?? 0,
            donationCurrentPage: response.data?.currentPage ?? 0,
            totalDonationpages: response.data?.totalPages ?? 0,
          ),
        );
      } else {
        emit(
          state.copyWith(
            loadingDonations: false,
            donationsError:
                response.error?.message ?? 'Failed to fetch members',
          ),
        );
      }
    } catch (e, stack) {
      emit(
        state.copyWith(
          loadingDonations: false,
          donationsError: e.toString() ?? 'Failed to fetch members',
        ),
      );
    }
  }

  Future<void> _onFetchJeevanaadiMems(
    FetchJeevanaadisEvent event,
    Emitter<JeevanaadiState> emit,
  ) async {
    emit(
      state.copyWith(
        status: JeevanaadiApiStatus.loading,
        isProfileViewVisible: false,
       orderedBy: event.orderedBy ?? state.orderedBy,
      ),
    );
    try {
      final response = await JeevanaadiRepo.getJeevanaadisMems(event.page,  event.size, event.searchQuery, event.orderedBy);
      if (response.isSuccess) {
        final data = response.data;
        final members = data?.content ?? [];


        emit(
          state.copyWith(
            status: JeevanaadiApiStatus.loaded,
            jeevanaadisMems: members,
            totalElements: response.data?.totalElements ?? 0,
            totalpages: response.data?.totalPages ?? 0,
            currentPage: response.data?.currentPage ?? 0,
            orderedBy: event.orderedBy, 
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: JeevanaadiApiStatus.error,
            errorMessage: response.error?.message ?? 'Failed to fetch ',
          ),
        );
      }
    } catch (e, stack) {
      //debugPrint('Error parsing Jeevanaadi list: $e\n$stack');
      emit(
        state.copyWith(
          status: JeevanaadiApiStatus.error,
          errorMessage: 'Data parsing error: ${e.toString()}',
        ),
      );
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
      final response = await JeevanaadiRepo.getJeevanaadiProfile(event.id);

      if (response.isSuccess) {
        emit(
          state.copyWith(
            profileLoading: false,
            jeevanaadiProfileFull: response.data,
            profileErrorMsg: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            profileLoading: false,
            profileErrorMsg:
                response.error?.message ?? 'Failed to fetch profile',
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
 
  Future<void> _onFetchAssignedJeevanadis(
  FetchAssignedKaryakarthasEvent event,
  Emitter<JeevanaadiState> emit,
) async {
  if (event.page == 0) {
    emit(state.copyWith(
      isLoadingAssigned: true,
      errorMessage: null,
      assignedKaryakarthas: [],
    ));
  } else {
    emit(state.copyWith(
      isLoadingAssigned: true,
      errorMessage: null,
    ));
  }

  try {
    final response = await JeevanaadiRepo.getAssignedJeevanaadis(
      karyakarthaId: event.memberId,
      page: event.page,
      size: 10,
       searchQuery: event.searchQuery,
         orderedBy: event.order,
    );

    if (response.isSuccess) {
      final data = response.data;
      final newMembers = data?.content ?? [];

      final updatedList = (event.page == 0)
          ? newMembers
          : [...state.assignedKaryakarthas, ...newMembers];

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
    emit(state.copyWith(
      isLoadingAssigned: false,
      errorMessage: 'Failed to fetch assigned karyakarthas: ${e.toString()}',
    ));
  }
}

  

 // //UNASSIGNED MEMBER
  Future<void> _onFetchUnassignedJeevanaadies(
  FetchUnassignedKaryakarthasEvent event,
  Emitter<JeevanaadiState> emit,
) async {
  if (event.page == 0) {
    emit(state.copyWith(
      isLoadingUnassigned: true,
      errorMessage: null,
      unassignedKaryakarthas: [],
    ));
  } else {
    emit(state.copyWith(
      isLoadingUnassigned: true,
      errorMessage: null,
    ));
  }

  try {
    print('🔵 Fetching unassigned - Page: ${event.page}');

    final response = await JeevanaadiRepo.getUnassignedJeevanadiUsers(
      page: event.page,
      size: 10,
      searchQuery: event.searchQuery, 
      orderedBy: event.orderedBy,
    );

    if (response.isSuccess) {
      final data = response.data;
      final newMembers = data?.content ?? [];

     
      final updatedList = (event.page == 0)
          ? newMembers
          : [...state.unassignedKaryakarthas, ...newMembers];

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
      print(
        '🔵 Assigning ${event.memberIds.length} members to karyakartha: ${event.karyakarthaId}',
      );

      final response = await JeevanaadiRepo.allocateMembersToKaryakartha(
        karyakarthaId: event.karyakarthaId,
        memberIds: event.memberIds,
      );

      if (response.isSuccess) {
        emit(state.copyWith(isAssigning: false, selectedUnassignedIds: []));

        add(FetchAssignedKaryakarthasEvent(event.karyakarthaId, 0, 10));
        add(FetchUnassignedKaryakarthasEvent(0, 10, null, null));
      } else {
        emit(
          state.copyWith(
            isAssigning: false,
            errorMessage: response.error?.message ?? 'Failed to assign members',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isAssigning: false,
          errorMessage: 'Failed to assign members: ${e.toString()}',
        ),
      );
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
        add(FetchUnassignedKaryakarthasEvent(0, 10, null, null));
      } else {
        emit(
          state.copyWith(
            isRemoving: false,
            errorMessage: response.error?.message ?? 'Failed to remove member',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isRemoving: false,
          errorMessage: 'Failed to remove member: ${e.toString()}',
        ),
      );
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
    emit(
      state.copyWith(
        isProfileViewVisible: true,
        profileLoading: true,
        profileErrorMsg: null,
      ),
    );

    try {
      final response = await JeevanaadiRepo.getJeevanaadiProfileFull(
        event.jeevanadiNo,
      );

      if (response.isSuccess) {
        emit(
          state.copyWith(
            profileLoading: false,
            jeevanaadiProfileFull: response.data,
            profileErrorMsg: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            profileLoading: false,
            profileErrorMsg:
                response.error?.message ?? 'Failed to fetch full profile',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          profileLoading: false,
          profileErrorMsg: 'Data parsing error: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUpdateProfile(
    UpdateJeevanaadiProfileEvent event,
    Emitter<JeevanaadiState> emit,
  ) async {
    emit(
      state.copyWith(
        isUpdateLoading: true,
        updateErrorMsg: null,
        updateSuccessMsg: null,
      ),
    );

    try {
      final result = await JeevanaadiRepo.updateJeevanaadiProfile(
        jeevanadiId: event.userid,
        updateData: event.updateData,
      );

      if (result.isSuccess) {
        emit(
          state.copyWith(
            isUpdateLoading: false,
            updateSuccessMsg: "Profile updated successfully",
            updateResponse: result.data,
          ),
        );

        add(FetchJeevanaadiProfileFullEvent(event.userid));
      } else {
        emit(
          state.copyWith(
            isUpdateLoading: false,
            updateErrorMsg: result.error?.message ?? "Update failed",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isUpdateLoading: false,
          updateErrorMsg: "Error: ${e.toString()}",
        ),
      );
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
      emit(state.copyWith(errorMessage: 'Please select members to remove'));
      return;
    }

    emit(state.copyWith(isRemoving: true, errorMessage: null));

    try {
      final response = await JeevanaadiRepo.deallocateMembersFromKaryakartha(
        karyakarthaId: event.karyakarthaId,
        memberIds: state.selectedAssignedIds,
      );

      if (response.isSuccess) {
        emit(
          state.copyWith(
            isRemoving: false,
            selectedAssignedIds: const [],
            errorMessage: null,
          ),
        );

        add(FetchAssignedKaryakarthasEvent(event.karyakarthaId, 0, 10));
        add(FetchUnassignedKaryakarthasEvent(0, 10, null,null));
      } else {
        emit(
          state.copyWith(
            isRemoving: false,
            errorMessage: response.error?.message ?? 'Failed to remove members',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isRemoving: false,
          errorMessage: 'Failed to remove members: ${e.toString()}',
        ),
      );
    }
  }

  //FETCH REQUEST VIEW PROFILE
  Future<void> _onFetchJeevanaadiProfileFromRequest(
    FetchJeevanaadiProfileFromRequestEvent event,
    Emitter<JeevanaadiState> emit,
  ) async {
    emit(
      state.copyWith(
        isProfileViewVisible: true,
        profileLoading: true,
        profileErrorMsg: null,
        isFromRequest: true,
        requestId: event.jeevanadiId,
        requestStatus: 'PENDING',
      ),
    );

    try {
      final response = await JeevanaadiRepo.getJeevanaadiProfileFromRequest(
        event.jeevanadiId,
      );

      if (response.isSuccess) {
        emit(
          state.copyWith(
            profileLoading: false,
            jeevanaadiProfileFull: response.data,
            profileErrorMsg: null,
            isFromRequest: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            profileLoading: false,
            profileErrorMsg:
                response.error?.message ?? 'Failed to fetch request profile',
            isFromRequest: false,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          profileLoading: false,
          profileErrorMsg: 'Error: ${e.toString()}',
          isFromRequest: false,
        ),
      );
    }
  }

Future<void> _onApproveJeevanaadi(
  ApproveJeevanaadiEvent event,
  Emitter<JeevanaadiState> emit,
) async {
  emit(state.copyWith(
    isApproving: true,
    approveSuccessMsg: null,
    approveErrorMsg: null,
  ));

  try {
    final result = await JeevanaadiRepo.approveJeevanaadi(event.jeevanadiId);

    if (result.isSuccess) {
      final message = result.data?['message'] ?? 'Approved successfully';
      emit(state.copyWith(
        isApproving: false,
        approveSuccessMsg: message,
        requestStatus: 'APPROVED',
        approveErrorMsg: null,
      ));
    } else {
      emit(state.copyWith(
        isApproving: false,
        approveErrorMsg: result.error?.message ?? 'Approval failed',
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      isApproving: false,
      approveErrorMsg: 'Error: ${e.toString()}',
    ));
  }
}
  

 Future<void> _onSearchJeevanaadiUsers(
  SearchJeevanaadiUsersEvent event,
  Emitter<JeevanaadiState> emit,
) async {
  if (event.query.trim().isEmpty) {
    emit(state.copyWith(
      searchResults: const [],
      searchLoading: false,
      searchError: null,
    ));
    return;
  }

  emit(state.copyWith(searchLoading: true, searchError: null));

  try {
    final result = await JeevanaadiRepo.searchJeevanaadiUsers(event.query);
    if (result.isSuccess) {
      emit(state.copyWith(
        searchLoading: false,
        searchResults: result.data ?? [],
        searchError: null,
      ));
    } else {
      emit(state.copyWith(
        searchLoading: false,
        searchError: result.error?.message ?? 'Search failed',
        searchResults: const [],
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      searchLoading: false,
      searchError: 'Error: ${e.toString()}',
      searchResults: const [],
    ));
  }
}
}
