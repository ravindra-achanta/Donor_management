import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/network_repos/department_repo.dart';
import 'package:vikas_app/screeens/models/response/DepartmentResponse.dart';
import 'department_event.dart';
import 'department_state.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final DepartmentRepo departmentRepo;

  DepartmentBloc(this.departmentRepo) : super(const DepartmentState()) {
    on<FetchDepartmentsEvent>(_onFetchDepartments);
    on<CreateDepartmentEvent>(_onCreateDepartment);
    on<UpdateDepartmentEvent>(_onUpdateDepartment);
    on<DeleteDepartmentEvent>(_onDeleteDepartment);
  }

  Future<void> _onFetchDepartments(
    FetchDepartmentsEvent event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(state.copyWith(status: DepartmentStatus.loading));
    
    final result = await departmentRepo.getAllDepartments();
    
    if (result.isSuccess) {
      emit(state.copyWith(
        status: DepartmentStatus.success,
        departments: result.data ?? [],
        errorMsg: null,
      ));
    } else {
      emit(state.copyWith(
        status: DepartmentStatus.error,
        errorMsg: result.error?.message ?? 'Failed to fetch departments',
      ));
    }
  }

  Future<void> _onCreateDepartment(
    CreateDepartmentEvent event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(state.copyWith(isCreating: true));
    
    final result = await departmentRepo.createDepartment(event.request);
    
    if (result.isSuccess && result.data != null) {
      final updatedDepartments = [...state.departments, result.data!];
      emit(state.copyWith(
        isCreating: false,
        departments: updatedDepartments,
        successMsg: 'Department created successfully',
      ));
    } else {
      emit(state.copyWith(
        isCreating: false,
        errorMsg: result.error?.message ?? 'Failed to create department',
      ));
    }
  }

  Future<void> _onUpdateDepartment(
    UpdateDepartmentEvent event, Emitter<DepartmentState> emit) async {
  emit(state.copyWith(isUpdating: true));

  final result = await departmentRepo.updateDepartment(
    event.id,  // 
    event.request,
  );

  if (result.isSuccess) {
    // Update the department in the list
    final updatedDepts = state.departments.map((dept) {
      return dept.id == event.id
          ? DepartmentResponse(
              id: dept.id,
              departmentName: event.request.departmentName,
              description: event.request.description,
              status: dept.status,
            )
          : dept;
    }).toList();

    emit(
      state.copyWith(
        status: DepartmentStatus.success,
        departments: updatedDepts,
        successMsg: 'Department updated successfully',
        isUpdating: false,
      ),
    );
  } else {
    emit(
      state.copyWith(
        status: DepartmentStatus.error,
        errorMsg: result.error?.message ?? 'Failed to update department',
        isUpdating: false,
      ),
    );
  }
}

Future<void> _onDeleteDepartment(
    DeleteDepartmentEvent event, Emitter<DepartmentState> emit) async {
  emit(state.copyWith(isDeleting: true));

  final result = await departmentRepo.deleteDepartment(event.id);

  if (result.isSuccess) {
    // Remove from list
    final updatedDepts = state.departments
        .where((dept) => dept.id != event.id)
        .toList();

    emit(
      state.copyWith(
        status: DepartmentStatus.success,
        departments: updatedDepts,
        successMsg: 'Department deleted successfully',
        isDeleting: false,
      ),
    );
  } else {
    emit(
      state.copyWith(
        status: DepartmentStatus.error,
        errorMsg: result.error?.message ?? 'Failed to delete department',
        isDeleting: false,
      ),
    );
  }
}}