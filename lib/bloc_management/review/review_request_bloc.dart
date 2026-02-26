// lib/bloc_management/review_request/review_request_bloc.dart

import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vikas_app/api_services/network_repos/review_repo.dart';
import 'package:vikas_app/bloc_management/review/review_request_event.dart';
import 'package:vikas_app/bloc_management/review/review_request_state.dart';

class ReviewRequestBloc extends Bloc<ReviewRequestEvent, ReviewRequestState> {
  final ReviewRepo _repository;

  ReviewRequestBloc({required ReviewRepo repository})
    : _repository = repository,
      super(const ReviewRequestState()) {
    on<FetchReviewRequestsEvent>(_onFetchReviewRequests);
  }

  Future<void> _onFetchReviewRequests(
    FetchReviewRequestsEvent event,
    Emitter<ReviewRequestState> emit,
  ) async {
    if (event.isLoadMore) {
      emit(state.copyWith(status: ReviewRequestStatus.loading));
    } else {
      emit(state.copyWith(status: ReviewRequestStatus.loading, requests: []));
    }

    try {
      log(
        '📥 Fetching review requests - Page: ${event.page}, Size: ${event.size}',
      );

      final result = await _repository.getReviewRequests(
        page: event.page,
        size: event.size,
      );

      if (result.isSuccess) {
        final response = result.data!;

        final hasReachedMax = response.currentPage >= response.totalPages - 1;

        final updatedRequests = event.isLoadMore
            ? [...state.requests, ...response.content]
            : response.content;

        emit(
          state.copyWith(
            status: ReviewRequestStatus.loaded,
            requests: updatedRequests,
            currentPage: response.currentPage,
            totalPages: response.totalPages,
            totalElements: response.totalElements,
            hasReachedMax: hasReachedMax,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ReviewRequestStatus.error,
            errorMessage: result.error?.message ?? 'Failed to fetch requests',
          ),
        );
      }
    } catch (e) {
      log('❌ Error fetching requests: $e');
      emit(
        state.copyWith(
          status: ReviewRequestStatus.error,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }
}
