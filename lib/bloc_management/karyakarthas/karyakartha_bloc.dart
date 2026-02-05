import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/network_repos/karyakatta_repo.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

import 'karyakartha_event.dart';
import 'karyakartha_state.dart';

class KaryakarthaBloc extends Bloc<KaryakarthaEvent, KaryakarthaState> {
  KaryakarthaBloc() : super(KaryakarthaState()) {
    on<FetchKaryakattasEvent>(_onFetchKaryakattas);
    // on<AddUserEvent>(_addUser);
    // on<DeleteUserEvent>(_deleteUser);
    on<FetchKaryakarthaProfileEvent>(_onFetchKaryakarthaProfile);
    on<CloseProfileView>(_closeProfileView);
    // on<UpdateUserEvent>(_updateUser);
  }
  final karyakattaRepo = KaryakattaRepo();

  /// Event handler for fetching users
  Future<void> _onFetchKaryakattas(
    FetchKaryakattasEvent event,
    Emitter<KaryakarthaState> emit,
  ) async {
    emit(state.copyWith(status: KaryakattaApiStatus.loading));
    int size = 10;

    final response = await karyakattaRepo.getKaryakarthas(event.page, size);

    if (response.isSuccess) {
      final List<User> users = response.data?.content ?? [];
      emit(
        state.copyWith(
          status: KaryakattaApiStatus.loaded,
          users: users,
          totalElements: response.data?.totalElements ?? 0,
          totalpages: response.data?.totalPages ?? 0,
          currentPage: response.data?.currentPage ?? 0,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: KaryakattaApiStatus.error,
          errorMessage:
              response.error?.message ?? "Failed to fetch karyakarthas",
        ),
      );
    }
  }

  Future<void> _onFetchKaryakarthaProfile(
    FetchKaryakarthaProfileEvent event,
    Emitter<KaryakarthaState> emit,
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
    final response = await karyakattaRepo.getKaryakarthaProfile(event.userId);
    if (response.isSuccess) {
      emit(
        state.copyWith(
          profileLoading: false, // ✅ IMPORTANT
          karyakarthaProfile: response.data,
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
    Emitter<KaryakarthaState> emit,
  ) async {
    emit(state.copyWith(isProfileViewVisible: false));
  }
}
