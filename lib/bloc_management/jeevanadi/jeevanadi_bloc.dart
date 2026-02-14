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
    on<FetchJeevanadiMemberEvent>(_onFetchJeevanadiMember);
    on<FetchAssignedKaryakarthasEvent>(_onFetchAssignedKaryakarthas);
    on<FetchUnassignedKaryakarthasEvent>(_onFetchUnassignedKaryakarthas);
    on<ToggleUnassignedSelectionEvent>(_onToggleUnassignedSelection);
    on<AssignSelectedKaryakarthasEvent>(_onAssignSelectedKaryakarthas);
    on<RemoveAssignedKaryakarthaEvent>(_onRemoveAssignedKaryakartha);
    // on<ClearJeevanadiDataEvent>(_onClearJeevanadiData);
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
    await Future.delayed(const Duration(seconds: 1), () {
      // Code to execute after a 3-second delay
      // print("3 seconds have passed!");
    });
    final response = await JeevanaadiRepo.getJeevanaadiProfile(event.userId);
    if (response.isSuccess) {
      emit(
        state.copyWith(
          profileLoading: false, // ✅ IMPORTANT
          jeevanaadiProfile: response.data,
          profileErrorMsg: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          profileLoading: false, // ✅ IMPORTANT
          profileErrorMsg: 'Failed to fetch profile',
        ),
      );
    }
  }

  Future<void> _onFetchJeevanadiMember(
    FetchJeevanadiMemberEvent event,
    Emitter<JeevanaadiState> emit,
  ) async {
    emit(state.copyWith(status: JeevanaadiApiStatus.loading));

    try {
      // Dummy API call - replace with actual API
      await Future.delayed(const Duration(seconds: 1));

      final dummyMember = JeevanadiMember(
        id: event.memberId,
        name: 'Arun Kumar',
        joined: '2024-01-15',
        mobile: '9876543210',
        gothram: 'Kashyapa',
        referredBy: 'Admin',
        email: 'arun@example.com',
        role: 'DONOR',
        status: true,
      );

      emit(
        state.copyWith(
          status: JeevanaadiApiStatus.loaded,
          jeevanadiMember: dummyMember,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: JeevanaadiApiStatus.error,
          errorMessage: 'Failed to fetch jeevanadi member: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onFetchAssignedKaryakarthas(
    FetchAssignedKaryakarthasEvent event,
    Emitter<JeevanaadiState> emit,
  ) async {
    try {
      // Dummy API call - replace with actual API
      await Future.delayed(const Duration(milliseconds: 500));

      final dummyAssignedKaryakarthas = [
        User(
          id: 'KA-001',
          name: 'Ravi Shankar',
          email: 'ravi@example.com',
          mobileNumber: '9876543211',
          uniqueId: 'KA-001',
          userType: 'KARYAKARTHA',
          status: 'ACTIVE',
        ),
        User(
          id: 'KA-002',
          name: 'Priya Verma',
          email: 'priya@example.com',
          mobileNumber: '9876543212',
          uniqueId: 'KA-002',
          userType: 'KARYAKARTHA',
          status: 'ACTIVE',
        ),
      ];

      emit(state.copyWith(assignedKaryakarthas: dummyAssignedKaryakarthas));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage:
              'Failed to fetch assigned karyakarthas: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onFetchUnassignedKaryakarthas(
    FetchUnassignedKaryakarthasEvent event,
    Emitter<JeevanaadiState> emit,
  ) async {
    try {
      // Dummy API call - replace with actual API
      await Future.delayed(const Duration(milliseconds: 500));

      final dummyUnassignedKaryakarthas = [
        User(
          id: 'KA-003',
          name: 'Kiran Sharma',
          email: 'kiran@example.com',
          mobileNumber: '9876543213',
          uniqueId: 'KA-003',
          userType: 'KARYAKARTHA',
          status: 'ACTIVE',
        ),
        User(
          id: 'KA-004',
          name: 'Meena Patel',
          email: 'meena@example.com',
          mobileNumber: '9876543214',
          uniqueId: 'KA-004',
          userType: 'KARYAKARTHA',
          status: 'ACTIVE',
        ),
        User(
          id: 'KA-005',
          name: 'Arun Kumar',
          email: 'arun.k@example.com',
          mobileNumber: '9876543215',
          uniqueId: 'KA-005',
          userType: 'KARYAKARTHA',
          status: 'ACTIVE',
        ),
      ];

      // If it's not the first page, append to existing list
      final updatedList = event.page == 1
          ? dummyUnassignedKaryakarthas
          : [...state.unassignedKaryakarthas, ...dummyUnassignedKaryakarthas];

      emit(state.copyWith(unassignedKaryakarthas: updatedList));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage:
              'Failed to fetch unassigned karyakarthas: ${e.toString()}',
        ),
      );
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

  Future<void> _onAssignSelectedKaryakarthas(
    AssignSelectedKaryakarthasEvent event,
    Emitter<JeevanaadiState> emit,
  ) async {
    if (state.selectedUnassignedIds.isEmpty) return;

    emit(state.copyWith(isAssigning: true));

    try {
      // Dummy API call - replace with actual API
      await Future.delayed(const Duration(seconds: 1));

      // Move selected users from unassigned to assigned
      final selectedUsers = state.unassignedKaryakarthas
          .where((user) => state.selectedUnassignedIds.contains(user.id))
          .toList();

      final updatedAssigned = [...state.assignedKaryakarthas, ...selectedUsers];
      final updatedUnassigned = state.unassignedKaryakarthas
          .where((user) => !state.selectedUnassignedIds.contains(user.id))
          .toList();

      emit(
        state.copyWith(
          isAssigning: false,
          assignedKaryakarthas: updatedAssigned,
          unassignedKaryakarthas: updatedUnassigned,
          selectedUnassignedIds: [],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isAssigning: false,
          errorMessage: 'Failed to assign karyakarthas: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRemoveAssignedKaryakartha(
    RemoveAssignedKaryakarthaEvent event,
    Emitter<JeevanaadiState> emit,
  ) async {
    emit(state.copyWith(isRemoving: true));

    try {
      // Dummy API call - replace with actual API
      await Future.delayed(const Duration(milliseconds: 500));

      // Remove from assigned and add back to unassigned
      final removedUser = state.assignedKaryakarthas.firstWhere(
        (user) => user.id == event.karyakarthaId,
      );

      final updatedAssigned = state.assignedKaryakarthas
          .where((user) => user.id != event.karyakarthaId)
          .toList();

      final updatedUnassigned = [removedUser, ...state.unassignedKaryakarthas];

      emit(
        state.copyWith(
          isRemoving: false,
          assignedKaryakarthas: updatedAssigned,
          unassignedKaryakarthas: updatedUnassigned,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isRemoving: false,
          errorMessage: 'Failed to remove karyakartha: ${e.toString()}',
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
  emit(state.copyWith(
    isProfileViewVisible: true,
    profileLoading: true,
    profileErrorMsg: null,
  ));

  try {
    final response = await JeevanaadiRepo.getJeevanaadiProfileFull(event.userId);

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

}
