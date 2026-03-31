import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/response/activity.dart';

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

  const ActivityState({
    this.status = ActivityStatus.initial,
    this.activities = const [],
    this.currentPage = 0,
    this.totalPages = 1,
    this.totalElements = 0,
    this.errorMessage,
    this.isCreating = false,
    this.creationMessage,
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
    creationMessage
  ];
}