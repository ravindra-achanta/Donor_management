import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/network_repos/office_staff_repo.dart';
import 'package:vikas_app/bloc_management/Officestaff/office_staff_event.dart';
import 'package:vikas_app/bloc_management/Officestaff/office_staff_state.dart';

class OfficeStaffBloc extends Bloc<OfficeStaffEvent, OfficeStaffState> {
  final OfficeStaffRepo repo;

  OfficeStaffBloc(this.repo) : super(const OfficeStaffState()) {
    on<FetchOfficeStaffEvent>(_onFetchOfficeStaff);
    on<FetchOfficeStaffProfileEvent>(_onFetchOfficeStaffProfile);
on<CloseOfficeStaffProfile>(_closeProfileView);
  }

  Future<void> _onFetchOfficeStaff(
    FetchOfficeStaffEvent event,
    Emitter<OfficeStaffState> emit,
  ) async {
    emit(state.copyWith(status: OfficeStaffApiStatus.loading));

    final response = await repo.getOfficeStaff(
      event.page,
      10,
      event.searchQuery,
    );

    if (response.isSuccess) {
      emit(
        state.copyWith(
          status: OfficeStaffApiStatus.loaded,
          officeStaff: response.data?.content ?? [],
          totalElements: response.data?.totalElements ?? 0,
          totalPages: response.data?.totalPages ?? 0,
          currentPage: response.data?.currentPage ?? 0,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: OfficeStaffApiStatus.error,
          errorMessage: response.error?.message,
        ),
      );
    }
  }
  Future<void> _onFetchOfficeStaffProfile(
  FetchOfficeStaffProfileEvent event,
  Emitter<OfficeStaffState> emit,
) async {
  emit(
    state.copyWith(
      isProfileViewVisible: true,
      profileLoading: true,
      profileErrorMsg: null,
    ),
  );

  final response = await repo.getOfficeStaffProfile(event.userId);

  if (response.isSuccess) {
    emit(
      state.copyWith(
        profileLoading: false,
        officeStaffProfile: response.data,
      ),
    );
  } else {
    emit(
      state.copyWith(
        profileLoading: false,
        profileErrorMsg: "Failed to fetch profile",
      ),
    );
  }
}
Future<void> _closeProfileView(
  CloseOfficeStaffProfile event,
  Emitter<OfficeStaffState> emit,
) async {
  emit(state.copyWith(isProfileViewVisible: false));
}
}