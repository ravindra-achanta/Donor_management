// lib/bloc_management/dharmasetu/dharmasetu_state.dart

import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/request/dharmasetu_model.dart';
import 'package:vikas_app/screeens/models/response/Dharmasetu_view.dart';

enum DharmasetuApiStatus { initial, loading, loaded, error }

class DharmasetuState extends Equatable {
  // List state
  final DharmasetuApiStatus status;
  final List<DharmasetuView> dharmasetuList;
  final int currentPage;
  final int totalPages;
  final int totalElements;
  
  final bool isProfileViewVisible;
  final bool? profileLoading;
  final String? profileErrorMsg;
  final DharmasetuView? selectedDharmasetuView; 
  
  final DharmasetuModel? dharmasetuFormData; 
  final bool isSubmitting;
  final bool isDeleting;
  
  final String? errorMessage;
  final String? successMessage;

  const DharmasetuState({
    this.status = DharmasetuApiStatus.initial,
    this.dharmasetuList = const [],
    this.currentPage = 0,
    this.totalPages = 1,
    this.totalElements = 0,
    this.isProfileViewVisible = false,
    this.profileLoading,
    this.profileErrorMsg,
    this.selectedDharmasetuView,
    this.dharmasetuFormData,
    this.isSubmitting = false,
    this.isDeleting = false,
    this.errorMessage,
    this.successMessage,
  });

  DharmasetuState copyWith({
    DharmasetuApiStatus? status,
    List<DharmasetuView>? dharmasetuList,
    int? currentPage,
    int? totalPages,
    int? totalElements,
    bool? isProfileViewVisible,
    bool? profileLoading,
    String? profileErrorMsg,
    DharmasetuView? selectedDharmasetuView,
    DharmasetuModel? dharmasetuFormData,
    bool? isSubmitting,
    bool? isDeleting,
    String? errorMessage,
    String? successMessage,
  }) {
    return DharmasetuState(
      status: status ?? this.status,
      dharmasetuList: dharmasetuList ?? this.dharmasetuList,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalElements: totalElements ?? this.totalElements,
      isProfileViewVisible: isProfileViewVisible ?? this.isProfileViewVisible,
      profileLoading: profileLoading ?? this.profileLoading,
      profileErrorMsg: profileErrorMsg ?? this.profileErrorMsg,
      selectedDharmasetuView: selectedDharmasetuView ?? this.selectedDharmasetuView,
      dharmasetuFormData: dharmasetuFormData ?? this.dharmasetuFormData,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  // Helper getters
  bool get isLoading => status == DharmasetuApiStatus.loading;
  bool get isLoaded => status == DharmasetuApiStatus.loaded;
  bool get hasError => errorMessage != null;
  bool get hasSuccess => successMessage != null;
  bool get isProfileVisible => isProfileViewVisible;
  bool get isProfileLoadingState => profileLoading == true;

  @override
  List<Object?> get props => [
    status,
    dharmasetuList,
    currentPage,
    totalPages,
    totalElements,
    isProfileViewVisible,
    profileLoading,
    profileErrorMsg,
    selectedDharmasetuView,
    dharmasetuFormData,
    isSubmitting,
    isDeleting,
    errorMessage,
    successMessage,
  ];
}

  
  