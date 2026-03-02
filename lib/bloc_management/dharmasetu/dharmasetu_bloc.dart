// lib/blocs/dharmasetu/dharmasetu_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:vikas_app/screeens/models/request/dharmasetu_model.dart';
import 'dharmasetu_event.dart';
import 'dharmasetu_state.dart';

class DharmasetuBloc extends Bloc<DharmasetuEvent, DharmasetuState> {
  List<DharmasetuModel> _allDharmasetu = [];

  DharmasetuBloc() : super(DharmasetuInitial()) {
    on<LoadDharmasetu>(_onLoadDharmasetu);
    on<AddDharmasetu>(_onAddDharmasetu);
    on<UpdateDharmasetu>(_onUpdateDharmasetu);
    on<DeleteDharmasetu>(_onDeleteDharmasetu);
  }

  Future<void> _onLoadDharmasetu(
    LoadDharmasetu event,
    Emitter<DharmasetuState> emit,
  ) async {
    emit(DharmasetuLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      _allDharmasetu = _getSampleData();
      emit(DharmasetuLoaded(dharmasetuList: _allDharmasetu));
    } catch (e) {
      emit(DharmasetuError('Failed to load: $e'));
    }
  }

  Future<void> _onAddDharmasetu(
    AddDharmasetu event,
    Emitter<DharmasetuState> emit,
  ) async {
    try {
      _allDharmasetu.add(event.dharmasetu);
      emit(DharmasetuLoaded(dharmasetuList: _allDharmasetu));
      emit(DharmasetuOperationSuccess('Added successfully'));
    } catch (e) {
      emit(DharmasetuError('Failed to add: $e'));
    }
  }

  Future<void> _onUpdateDharmasetu(
    UpdateDharmasetu event,
    Emitter<DharmasetuState> emit,
  ) async {
    try {
      final index = _allDharmasetu.indexWhere((d) => d.id == event.dharmasetu.id);
      if (index != -1) {
        _allDharmasetu[index] = event.dharmasetu;
      }
      emit(DharmasetuLoaded(dharmasetuList: _allDharmasetu));
      emit(DharmasetuOperationSuccess('Updated successfully'));
    } catch (e) {
      emit(DharmasetuError('Failed to update: $e'));
    }
  }

  Future<void> _onDeleteDharmasetu(
    DeleteDharmasetu event,
    Emitter<DharmasetuState> emit,
  ) async {
    try {
      _allDharmasetu.removeWhere((d) => d.id == event.id);
      emit(DharmasetuLoaded(dharmasetuList: _allDharmasetu));
      emit(const DharmasetuOperationSuccess('Deleted successfully'));
    } catch (e) {
      emit(DharmasetuError('Failed to delete: $e'));
    }
  }

  List<DharmasetuModel> _getSampleData() {
    return [
      DharmasetuModel(
        id: '1',
        uid: 'DM001',
        type: 'Community',
        name: 'Community Outreach Program',
        feedback: 'Excellent community engagement',
        date: '2024-01-15',
        referredBy: 'Rajesh Kumar',
        status: 'Active',
      ),
      DharmasetuModel(
        id: '2',
        uid: 'DM002',
        type: 'Home',
        name: 'Home Assistance Program',
        feedback: 'Good response from members',
        date: '2024-01-20',
        referredBy: 'Priya Singh',
        status: 'Active',
      ),
      DharmasetuModel(
        id: '3',
        uid: 'DM003',
        type: 'Virtual',
        name: 'Online Spiritual Sessions',
        feedback: 'High attendance rate',
        date: '2024-01-25',
        referredBy: 'Amit Patel',
        status: 'Pending',
      ),
     
    ];
  }
}