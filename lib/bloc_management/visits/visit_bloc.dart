// lib/bloc_management/visits/visit_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:vikas_app/screeens/models/request/visit_model.dart';
import 'package:vikas_app/screeens/models/response/visit_view.dart';
import 'visit_event.dart';
import 'visit_state.dart';

class VisitBloc extends Bloc<VisitEvent, VisitState> {
  List<VisitModel> _allVisits = [];
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  VisitBloc() : super(VisitInitial()) {
    on<LoadVisits>(_onLoadVisits);
    on<LoadVisitDetails>(_onLoadVisitDetails);
    on<AddVisit>(_onAddVisit);
    on<UpdateVisit>(_onUpdateVisit);
    on<DeleteVisit>(_onDeleteVisit);
    on<CloseVisitProfileView>(_onCloseProfileView);
  }

  Future<void> _onLoadVisits(
    LoadVisits event,
    Emitter<VisitState> emit,
  ) async {
    emit(VisitLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _allVisits = _getSampleData();
      _currentPage = event.page;
      
      final viewList = _allVisits
          .map((model) => VisitView.fromVisitModel(model))
          .toList();

      emit(VisitLoaded(
        visitList: viewList,
        currentPage: _currentPage,
        totalPages: (_allVisits.length / _itemsPerPage).ceil(),
        isProfileViewVisible: false,
      ));
    } catch (e) {
      emit(VisitError('Failed to load: $e'));
    }
  }

  Future<void> _onLoadVisitDetails(
    LoadVisitDetails event,
    Emitter<VisitState> emit,
  ) async {
    final currentState = state;
    if (currentState is VisitLoaded) {
      emit(VisitLoaded(
        visitList: currentState.visitList,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        isProfileViewVisible: true,
        profileLoading: true,
      ));

      try {
        await Future.delayed(const Duration(milliseconds: 500));
        final selected = _allVisits.firstWhere((d) => d.id == event.id);
        
        emit(VisitLoaded(
          visitList: currentState.visitList,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          isProfileViewVisible: true,
          profileLoading: false,
          selectedVisit: selected,
        ));
      } catch (e) {
        emit(VisitLoaded(
          visitList: currentState.visitList,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          isProfileViewVisible: true,
          profileLoading: false,
          profileErrorMsg: 'Failed to load details: $e',
        ));
      }
    }
  }

  Future<void> _onAddVisit(
    AddVisit event,
    Emitter<VisitState> emit,
  ) async {
    try {
      _allVisits.add(event.visit);
      final viewList = _allVisits
          .map((model) => VisitView.fromVisitModel(model))
          .toList();
          
      emit(VisitLoaded(
        visitList: viewList,
        currentPage: _currentPage,
        totalPages: (_allVisits.length / _itemsPerPage).ceil(),
      ));
      emit(VisitOperationSuccess('Added successfully'));
    } catch (e) {
      emit(VisitError('Failed to add: $e'));
    }
  }

  Future<void> _onUpdateVisit(
    UpdateVisit event,
    Emitter<VisitState> emit,
  ) async {
    try {
      final index = _allVisits.indexWhere((d) => d.id == event.visit.id);
      if (index != -1) {
        _allVisits[index] = event.visit;
      }
      
      final viewList = _allVisits
          .map((model) => VisitView.fromVisitModel(model))
          .toList();
          
      emit(VisitLoaded(
        visitList: viewList,
        currentPage: _currentPage,
        totalPages: (_allVisits.length / _itemsPerPage).ceil(),
        isProfileViewVisible: false,
      ));
      emit(VisitOperationSuccess('Updated successfully'));
    } catch (e) {
      emit(VisitError('Failed to update: $e'));
    }
  }

  Future<void> _onDeleteVisit(
    DeleteVisit event,
    Emitter<VisitState> emit,
  ) async {
    try {
      _allVisits.removeWhere((d) => d.id == event.id);
      
      final viewList = _allVisits
          .map((model) => VisitView.fromVisitModel(model))
          .toList();
          
      emit(VisitLoaded(
        visitList: viewList,
        currentPage: _currentPage,
        totalPages: (_allVisits.length / _itemsPerPage).ceil(),
        isProfileViewVisible: false,
      ));
      emit(const VisitOperationSuccess('Deleted successfully'));
    } catch (e) {
      emit(VisitError('Failed to delete: $e'));
    }
  }

  void _onCloseProfileView(
    CloseVisitProfileView event,
    Emitter<VisitState> emit,
  ) {
    final currentState = state;
    if (currentState is VisitLoaded) {
      emit(VisitLoaded(
        visitList: currentState.visitList,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        isProfileViewVisible: false,
      ));
    }
  }

  List<VisitModel> _getSampleData() {
    return [
      VisitModel(
        id: '1',
        jeevandNum: 'JN001',
        name: 'Rajesh Kumar',
        phone: '9876543210',
        email: 'rajesh@example.com',
        visitPurpose: 'General Visit',
        noOfGuests: 2,
        comments: 'First time visitor',
        date: '2024-01-15',
        status: 'Completed',
      ),
      VisitModel(
        id: '2',
        jeevandNum: 'JN002',
        name: 'Priya Singh',
        phone: '9876543211',
        email: 'priya@example.com',
        visitPurpose: 'Donation',
        noOfGuests: 1,
        comments: 'Wants to donate',
        date: '2024-01-20',
        status: 'Pending',
      ),
      VisitModel(
        id: '3',
        jeevandNum: 'JN003',
        name: 'Amit Patel',
        phone: '9876543212',
        email: 'amit@example.com',
        visitPurpose: 'Volunteering',
        noOfGuests: 3,
        comments: 'Interested in volunteering',
        date: '2024-01-25',
        status: 'Scheduled',
      ),
      
    ];
  }
}