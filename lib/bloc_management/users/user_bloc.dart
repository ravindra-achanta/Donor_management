import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/network_repos/user_repo.dart';
import 'package:vikas_app/bloc_management/users/user_event.dart';
import 'package:vikas_app/bloc_management/users/user_state.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  @override
  UserBloc() : super(UserState()) {
    on<FetchUsersEvent>(_fetchUsers);
    on<CloseProfileView>(_closeProfileView);
    on<FetchUsersProfileEvent>(_onFetchJeevanaadiProfile);
  }

  final userRepo = UserRepo();
  Future<void> _fetchUsers(
    FetchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(
      state.copyWith(
        status: UserScreenState.loading,
        isProfileViewVisible: false,
      ),
    );
    await Future.delayed(const Duration(seconds: 1), () {
      // Code to execute after a 3-second delay
      // print("3 seconds have passed!");
    });
    int size = 10;
    final response = await userRepo.getUsers(event.page, size,searchQuery: event.searchQuery,);

    if (response.isSuccess) {
      final List<User> users = response.data?.content ?? [];
      emit(
        state.copyWith(
          status: UserScreenState.loaded,
          users: users,
          totalElements: response.data?.totalElements ?? 0,
          totalpages: response.data?.totalPages ?? 0,
          currentPage: response.data?.currentPage ?? 0,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: UserScreenState.error,
          errorMessage: response.error?.message ?? "Failed to fetch users",
        ),
      );
    }
  }

  Future<void> _onFetchJeevanaadiProfile(
    FetchUsersProfileEvent event,
    Emitter<UserState> emit,
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
    final response = await userRepo.getUserProfile(event.userId);
    if (response.isSuccess) {
      emit(
        state.copyWith(
          profileLoading: false, // ✅ IMPORTANT
          user: response.data,
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
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(isProfileViewVisible: false));
  }
}
