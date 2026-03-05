import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/network_repos/visits_repo.dart';
import 'package:vikas_app/bloc_management/visits/visit_event.dart';
import 'package:vikas_app/bloc_management/visits/visit_state.dart';
import 'package:vikas_app/screeens/models/request/visit_model.dart';
import 'package:vikas_app/screeens/models/response/visit_view.dart';

class VisitBloc extends Bloc<VisitEvent, VisitState> {
  final VisitRepository visitRepository;

  VisitBloc({required this.visitRepository}) : super(VisitState()) {
    on<LoadVisits>(_onLoadVisits);
    on<LoadVisitDetails>(_onLoadVisitDetails);
    on<AddVisit>(_onAddVisit);
    on<UpdateVisit>(_onUpdateVisit);
    on<DeleteVisit>(_onDeleteVisit);
    on<CloseVisitProfileView>(_onCloseProfileView);
  }

  /// Fetch paginated visits list
  Future<void> _onLoadVisits(
    LoadVisits event,
    Emitter<VisitState> emit,
  ) async {
    emit(state.copyWith(status: VisitApiStatus.loading));
    
    try {
      final result = await visitRepository.getVisits(
        page: event.page,
        size: event.size,
      );

      if (!result.isSuccess) {
        emit(state.copyWith(
          status: VisitApiStatus.error,
          errorMessage: result.error?.message ?? 'Failed to load visits',
        ));
        return;
      }

      final response = result.data;
      
      final List<VisitView> viewList = [];
      if (response != null && response['content'] != null && response['content'] is List) {
        viewList.addAll(
          (response['content'] as List)
              .map((json) => VisitView.fromJson(json as Map<String, dynamic>))
              .toList()
        );
      }

      emit(state.copyWith(
        status: VisitApiStatus.loaded,
        visitList: viewList,
        currentPage: response?['currentPage'] ?? 0,
        totalPages: response?['totalPages'] ?? 0,
        totalElements: response?['totalElements'] ?? 0,
        isProfileViewVisible: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VisitApiStatus.error,
        errorMessage: 'Failed to load visits: $e',
      ));
    }
  }

  /// Fetch single visit details by ID
  Future<void> _onLoadVisitDetails(
    LoadVisitDetails event,
    Emitter<VisitState> emit,
  ) async {
    emit(state.copyWith(
      isProfileViewVisible: true,
      profileLoading: true,
      profileErrorMsg: null,
      selectedVisit: null,
    ));

    try {
      final result = await visitRepository.getVisitDetails(event.id);

      if (!result.isSuccess || result.data == null) {
        emit(state.copyWith(
          profileLoading: false,
          profileErrorMsg: result.error?.message ?? 'Failed to load details',
        ));
        return;
      }

      final visitView = result.data!;
      
      final visitModel = VisitModel(
        id: visitView.id,
        visitorName: visitView.visitorName,
        phoneNumber: visitView.phoneNumber,
        email: visitView.email,
        visitPurpose: visitView.visitPurpose,
        comments: visitView.comments,
        noOfGuests: visitView.noOfGuests,
        existVisitor: visitView.existVisitor,
      );

      emit(state.copyWith(
        profileLoading: false,
        profileErrorMsg: null,
        selectedVisit: visitModel,
      ));
    } catch (e) {
      emit(state.copyWith(
        profileLoading: false,
        profileErrorMsg: 'Failed to load details: $e',
      ));
    }
  }

  /// Add new visit
  Future<void> _onAddVisit(
    AddVisit event,
    Emitter<VisitState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    
    try {
      final visitJson = {
        'visitorName': event.visit.visitorName,
        'phoneNumber': event.visit.phoneNumber,
        'email': event.visit.email,
        'visitPurpose': event.visit.visitPurpose,
        'comments': event.visit.comments,
        'noOfGuests': event.visit.noOfGuests,
        'existVisitor': event.visit.existVisitor,
      };

      final result = await visitRepository.createVisit(visitJson);

      if (!result.isSuccess) {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: result.error?.message ?? 'Failed to add visit',
        ));
        return;
      }

      // Refresh the list after adding
      add(LoadVisits(page: state.currentPage));
      emit(state.copyWith(
        isSubmitting: false,
        successMessage: 'Visit added successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to add visit: $e',
      ));
    }
  }

  /// Update existing visit
  Future<void> _onUpdateVisit(
    UpdateVisit event,
    Emitter<VisitState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    
    try {
      final updateJson = {
        'visitorName': event.visit.visitorName,
        'phoneNumber': event.visit.phoneNumber,
        'email': event.visit.email,
        'visitPurpose': event.visit.visitPurpose,
        'comments': event.visit.comments,
        'noOfGuests': event.visit.noOfGuests,
        'existVisitor': event.visit.existVisitor,
      };

      final result = await visitRepository.updateVisit(
        id: event.visit.id,
        updateData: updateJson,
      );

      if (!result.isSuccess) {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: result.error?.message ?? 'Failed to update visit',
        ));
        return;
      }

      // Refresh the list after updating
      add(LoadVisits(page: state.currentPage));
      
      // Refresh details if profile is visible
      if (state.isProfileViewVisible) {
        add(LoadVisitDetails(event.visit.id));
      }
      
      emit(state.copyWith(
        isSubmitting: false,
        successMessage: 'Visit updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to update visit: $e',
      ));
    }
  }

  /// Delete visit
  Future<void> _onDeleteVisit(
    DeleteVisit event,
    Emitter<VisitState> emit,
  ) async {
    emit(state.copyWith(isDeleting: true, errorMessage: null));
    
    try {
      final result = await visitRepository.deleteVisit(event.id);

      if (!result.isSuccess) {
        emit(state.copyWith(
          isDeleting: false,
          errorMessage: result.error?.message ?? 'Failed to delete visit',
        ));
        return;
      }

      // Refresh the list after deleting
      add(LoadVisits(page: state.currentPage));
      emit(state.copyWith(
        isDeleting: false,
        isProfileViewVisible: false,
        successMessage: 'Visit deleted successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        isDeleting: false,
        errorMessage: 'Failed to delete visit: $e',
      ));
    }
  }

  /// Close profile view
  void _onCloseProfileView(
    CloseVisitProfileView event,
    Emitter<VisitState> emit,
  ) {
    emit(state.copyWith(
      isProfileViewVisible: false,
      profileLoading: null,
      profileErrorMsg: null,
      selectedVisit: null,
    ));
  }
}