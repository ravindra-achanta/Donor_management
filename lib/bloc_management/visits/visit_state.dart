// lib/bloc_management/visits/visit_state.dart

import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/request/visit_model.dart';
import 'package:vikas_app/screeens/models/response/visit_view.dart';

abstract class VisitState extends Equatable {
  const VisitState();

  @override
  List<Object?> get props => [];
}

class VisitInitial extends VisitState {}

class VisitLoading extends VisitState {}

class VisitLoaded extends VisitState {
  final List<VisitView> visitList;
  final int currentPage;
  final int totalPages;
  final bool isProfileViewVisible;
  final bool? profileLoading;
  final String? profileErrorMsg;
  final VisitModel? selectedVisit;

  const VisitLoaded({
    required this.visitList,
    this.currentPage = 0,
    this.totalPages = 1,
    this.isProfileViewVisible = false,
    this.profileLoading,
    this.profileErrorMsg,
    this.selectedVisit,
  });

  @override
  List<Object?> get props => [
        visitList,
        currentPage,
        totalPages,
        isProfileViewVisible,
        profileLoading,
        profileErrorMsg,
        selectedVisit,
      ];
}

class VisitOperationSuccess extends VisitState {
  final String message;
  const VisitOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class VisitError extends VisitState {
  final String message;
  const VisitError(this.message);
  @override
  List<Object?> get props => [message];
}