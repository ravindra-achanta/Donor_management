import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/response/activity.dart';
import 'package:vikas_app/screeens/models/response/activity_dashboard_metrics.dart';

enum ActivityStatus { initial, loading, loaded, error, creating, created }

class ActivityState extends Equatable {
  final ActivityStatus status;
  final List<Activity> activities;
  final int currentPage;
  final int totalPages;
  final int totalElements;
  final String? errorMessage;
  final bool isCreating;
  final String? creationMessage;
    final List<ActivityDashboardMetrics> dashboardMetrics;
    final bool isDashboardLoading;

  const ActivityState({
    this.status = ActivityStatus.initial,
    this.activities = const [],
    this.currentPage = 0,
    this.totalPages = 1,
    this.totalElements = 0,
    this.errorMessage,
    this.isCreating = false,
    this.creationMessage,
     this.dashboardMetrics = const [], 
    this.isDashboardLoading = false,
  });

  ActivityState copyWith({
    ActivityStatus? status,
    List<Activity>? activities,
    int? currentPage,
    int? totalPages,
    int? totalElements,
    String? errorMessage,
    bool? isCreating,
    String? creationMessage,
     List<ActivityDashboardMetrics>? dashboardMetrics, 
    bool? isDashboardLoading,
  }) {
    return ActivityState(
      status: status ?? this.status,
      activities: activities ?? this.activities,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalElements: totalElements ?? this.totalElements,
      errorMessage: errorMessage ?? this.errorMessage,
      isCreating: isCreating ?? this.isCreating,
      creationMessage: creationMessage ?? this.creationMessage,
      dashboardMetrics: dashboardMetrics ?? this.dashboardMetrics, 
      isDashboardLoading: isDashboardLoading ?? this.isDashboardLoading, 
    );
  }

  @override
  List<Object?> get props => [
    status,
    activities,
    currentPage,
    totalPages,
    totalElements,
    errorMessage,
    isCreating,
    creationMessage,
    dashboardMetrics,
    isDashboardLoading,
  ];
    
}
