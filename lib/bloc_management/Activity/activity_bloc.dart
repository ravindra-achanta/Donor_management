import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/network_repos/activity_repository.dart';
import 'activity_event.dart';
import 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityRepository repo;

  ActivityBloc({required this.repo}) : super(const ActivityState()) {
    on<FetchActivitiesEvent>(_onFetchActivities);
    on<CreateActivityEvent>(_onCreateActivity);
  }

  Future<void> _onFetchActivities(
    FetchActivitiesEvent event,
    Emitter<ActivityState> emit,
  ) async {
    emit(state.copyWith(status: ActivityStatus.loading));

    try {
      final result = await repo.fetchActivities(
        page: event.page,
        pageSize: event.pageSize,
        //search: event.search,
      );

      if (result.isSuccess) {
        emit(state.copyWith(
          status: ActivityStatus.loaded,
          activities: result.data?.content ?? [],
          currentPage: result.data?.currentPage ?? 0,
          totalPages: result.data?.totalPages ?? 1,
          totalElements: result.data?.totalElements ?? 0,
        ));
      } else {
        emit(state.copyWith(
          status: ActivityStatus.error,
          errorMessage: result.error?.message ?? 'Unknown error',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ActivityStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCreateActivity(
    CreateActivityEvent event,
    Emitter<ActivityState> emit,
  ) async {
    emit(state.copyWith(isCreating: true));

    try {
      final result = await repo.createActivity(event.request);

      if (result.isSuccess) {
        emit(state.copyWith(
          isCreating: false,
          status: ActivityStatus.created,
          creationMessage: 'Activity created successfully',
        ));

        // Refresh the list
        add(const FetchActivitiesEvent());
      } else {
        emit(state.copyWith(
          isCreating: false,
          status: ActivityStatus.error,
          errorMessage: result.error?.message ?? 'Failed to create activity',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isCreating: false,
        status: ActivityStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}