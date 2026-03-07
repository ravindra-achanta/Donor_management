// lib/bloc_management/dharmasetu/dharmasetu_bloc.dart (updated with model)

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/network_repos/darmasetu_repository.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_event.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_state.dart';
import 'package:vikas_app/screeens/models/response/Dharmasetu_view.dart';

class DharmasetuBloc extends Bloc<DharmasetuEvent, DharmasetuState> {
   DharmasetuRepository dharmasetuRepository;
  DharmasetuBloc(this.dharmasetuRepository) : super(DharmasetuState()) {
    on<LoadDharmasetu>(_onLoadDharmasetu);
    on<LoadDharmasetuDetails>(_onLoadDharmasetuDetails);
    on<AddDharmasetuEvent>(_onAddDharmasetu);
    on<UpdateDharmasetuEvent>(_onUpdateDharmasetu);
    on<DeleteDharmasetu>(_onDeleteDharmasetu);
    on<CloseDharmasetuProfileView>(_onCloseProfileView);
  }

  /// Fetch paginated dharmasetu list
  Future<void> _onLoadDharmasetu(
    LoadDharmasetu event,
    Emitter<DharmasetuState> emit,
  ) async {
    emit(state.copyWith(status: DharmasetuApiStatus.loading));

    try {
      final result = await dharmasetuRepository.getDharmasetuList(
        page: event.page,
        size: event.size,
      );

      if (!result.isSuccess) {
        emit(
          state.copyWith(
            status: DharmasetuApiStatus.error,
            errorMessage: result.error?.message ?? 'Failed to load dharmasetu',
          ),
        );
        return;
      }

      final response = result.data;

      final List<DharmasetuView> viewList = [];
      if (response != null &&
          response['content'] != null &&
          response['content'] is List) {
        viewList.addAll(
          (response['content'] as List)
              .map(
                (json) => DharmasetuView.fromJson(json as Map<String, dynamic>),
              )
              .toList(),
        );
      }

      emit(
        state.copyWith(
          status: DharmasetuApiStatus.loaded,
          dharmasetuList: viewList,
          currentPage: response?['currentPage'] ?? 0,
          totalPages: response?['totalPages'] ?? 0,
          totalElements: response?['totalElements'] ?? 0,
          isProfileViewVisible: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DharmasetuApiStatus.error,
          errorMessage: 'Failed to load dharmasetu: $e',
        ),
      );
    }
  }

  /// Fetch single dharmasetu details by ID
  Future<void> _onLoadDharmasetuDetails(
    LoadDharmasetuDetails event,
    Emitter<DharmasetuState> emit,
  ) async {
    emit(
      state.copyWith(
        isProfileViewVisible: true,
        profileLoading: true,
        profileErrorMsg: null,
        selectedDharmasetuView: null,
      ),
    );

    try {
      final result = await dharmasetuRepository.getDharmasetuById(event.id);

      if (!result.isSuccess || result.data == null) {
        emit(
          state.copyWith(
            profileLoading: false,
            profileErrorMsg: result.error?.message ?? 'Failed to load details',
          ),
        );
        return;
      }

      final dharmasetuView = result.data!;

      emit(
        state.copyWith(
          profileLoading: false,
          profileErrorMsg: null,
          selectedDharmasetuView: dharmasetuView,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          profileLoading: false,
          profileErrorMsg: 'Failed to load details: $e',
        ),
      );
    }
  }

  Future<void> _onAddDharmasetu(
    AddDharmasetuEvent event,
    Emitter<DharmasetuState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      // Convert Model to JSON for API
      final dharmasetuJson = event.dharmasetu
          .toJson(); // Use the model's toJson method

      print('Sending to API: $dharmasetuJson'); // Debug log

      final result = await dharmasetuRepository.createDharmasetu(
        dharmasetuJson,
      );

      if (!result.isSuccess) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: result.error?.message ?? 'Failed to add dharmasetu',
          ),
        );
        return;
      }

      // Refresh the list after adding
      add(LoadDharmasetu(page: state.currentPage));

      emit(
        state.copyWith(
          isSubmitting: false,
          successMessage: 'Dharmasetu added successfully',
        ),
      );
    } catch (e) {
      print('Error adding dharmasetu: $e'); // Debug log
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to add dharmasetu: $e',
        ),
      );
    }
  }

  /// Update existing dharmasetu
  Future<void> _onUpdateDharmasetu(
    UpdateDharmasetuEvent event,
    Emitter<DharmasetuState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      // Convert Model to JSON for API
      final updateJson = event.dharmasetu.toJson();

      final result = await dharmasetuRepository.updateDharmasetu(
        id: event.dharmasetu.id,
        updateData: updateJson,
      );

      if (!result.isSuccess) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage:
                result.error?.message ?? 'Failed to update dharmasetu',
          ),
        );
        return;
      }

      // Refresh the list after updating
      add(LoadDharmasetu(page: state.currentPage));

      // Refresh details if profile is visible
      if (state.isProfileViewVisible) {
        add(LoadDharmasetuDetails(event.dharmasetu.id));
      }

      emit(
        state.copyWith(
          isSubmitting: false,
          successMessage: 'Dharmasetu updated successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to update dharmasetu: $e',
        ),
      );
    }
  }

  /// Delete dharmasetu
  Future<void> _onDeleteDharmasetu(
    DeleteDharmasetu event,
    Emitter<DharmasetuState> emit,
  ) async {
    emit(state.copyWith(isDeleting: true, errorMessage: null));

    try {
      final result = await dharmasetuRepository.deleteDharmasetu(event.id);

      if (!result.isSuccess) {
        emit(
          state.copyWith(
            isDeleting: false,
            errorMessage:
                result.error?.message ?? 'Failed to delete dharmasetu',
          ),
        );
        return;
      }

      // Refresh the list after deleting
      add(LoadDharmasetu(page: state.currentPage));
      emit(
        state.copyWith(
          isDeleting: false,
          isProfileViewVisible: false,
          successMessage: 'Dharmasetu deleted successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isDeleting: false,
          errorMessage: 'Failed to delete dharmasetu: $e',
        ),
      );
    }
  }

  /// Close profile view
  void _onCloseProfileView(
    CloseDharmasetuProfileView event,
    Emitter<DharmasetuState> emit,
  ) {
    emit(
      state.copyWith(
        isProfileViewVisible: false,
        profileLoading: null,
        profileErrorMsg: null,
        selectedDharmasetuView: null,
      ),
    );
  }
}
