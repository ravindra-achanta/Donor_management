import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/response/notice_response.dart';

enum NoticeStatus { initial, loading, loaded, error }
enum NoticeFormStatus { initial, submitting, success, error }

class NoticeState extends Equatable {
  final NoticeStatus status;
  final NoticeFormStatus formStatus;
  final List<NoticeResponse> notices;
  final NoticeResponse? selectedNotice;
  final int totalElements;
  final int totalPages;
  final int currentPage;
  final String? errorMessage;
  final String? formErrorMessage;
  final bool isDetailViewVisible;
  final String? searchQuery;
  final String? filterType;
  final String? userType;
  final bool isLoadingMore;

  const NoticeState({
    this.status = NoticeStatus.initial,
    this.formStatus = NoticeFormStatus.initial,
    this.notices = const [],
    this.selectedNotice,
    this.totalElements = 0,
    this.totalPages = 0,
    this.currentPage = 0,
    this.errorMessage,
    this.formErrorMessage,
    this.isDetailViewVisible = false,
    this.searchQuery,
    this.filterType = 'All',
    this.userType = 'All Users',
    this.isLoadingMore = false,
  });

  NoticeState copyWith({
    NoticeStatus? status,
    NoticeFormStatus? formStatus,
    List<NoticeResponse>? notices,
    NoticeResponse? selectedNotice,
    int? totalElements,
    int? totalPages,
    int? currentPage,
    String? errorMessage,
    String? formErrorMessage,
    bool? isDetailViewVisible,
    String? searchQuery,
    String? filterType,
    String? userType,
    bool? isLoadingMore,
  }) {
    return NoticeState(
      status: status ?? this.status,
      formStatus: formStatus ?? this.formStatus,
      notices: notices ?? this.notices,
      selectedNotice: selectedNotice ?? this.selectedNotice,
      totalElements: totalElements ?? this.totalElements,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage ?? this.errorMessage,
      formErrorMessage: formErrorMessage ?? this.formErrorMessage,
      isDetailViewVisible: isDetailViewVisible ?? this.isDetailViewVisible,
      searchQuery: searchQuery ?? this.searchQuery,
      filterType: filterType ?? this.filterType,
      userType: userType ?? this.userType,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        status,
        formStatus,
        notices,
        selectedNotice,
        totalElements,
        totalPages,
        currentPage,
        errorMessage,
        formErrorMessage,
        isDetailViewVisible,
        searchQuery,
        filterType,
        userType,
        isLoadingMore,
      ];
}