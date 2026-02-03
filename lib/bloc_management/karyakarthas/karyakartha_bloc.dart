import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/network_repos/karyakatta_repo.dart';

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

    final response = await karyakattaRepo.getKaryakarthas();

    if (response.isSuccess) {
      emit(
        state.copyWith(
          status: KaryakattaApiStatus.loaded,
          users: response.data,
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
  // Future<void> _onFetchUsers(
  //   FetchKaryakattasEvent event,
  //   Emitter<KaryakarthaState> emit,
  // ) async {
  //   emit(state.copyWith(status: KaryakattaState.loading));

  //   try {
  //     const String key = 'userList';
  //     final prefs = await SharedPreferences.getInstance();
  //     final List<String> existing = prefs.getStringList(key) ?? [];

  //     final List<LocalUser> users =
  //         existing.map((e) => LocalUser.fromJson(jsonDecode(e))).toList();

  //     emit(state.copyWith(users: users, status: KaryakattaState.loaded));
  //   } catch (e) {
  //     emit(state.copyWith(
  //       status: KaryakattaState.error,
  //       errorMessage: e.toString(),
  //     ));
  //   }
  // }

  // void _addUser(AddKaryakarthaEvent event, Emitter<KaryakarthaState> emit) async {
  //   emit(state.copyWith(status: KaryakattaState.loading));

  //   try {
  //     const String key = 'userList';
  //     final prefs = await SharedPreferences.getInstance();

  //     // Generate a random unique ID
  //     // Retrieve existing users
  //     List<String> existing = prefs.getStringList(key) ?? [];

  //     // Create the new user and add to stored list
  //     final user = LocalUser(
  //       Mobile: event.user.Mobile,
  //       email: event.user.email,
  //       id: event.user.id,
  //     );

  //     existing.add(jsonEncode(user.toJson()));

  //     // Save the updated list
  //     await prefs.setStringList(key, existing);

  //     // Build LocalUser objects for the updated list and emit them so
  //     // the HomeScreen updates without triggering another FetchUsersEvent.
  //     final List<LocalUser> users =
  //         existing.map((e) => LocalUser.fromJson(jsonDecode(e))).toList();

  //     // Emit success with updated users
  //     emit(state.copyWith(status: HomeStatus.loaded, users: users));
  //   } catch (e) {
  //     emit(
  //         state.copyWith(status: HomeStatus.error, errorMessage: e.toString()));
  //   }
  // }

  // Future<void> _deleteUser(
  //     DeleteUserEvent event, Emitter<HomeState> emit) async {
  //   emit(state.copyWith(delLoading: true));
  //   try {
  //     await Future.delayed(const Duration(seconds: 2), () {
  //       // Code to execute after a 3-second delay
  //       print("3 seconds have passed!");
  //     });
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     const String key = 'userList';

  //     // Retrieve saved users
  //     final List<String> storedUsers = prefs.getStringList(key) ?? [];

  //     // Convert JSON string list -> List<LocalUser>
  //     List<LocalUser> users =
  //         storedUsers.map((e) => LocalUser.fromJson(jsonDecode(e))).toList();

  //     // Remove user with matching ID
  //     users.removeWhere((user) => user.id == event.userId.toString());

  //     // Convert updated list back to JSON strings
  //     final updatedList = users.map((u) => jsonEncode(u.toJson())).toList();

  //     // Save back to SharedPreferences
  //     await prefs.setStringList(key, updatedList);

  //     // Emit success state with updated list
  //     emit(state.copyWith(delLoading: false, users: users));
  //   } catch (e) {
  //     emit(state.copyWith(delLoading: false, errorMessage: e.toString()));
  //   }
  // }

  // void _updateUser(UpdateUserEvent event, Emitter<HomeState> emit) async {
  //   emit(state.copyWith(status: HomeStatus.loading));

  //   try {
  //     const String key = 'userList';
  //     final prefs = await SharedPreferences.getInstance();

  //     // Load all users
  //     List<String> existing = prefs.getStringList(key) ?? [];

  //     List<LocalUser> users =
  //         existing.map((e) => LocalUser.fromJson(jsonDecode(e))).toList();

  //     // Remove the user with the same ID
  //     users.removeWhere((u) => u.id == event.user.id);

  //     // Add the updated user
  //     users.add(event.user);

  //     // Convert back to JSON strings
  //     List<String> updatedUsers =
  //         users.map((u) => jsonEncode(u.toJson())).toList();

  //     // Save to SharedPreferences
  //     await prefs.setStringList(key, updatedUsers);

  //     // Emit updated state with fresh copy
  //     emit(state.copyWith(
  //       status: HomeStatus.loaded,
  //       users: List<LocalUser>.from(users),
  //     ));
  //   } catch (e) {
  //     emit(state.copyWith(
  //       status: HomeStatus.error,
  //       errorMessage: e.toString(),
  //     ));
  //   }
  // }

  // _getUserDetails(GetUser event, Emitter<HomeState> emit) async {
  //   emit(state.copyWith(status: HomeStatus.loading));
  //   try {
  //     final SharedPreferences pref = await SharedPreferences.getInstance();
  //     List<String> localUser = pref.getStringList('userList') ?? [];
  //     List<LocalUser> users =
  //         localUser.map((itm) => LocalUser.fromJson(jsonDecode(itm))).toList();
  //     LocalUser user = users.firstWhere((itm) => itm.id == event.userId);
  //     emit(state.copyWith(status: HomeStatus.loaded, user: user));
  //   } catch (e) {
  //     emit(
  //         state.copyWith(status: HomeStatus.error, errorMessage: e.toString()));
  //   }
  // }
}
