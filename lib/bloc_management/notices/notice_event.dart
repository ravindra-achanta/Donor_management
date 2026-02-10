import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/request/notice_request.dart';

abstract class NoticeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Fetch all notices
class FetchNoticesEvent extends NoticeEvent {
  final int page;
  final int size;
  final String? searchQuery;
  final String? filterType;
  final String? userType;

  FetchNoticesEvent({
    this.page = 0,
    this.size = 10,
    this.searchQuery,
    this.filterType = 'All',
    this.userType = 'All Users',
  });

  @override
  List<Object?> get props => [page, size, searchQuery, filterType, userType];
}

// Create new notice
class CreateNoticeEvent extends NoticeEvent {
  final NoticeRequest noticeRequest;

  CreateNoticeEvent(this.noticeRequest);

  @override
  List<Object?> get props => [noticeRequest];
}

// View notice details
class ViewNoticeDetailsEvent extends NoticeEvent {
  final String noticeId;

  ViewNoticeDetailsEvent(this.noticeId);

  @override
  List<Object?> get props => [noticeId];
}

// Delete notice
class DeleteNoticeEvent extends NoticeEvent {
  final String noticeId;

  DeleteNoticeEvent(this.noticeId);

  @override
  List<Object?> get props => [noticeId];
}

// Update notice
class UpdateNoticeEvent extends NoticeEvent {
  final String noticeId;
  final NoticeRequest noticeRequest;

  UpdateNoticeEvent(this.noticeId, this.noticeRequest);

  @override
  List<Object?> get props => [noticeId, noticeRequest];
}

// Clear form
class ClearNoticeFormEvent extends NoticeEvent {}