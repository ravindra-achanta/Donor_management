import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/request/VisitMetrics.dart';
import 'package:vikas_app/screeens/models/request/visit_model.dart';
import 'package:vikas_app/screeens/models/response/visit_view.dart';

enum VisitApiStatus { initial, loading, loaded, error }

class VisitState extends Equatable {
  final VisitApiStatus status;
  final List<VisitView> visitList;
  final int currentPage;
  final int totalPages;
  final int totalElements;
  final String? errorMessage;
  final String? successMessage;
  final List<VisitMetrics> metrics;
  final bool metricsLoading;
  final bool showMonthlyChart;
  final int? selectedMonthIndex;

  // Profile view states
  final bool isProfileViewVisible;
  final bool? profileLoading;
  final String? profileErrorMsg;
  final VisitModel? selectedVisit;

  // Operation states
  final bool isSubmitting;
  final bool isDeleting;

  const VisitState({
    this.status = VisitApiStatus.initial,
    this.visitList = const [],
    this.currentPage = 0,
    this.totalPages = 1,
    this.totalElements = 0,
    this.errorMessage,
    this.successMessage,
    this.isProfileViewVisible = false,
    this.profileLoading,
    this.profileErrorMsg,
    this.selectedVisit,
    this.isSubmitting = false,
    this.isDeleting = false,
    this.metrics = const [],
    this.metricsLoading = false,
    this.showMonthlyChart = true,
    this.selectedMonthIndex,
  });

  VisitState copyWith({
    VisitApiStatus? status,
    List<VisitView>? visitList,
    int? currentPage,
    int? totalPages,
    int? totalElements,
    String? errorMessage,
    String? successMessage,
    bool? isProfileViewVisible,
    bool? profileLoading,
    String? profileErrorMsg,
    VisitModel? selectedVisit,
    bool? isSubmitting,
    bool? isDeleting,
    List<VisitMetrics>? metrics,
    bool? metricsLoading,
    bool? showMonthlyChart,
    int? selectedMonthIndex,
  }) {
    return VisitState(
      status: status ?? this.status,
      visitList: visitList ?? this.visitList,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalElements: totalElements ?? this.totalElements,
      errorMessage: errorMessage,
      successMessage: successMessage,
      isProfileViewVisible: isProfileViewVisible ?? this.isProfileViewVisible,
      profileLoading: profileLoading ?? this.profileLoading,
      profileErrorMsg: profileErrorMsg ?? this.profileErrorMsg,
      selectedVisit: selectedVisit ?? this.selectedVisit,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isDeleting: isDeleting ?? this.isDeleting,
      metrics: metrics ?? this.metrics,
      showMonthlyChart: showMonthlyChart ?? this.showMonthlyChart,
      metricsLoading: metricsLoading ?? this.metricsLoading,
      selectedMonthIndex: selectedMonthIndex ?? this.selectedMonthIndex,
    );
  }

  @override
  List<Object?> get props => [
    status,
    visitList,
    currentPage,
    totalPages,
    totalElements,
    errorMessage,
    successMessage,
    isProfileViewVisible,
    profileLoading,
    profileErrorMsg,
    selectedVisit,
    isSubmitting,
    isDeleting,
    metrics,
    metricsLoading,
    showMonthlyChart,
    selectedMonthIndex,
  ];
}
