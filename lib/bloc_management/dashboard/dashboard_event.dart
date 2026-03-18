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
