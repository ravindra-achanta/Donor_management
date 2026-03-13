import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/request/user_metrics_response.dart';

enum DashboardApiStatus { initial, loading, loaded, error }

class DashboardState extends Equatable {

  final DashboardApiStatus status;
  final UserMetricsResponse? metrics;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardApiStatus.initial,
    this.metrics,
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardApiStatus? status,
    UserMetricsResponse? metrics,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      metrics: metrics ?? this.metrics,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, metrics, errorMessage];
}