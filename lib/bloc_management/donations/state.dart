import 'package:equatable/equatable.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/screeens/models/request/donations_all_metrics.dart';

enum DonationStatus {
  initial,
  loading,
  success,
  error,
}

class DonationState extends Equatable {
  final DonationStatus status;
  final DonationsAllMetrics? metricsAll;
  final ApiError? error;
  final String? errorMessage;

  const DonationState({
    this.status = DonationStatus.initial,
    this.metricsAll,
    this.error,
    this.errorMessage,
  });

  DonationState copyWith({
    DonationStatus? status,
    DonationsAllMetrics? metricsAll,
    ApiError? error,
    String? errorMessage,
  }) {
    return DonationState(
      status: status ?? this.status,
      metricsAll: metricsAll ?? this.metricsAll,
      error: error ?? this.error,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, metricsAll, error, errorMessage];
}