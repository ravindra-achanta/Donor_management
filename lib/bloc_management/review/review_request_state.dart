// lib/bloc_management/review_request/review_request_state.dart

import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/response/review_request.dart';

enum ReviewRequestStatus { initial, loading, loaded, error }

class ReviewRequestState extends Equatable {
  final ReviewRequestStatus status;
  final List<ReviewRequest> requests;
  final int currentPage;
  final int totalPages;
  final int totalElements;
  final String? errorMessage;
  final bool hasReachedMax;

  const ReviewRequestState({
    this.status = ReviewRequestStatus.initial,
    this.requests = const [],
    this.currentPage = 0,
    this.totalPages = 1,
    this.totalElements = 0,
    this.errorMessage,
    this.hasReachedMax = false,
  });

  ReviewRequestState copyWith({
    ReviewRequestStatus? status,
    List<ReviewRequest>? requests,
    int? currentPage,
    int? totalPages,
    int? totalElements,
    String? errorMessage,
    bool? hasReachedMax,
  }) {
    return ReviewRequestState(
      status: status ?? this.status,
      requests: requests ?? this.requests,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalElements: totalElements ?? this.totalElements,
      errorMessage: errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    status,
    requests,
    currentPage,
    totalPages,
    totalElements,
    errorMessage,
    hasReachedMax,
  ];
}