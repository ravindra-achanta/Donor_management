import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/request/activity_request.dart%20%20%E2%9C%85%20Cractivity_request.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

class FetchActivitiesEvent extends ActivityEvent {
  final int page;
  final int pageSize;
 // final String? search;

  const FetchActivitiesEvent({
    this.page = 0,
    this.pageSize = 10,
   // this.search,
  });

  @override
  List<Object?> get props => [page, pageSize];
}

class CreateActivityEvent extends ActivityEvent {
  final ActivityRequest request;

  const CreateActivityEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

class FetchUserActivityDashboardEvent extends ActivityEvent {
   final String id;
  const FetchUserActivityDashboardEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
class LoadActivityMetricsEvent extends ActivityEvent {
  const LoadActivityMetricsEvent();
  @override
  List<Object?> get props => [];
}