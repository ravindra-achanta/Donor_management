import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/bloc_management/notices/notice_event.dart';
import 'package:vikas_app/bloc_management/notices/notice_state.dart';
import 'package:vikas_app/screeens/models/request/notice_request.dart';
import 'package:vikas_app/screeens/models/response/notice_response.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final List<NoticeResponse> _dummyNotices = [
    NoticeResponse(
      id: '1',
      title: 'Monthly Meeting Announcement',
      message: 'All staff members are requested to attend the monthly meeting on Friday at 10 AM in the main hall.',
      audience: 'All Users',
      date: '2024-01-15',
      time: '10:00 AM',
      sender: 'Admin',
      createdAt: DateTime(2024, 1, 15),
    ),
    NoticeResponse(
      id: '2',
      title: 'System Maintenance',
      message: 'The system will be under maintenance from 2 AM to 4 AM tomorrow. Please save your work.',
      audience: 'Karyakatha',
      date: '2024-01-14',
      time: '2:00 AM',
      sender: 'IT Department',
      createdAt: DateTime(2024, 1, 14),
    ),
    NoticeResponse(
      id: '3',
      title: 'Holiday Announcement',
      message: 'Office will remain closed on 26th January for Republic Day celebrations.',
      audience: 'All Users',
      date: '2024-01-13',
      time: '9:00 AM',
      sender: 'HR Department',
      createdAt: DateTime(2024, 1, 13),
    ),
    NoticeResponse(
      id: '4',
      title: 'Training Session',
      message: 'There will be a training session on new software tools next Monday at 11 AM.',
      audience: 'Staff',
      date: '2024-01-12',
      time: '11:00 AM',
      sender: 'Training Dept',
      createdAt: DateTime(2024, 1, 12),
    ),
    NoticeResponse(
      id: '5',
      title: 'Salary Disbursement',
      message: 'January salaries will be credited by 5th February. Please check your accounts.',
      audience: 'All Users',
      date: '2024-01-11',
      time: '3:00 PM',
      sender: 'Accounts',
      createdAt: DateTime(2024, 1, 11),
    ),
  ];

  NoticeBloc() : super(NoticeState()) {
    on<FetchNoticesEvent>(_onFetchNotices);
    on<CreateNoticeEvent>(_onCreateNotice);
    on<ViewNoticeDetailsEvent>(_onViewNoticeDetails);
    on<DeleteNoticeEvent>(_onDeleteNotice);
    on<ClearNoticeFormEvent>(_onClearForm);
  }

  Future<void> _simulateDelay([int milliseconds = 500]) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  Future<void> _onFetchNotices(
    FetchNoticesEvent event,
    Emitter<NoticeState> emit,
  ) async {
    if (event.page == 0) {
      emit(state.copyWith(
        status: NoticeStatus.loading,
        isLoadingMore: false,
      ));
    } else {
      emit(state.copyWith(isLoadingMore: true));
    }

    await _simulateDelay(800);

    try {
      List<NoticeResponse> filteredNotices = _dummyNotices;

      if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
        filteredNotices = filteredNotices.where((notice) {
          return notice.title.toLowerCase().contains(event.searchQuery!.toLowerCase()) ||
              notice.message.toLowerCase().contains(event.searchQuery!.toLowerCase());
        }).toList();
      }

      if (event.userType != null && event.userType != 'All Users') {
        filteredNotices = filteredNotices.where((notice) {
          return notice.audience == event.userType;
        }).toList();
      }

      if (event.filterType != null && event.filterType != 'All') {
      
      }

      final totalPages = (filteredNotices.length / event.size).ceil();
      final startIndex = event.page * event.size;
      final endIndex = (startIndex + event.size) < filteredNotices.length 
          ? startIndex + event.size 
          : filteredNotices.length;
      
      final paginatedNotices = startIndex < filteredNotices.length
          ? filteredNotices.sublist(startIndex, endIndex)
          : <NoticeResponse>[];

      final List<NoticeResponse> noticesList = event.page == 0 
          ? paginatedNotices 
          : [...state.notices.cast<NoticeResponse>(), ...paginatedNotices];

      emit(state.copyWith(
        status: NoticeStatus.loaded,
        notices: noticesList,
        totalElements: filteredNotices.length,
        totalPages: totalPages,
        currentPage: event.page,
        errorMessage: null,
        isLoadingMore: false,
        searchQuery: event.searchQuery,
        filterType: event.filterType,
        userType: event.userType,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NoticeStatus.error,
        errorMessage: 'Error fetching notices: $e',
        isLoadingMore: false,
      ));
    }
  }

  Future<void> _onCreateNotice(
    CreateNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    emit(state.copyWith(formStatus: NoticeFormStatus.submitting));

    await _simulateDelay(1000);

    try {
      final newNotice = NoticeResponse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.noticeRequest.title,
        message: event.noticeRequest.message,
        audience: event.noticeRequest.audienceType == 'User Type'
            ? event.noticeRequest.audienceValue
            : 'Specific Users',
        date: event.noticeRequest.date.toIso8601String().split('T')[0],
        time: '${DateTime.now().hour}:${DateTime.now().minute}',
        sender: 'Admin', // In real app, get from auth
        createdAt: DateTime.now(),
      );

      final updatedNotices = [newNotice, ...state.notices];

      emit(state.copyWith(
        formStatus: NoticeFormStatus.success,
        notices: updatedNotices,
        totalElements: state.totalElements + 1,
        formErrorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        formStatus: NoticeFormStatus.error,
        formErrorMessage: 'Failed to create notice: $e',
      ));
    }
  }

  Future<void> _onViewNoticeDetails(
    ViewNoticeDetailsEvent event,
    Emitter<NoticeState> emit,
  ) async {
    emit(state.copyWith(status: NoticeStatus.loading));

    await _simulateDelay(500);

    try {
      final notice = _dummyNotices.firstWhere(
        (notice) => notice.id == event.noticeId,
        orElse: () => state.notices.firstWhere(
          (notice) => notice.id == event.noticeId,
          orElse: () => NoticeResponse(
            id: event.noticeId,
            title: 'Notice Not Found',
            message: 'The requested notice could not be found.',
            audience: 'All Users',
            date: DateTime.now().toIso8601String().split('T')[0],
            time: 'N/A',
            sender: 'System',
            createdAt: DateTime.now(),
          ),
        ),
      );

      emit(state.copyWith(
        status: NoticeStatus.loaded,
        selectedNotice: notice,
        isDetailViewVisible: true,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NoticeStatus.error,
        errorMessage: 'Failed to load notice details: $e',
        isDetailViewVisible: false,
      ));
    }
  }

  Future<void> _onDeleteNotice(
    DeleteNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    emit(state.copyWith(status: NoticeStatus.loading));

    await _simulateDelay(800);

    try {
      final updatedNotices = state.notices
          .where((notice) => notice.id != event.noticeId)
          .toList();

      _dummyNotices.removeWhere((notice) => notice.id == event.noticeId);

      emit(state.copyWith(
        status: NoticeStatus.loaded,
        notices: updatedNotices,
        totalElements: state.totalElements - 1,
        errorMessage: null,
        isDetailViewVisible: false,
        selectedNotice: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NoticeStatus.error,
        errorMessage: 'Failed to delete notice: $e',
      ));
    }
  }

  Future<void> _onClearForm(
    ClearNoticeFormEvent event,
    Emitter<NoticeState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: NoticeFormStatus.initial,
      formErrorMessage: null,
    ));
  }

  void refreshNotices() {
    add(FetchNoticesEvent(
      page: 0,
      filterType: state.filterType,
      userType: state.userType,
      searchQuery: state.searchQuery,
    ));
  }
}