import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/api_error.dart';
import 'package:vikas_app/api_services/network_repos/dashboard_repository.dart';
import 'package:vikas_app/bloc_management/donations/event.dart';
import 'package:vikas_app/bloc_management/donations/state.dart';


class DonationBloc extends Bloc<DonationEvent, DonationState> {
  final DashboardRepo dashboardRepository;

  DonationBloc({required this.dashboardRepository}) 
      : super(const DonationState()) {
    on<FetchDonationsMetricsAllEvent>(_onFetchDonationsMetricsAll);
    on<ResetDonationStateEvent>((event, emit) => emit(const DonationState()));
  }

  Future<void> _onFetchDonationsMetricsAll(
    FetchDonationsMetricsAllEvent event,
    Emitter<DonationState> emit,
  ) async {
    emit(state.copyWith(status: DonationStatus.loading));

    final result = await dashboardRepository.getDonationsMetricsAll();

    if (result.isSuccess) {
      print("✅ [DonationBloc] Metrics fetched successfully");
      emit(state.copyWith(
        status: DonationStatus.success,
        metricsAll: result.data,
        error: null,
        errorMessage: null,
      ));
    } else {
      print("❌ [DonationBloc] Error: ${result.error?.message}");
      emit(state.copyWith(
        status: DonationStatus.error,
        error: result.error,
        errorMessage: result.error?.message ?? 'Failed to fetch metrics',
      ));
    }
  }
}