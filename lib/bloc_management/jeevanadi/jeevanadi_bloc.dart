import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/network_repos/jeevanadi_repo.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_event.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_state.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

class JeevanaadiBloc extends Bloc<JeevanaadiEvent, JeevanaadiState> {
  JeevanaadiBloc() : super(JeevanaadiState()) {
    on<FetchJeevanaadisEvent>(_onFetchJeevanaadiMems);
    // on<AddUserEvent>(_addUser);
    // on<DeleteUserEvent>(_deleteUser);
    on<FetchJeevanaadiProfileEvent>(_onFetchJeevanaadiProfile);
    on<CloseProfileView>(_closeProfileView);
    // on<UpdateUserEvent>(_updateUser);
  }
  final JeevanaadiRepo = JeevanadiRepo();

  /// Event handler for fetching users
  Future<void> _onFetchJeevanaadiMems(
    FetchJeevanaadisEvent event,
    Emitter<JeevanaadiState> emit,
  ) async {
    emit(state.copyWith(status: JeevanaadiApiStatus.loading));
    int size = 1;
    final response = await JeevanaadiRepo.getJeevanaadisMems(event.page, size);

    if (response.isSuccess) {
      final List<User> users = response.data?.content ?? [];
      emit(
        state.copyWith(
          status: JeevanaadiApiStatus.loaded,
          jeevanaadisMems: users,
          totalElements: response.data?.totalElements ?? 0,
          totalpages: response.data?.totalPages ?? 0,
          currentPage: response.data?.currentPage ?? 0,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: JeevanaadiApiStatus.error,
          errorMessage:
              response.error?.message ?? "Failed to fetch Jeevanaadis",
        ),
      );
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

  Future<void> _closeProfileView(
    CloseProfileView event,
    Emitter<JeevanaadiState> emit,
  ) async {
    emit(state.copyWith(isProfileViewVisible: false));
  }
}
