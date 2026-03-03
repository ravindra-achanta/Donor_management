// lib/bloc_management/review_request/review_request_event.dart

import 'package:equatable/equatable.dart';

abstract class ReviewRequestEvent extends Equatable {
  const ReviewRequestEvent();

  @override
  List<Object?> get props => [];
}

class FetchReviewRequestsEvent extends ReviewRequestEvent {
  final int page;
  final int size;
  final bool isLoadMore;

  const FetchReviewRequestsEvent({
    required this.page, 
    this.size = 10,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [page, size, isLoadMore];
}