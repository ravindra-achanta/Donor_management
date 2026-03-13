import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/network_repos/dashboard_repository.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {

  final dashboardRepo = DashboardRepo();

  DashboardBloc() : super(const DashboardState()) {

    on<FetchDashboardMetricsEvent>(_fetchMetrics);
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
}