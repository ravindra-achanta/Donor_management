import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/response/DepartmentResponse.dart';

enum DepartmentStatus { initial, loading, success, error }

class DepartmentState extends Equatable {
  final DepartmentStatus status;
  final List<DepartmentResponse> departments;
  final String? errorMsg;
  final String? successMsg;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;
  


  const DepartmentState({
    this.status = DepartmentStatus.initial,
    this.departments = const [],
    this.errorMsg,
    this.successMsg,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
  });

  DepartmentState copyWith({
    DepartmentStatus? status,
    List<DepartmentResponse>? departments,
    String? errorMsg,
    String? successMsg,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
  }) {
    return DepartmentState(
      status: status ?? this.status,
      departments: departments ?? this.departments,
      errorMsg: errorMsg,
      successMsg: successMsg,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  @override
  List<Object?> get props => [
    status,
    departments,
    errorMsg,
    successMsg,
    isCreating,
    isUpdating,
    isDeleting,
  ];
}