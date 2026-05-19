import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/request/DepartmentRequest.dart';

abstract class DepartmentEvent extends Equatable {
  const DepartmentEvent();

  @override
  List<Object?> get props => [];
}

class FetchDepartmentsEvent extends DepartmentEvent {
  const FetchDepartmentsEvent();
}

class CreateDepartmentEvent extends DepartmentEvent {
  final DepartmentRequest request;

  const CreateDepartmentEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateDepartmentEvent extends DepartmentEvent {
  final String id;
  final DepartmentRequest request;

  const UpdateDepartmentEvent(this.id, this.request);

  @override
  List<Object?> get props => [id, request];
}

class DeleteDepartmentEvent extends DepartmentEvent {
  final String id;

  const DeleteDepartmentEvent(this.id);

  @override
  List<Object?> get props => [id];
}