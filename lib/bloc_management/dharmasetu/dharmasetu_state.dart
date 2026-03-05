// lib/blocs/dharmasetu/dharmasetu_state.dart

import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/request/dharmasetu_model.dart';

abstract class DharmasetuState extends Equatable {
  const DharmasetuState();

  @override
  List<Object?> get props => [];
}

class DharmasetuInitial extends DharmasetuState {}

class DharmasetuLoading extends DharmasetuState {}

class DharmasetuLoaded extends DharmasetuState {
  final List<DharmasetuModel> dharmasetuList;
  final int currentPage;
  final int totalPages;
  const DharmasetuLoaded({
    required this.dharmasetuList,
    required this.currentPage,
    required this.totalPages,
  });
  @override
  List<Object?> get props => [dharmasetuList, currentPage, totalPages];
}

class DharmasetuOperationSuccess extends DharmasetuState {
  final String message;
  const DharmasetuOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class DharmasetuError extends DharmasetuState {
  final String message;
  const DharmasetuError(this.message);
  @override
  List<Object?> get props => [message];
}