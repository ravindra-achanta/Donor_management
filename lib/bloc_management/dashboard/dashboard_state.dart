import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/request/donations_all_metrics.dart';
import 'package:vikas_app/screeens/models/request/user_metrics_response.dart';
import 'package:vikas_app/screeens/models/response/donationMetrics.dart';
import 'package:vikas_app/screeens/models/response/monthly_donations.dart';

enum DashboardApiStatus { initial, loading, loaded, error }

class DashboardState extends Equatable {
  final DashboardApiStatus status;
  final UserMetricsResponse? metrics;
  final ContributionResponse? donationMetrics;
  final DonationsAllMetrics? donationsMetricsAll;
  final MonthlyDonationsResponse? monthlyDonations;
  final Map<String, dynamic>? activityDashboard;
  final String? errorMessage;
  final DashboardApiStatus monthlyDonationStatus;

  const DashboardState({
    this.status = DashboardApiStatus.initial,
    this.metrics,
    this.errorMessage,
    this.activityDashboard,
    this.donationMetrics,
    this.donationsMetricsAll,
    this.monthlyDonations,
    this.monthlyDonationStatus = DashboardApiStatus.initial,
  });

  DashboardState copyWith({
    DashboardApiStatus? status,
    UserMetricsResponse? metrics,
    String? errorMessage,
    ContributionResponse? donationMetrics,
    DonationsAllMetrics? donationsMetricsAll,
    MonthlyDonationsResponse? monthlyDonations,
    Map<String, dynamic>? activityDashboard,
    DashboardApiStatus? monthlyDonationStatus,
  }) {
    return DashboardState(
      status: status ?? this.status,
      metrics: metrics ?? this.metrics,
      errorMessage: errorMessage ?? this.errorMessage,
      donationMetrics: donationMetrics ?? this.donationMetrics,
      activityDashboard: activityDashboard ?? this.activityDashboard,
      donationsMetricsAll: donationsMetricsAll ?? this.donationsMetricsAll,
      monthlyDonations: monthlyDonations ?? this.monthlyDonations,
      monthlyDonationStatus: monthlyDonationStatus ?? this.monthlyDonationStatus,
    );
  }

  @override
  List<Object?> get props => [status, metrics, errorMessage, donationMetrics, activityDashboard, donationsMetricsAll, monthlyDonations, monthlyDonationStatus];
}
