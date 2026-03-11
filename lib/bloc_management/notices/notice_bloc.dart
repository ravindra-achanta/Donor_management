import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/api_services/network_repos/notice_repo.dart';
import 'package:vikas_app/bloc_management/notices/notice_event.dart';
import 'package:vikas_app/bloc_management/notices/notice_state.dart';
import 'package:vikas_app/screeens/models/request/notice_request.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final NoticeRepo noticeRepo = NoticeRepo(); // direct instantiation

  NoticeBloc() : super(const NoticeState()) {
    on<FetchNoticesEvent>(_onFetchNotices);
    on<CreateNoticeEvent>(_onCreateNotice);
    on<UpdateNoticeEvent>(_onUpdateNotice);
    on<MarkNoticeReadEvent>(_onMarkNoticeRead);
    //on<DeleteNoticeEvent>(_onDeleteNotice);
    //on<ClearDeleteStatusEvent>(_onClearDeleteStatus);
  }

  Future<void> _onFetchNotices(
    FetchNoticesEvent event,
    Emitter<NoticeState> emit,
  ) async {
    emit(state.copyWith(status: NoticeStatus.loading));
    final result = await noticeRepo.getNotices();
    if (result.isSuccess) {
      emit(state.copyWith(
        status: NoticeStatus.success,
        notices: result.data ?? [],
      ));
    } else {
      emit(state.copyWith(
        status: NoticeStatus.failure,
        errorMessage: result.error?.message ?? 'Failed to load notices',
      ));
    }
  }

  Future<void> _onCreateNotice(
    CreateNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    emit(state.copyWith(formStatus: NoticeFormStatus.submitting));
    final result = await noticeRepo.createNotice(event.request as NoticeRequest);
    if (result.isSuccess) {
      add(FetchNoticesEvent()); // refresh list after creation
      emit(state.copyWith(formStatus: NoticeFormStatus.success));
    } else {
      emit(state.copyWith(
        formStatus: NoticeFormStatus.error,
        formErrorMessage: result.error?.message ?? 'Creation failed',
      ));
    }
  }

  Future<void> _onUpdateNotice(
    UpdateNoticeEvent event,
    Emitter<NoticeState> emit,
  ) async {
    emit(state.copyWith(formStatus: NoticeFormStatus.submitting));
    final result = await noticeRepo.updateNotice(event.id, event.request as NoticeRequest);
    if (result.isSuccess) {
      add(FetchNoticesEvent()); // refresh list after update
      emit(state.copyWith(formStatus: NoticeFormStatus.success));
    } else {
      emit(state.copyWith(
        formStatus: NoticeFormStatus.error,
        formErrorMessage: result.error?.message ?? 'Update failed',
      ));
    }
  }

  Future<void> _onMarkNoticeRead(
  MarkNoticeReadEvent event,
  Emitter<NoticeState> emit,
) async {
  final result = await noticeRepo.markNoticeAsRead(event.id);

  if (result.isSuccess) {
    // Optional: refresh notices list to update read status
    add(FetchNoticesEvent());
  } else {
    print("Failed to mark notice as read: ${result.error?.message}");
  }
}

  // Future<void> _onDeleteNotice(
  //   DeleteNoticeEvent event,
  //   Emitter<NoticeState> emit,
  // ) async {
  //   emit(state.copyWith(
  //     deleteStatus: NoticeDeleteStatus.loading,
  //     deleteError: null,
  //   ));
  //   final result = await noticeRepo.deleteNotice(event.id);
  //   if (result.isSuccess) {
  //     add(FetchNoticesEvent()); // refresh list after deletion
  //     emit(state.copyWith(deleteStatus: NoticeDeleteStatus.success));
  //   } else {
  //     emit(state.copyWith(
  //       deleteStatus: NoticeDeleteStatus.failure,
  //       deleteError: result.error?.message ?? 'Delete failed',
  //     ));
  //   }
  // }

  // void _onClearDeleteStatus(
  //   ClearDeleteStatusEvent event,
  //   Emitter<NoticeState> emit,
  // ) {
  //   emit(state.copyWith(
  //     deleteStatus: NoticeDeleteStatus.initial,
  //     deleteError: null,
  //   ));
  // }
}