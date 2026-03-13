import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/request/user_metrics_response.dart';
import 'package:vikas_app/screeens/models/response/donationMetrics.dart';

enum DashboardApiStatus { initial, loading, loaded, error }

class DashboardState extends Equatable {
  final DashboardApiStatus status;
  final UserMetricsResponse? metrics;
  final ContributionResponse? donationMetrics;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardApiStatus.initial,
    this.metrics,
    this.errorMessage,
    this.donationMetrics,
  });

  DashboardState copyWith({
    DashboardApiStatus? status,
    UserMetricsResponse? metrics,
    String? errorMessage,
    ContributionResponse? donationMetrics,
  }) {
    return DashboardState(
      status: status ?? this.status,
      metrics: metrics ?? this.metrics,
      errorMessage: errorMessage ?? this.errorMessage,
      donationMetrics: donationMetrics ?? this.donationMetrics,
    );
  }

  @override
  List<Object?> get props => [status, metrics, errorMessage, donationMetrics];
}
