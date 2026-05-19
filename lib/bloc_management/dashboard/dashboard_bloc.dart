import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/network_repos/dashboard_repository.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final dashboardRepo = DashboardRepo();

  DashboardBloc() : super(const DashboardState()) {
    on<FetchDashboardMetricsEvent>(_fetchMetrics);
    on<FetchDonationMetricsEvent>(_fetchDonationMetrics);
    on<PostDashboardActivityEvent>(_postDashboardActivity);
    on<FetchDonationsMetricsAllEvent>(_fetchDonationsMetricsAll);
    on<FetchMonthlyDonationsEvent>(_fetchMonthlyDonations);
  }

  Future<void> _fetchDonationMetrics(
    FetchDonationMetricsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardApiStatus.loading));

    final response = await dashboardRepo.getDonationMetrics(event.id);

    if (response.isSuccess) {
      emit(
        state.copyWith(
          status: DashboardApiStatus.loaded,
          donationMetrics: response.data,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: DashboardApiStatus.error,
          errorMessage:
              response.error?.message ?? "Failed to load donation metrics",
        ),
      );
    }
  }

  Future<void> _fetchMetrics(
    FetchDashboardMetricsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardApiStatus.loading));

    final response = await dashboardRepo.getDashboardMetrics();

    if (response.isSuccess) {
      emit(
        state.copyWith(
          status: DashboardApiStatus.loaded,
          metrics: response.data,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: DashboardApiStatus.error,
          errorMessage: response.error?.message ?? "Failed to load dashboard",
        ),
      );
    }
  }

  Future<void> _postDashboardActivity(
    PostDashboardActivityEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardApiStatus.loading));

    final response = await dashboardRepo.postActivityDashboard();

    if (response.isSuccess) {
      print("✅ Dashboard activity posted successfully");
    } else {
      print("❌ Failed to post dashboard activity - Error: ${response.error?.message}");
    }
  }

//   Future<void> _fetchMonthlyDonations(
//   FetchMonthlyDonationsEvent event,
//   Emitter<DashboardState> emit,
// ) async {
//   //emit(state.copyWith(status: DashboardApiStatus.loading));
// emit(state.copyWith(status: state.status));
//   final response = await dashboardRepo.getMonthlyDonations(year: event.year);

//   if (response.isSuccess) {
//     print("✅ [DashboardBloc] Monthly donations for year ${event.year} fetched");
//     emit(
//       state.copyWith(
//         // status: DashboardApiStatus.loaded,
//         // monthlyDonations: response.data,
//         monthlyDonations: response.data,
//       ),
//     );
//   } else {
//     print("❌ [DashboardBloc] Error: ${response.error?.message}");
//     emit(
//       state.copyWith(
//         status: DashboardApiStatus.error,
//         errorMessage: response.error?.message ?? "Failed to load monthly donations",
//       ),
//     );
//   }
// }
Future<void> _fetchMonthlyDonations(
  FetchMonthlyDonationsEvent event,
  Emitter<DashboardState> emit,
) async {
  emit(state.copyWith( monthlyDonationStatus: DashboardApiStatus.loading,));

  final response = await dashboardRepo.getMonthlyDonations(year: event.year);

  if (response.isSuccess) {
    print("✅ [DashboardBloc] Monthly donations for year ${event.year} fetched");
    emit(
      state.copyWith(
        //status: DashboardApiStatus.loaded,
        monthlyDonations: response.data,
        monthlyDonationStatus: DashboardApiStatus.loaded,
      ),
    );
  } else {
    print("❌ [DashboardBloc] Error: ${response.error?.message}");
    emit(
      state.copyWith(
        status: DashboardApiStatus.error,
        errorMessage: response.error?.message ?? "Failed to load monthly donations",
      ),
    );
  }
}

  Future<void> _fetchDonationsMetricsAll(
    FetchDonationsMetricsAllEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardApiStatus.loading));

    final response = await dashboardRepo.getDonationsMetricsAll();

    if (response.isSuccess) {
      print("✅ [DashboardBloc] Donations metrics all fetched");
      emit(
        state.copyWith(
          status: DashboardApiStatus.loaded,
          donationsMetricsAll: response.data,
        ),
      );
    } else {
      print("❌ [DashboardBloc] Error fetching donations metrics all: ${response.error?.message}");
      emit(
        state.copyWith(
          status: DashboardApiStatus.error,
          errorMessage: response.error?.message ?? "Failed to load donations metrics",
        ),
      );
    }
  }
  }
