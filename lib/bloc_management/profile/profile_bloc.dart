import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/network_repos/karyakatta_repo.dart';
import 'package:vikas_app/api_services/network_repos/profile_repo.dart';
import 'package:vikas_app/bloc_management/profile/profile_event.dart';
import 'package:vikas_app/bloc_management/profile/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState()) {
    on<FetchProfile>(_fetchPrfile);
     on<UpdateProfile>(_updateProfile);
  }

  final profileRepo = ProfileRepo();
  Future<void> _fetchPrfile(
    FetchProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading, profileErrorMsg: null));
    await Future.delayed(const Duration(seconds: 1), () {
      // Code to execute after a 3-second delay
      // print("3 seconds have passed!");
    });

    // final response = await profileRepo.getProfile(
    //   "6457b959-7d6b-44d8-afd8-1fbcbcd639aa",
    // );
    final response = await profileRepo.getProfile(event.id);

    if (response.isSuccess) {
      emit(
        state.copyWith(
          status: ProfileStatus.success,
          user: response.data,
          profileErrorMsg: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          profileErrorMsg: 'Failed to fetch profile',
        ),
      );
    }
  }
  
  //update profile
Future<void> _updateProfile(
  UpdateProfile event,
  Emitter<ProfileState> emit,
) async {

  emit(state.copyWith(
    status: ProfileStatus.updating,
    profileErrorMsg: null,
  ));

  final response =
      await profileRepo.editProfile(event.id, event.user);

  if (response.isSuccess) {
    emit(state.copyWith(
      status: ProfileStatus.updated,  
      successMessage: "Profile updated successfully",
    ));
  } else {
    emit(state.copyWith(
      status: ProfileStatus.error,
      profileErrorMsg: response.error?.message,
    ));
  }
}

}
