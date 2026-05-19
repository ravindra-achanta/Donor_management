import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDashboardMetricsEvent extends DashboardEvent {}

class FetchDonationMetricsEvent extends DashboardEvent {
  final int id;

  FetchDonationMetricsEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
class PostDashboardActivityEvent extends DashboardEvent {}

class FetchDonationsMetricsAllEvent extends DashboardEvent {}

class FetchMonthlyDonationsEvent extends DashboardEvent {
  final int year;

  FetchMonthlyDonationsEvent({required this.year});

  @override
  List<Object?> get props => [year];
}
