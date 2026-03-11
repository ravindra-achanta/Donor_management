import 'package:vikas_app/screeens/models/response/notice_response.dart';

enum NoticeStatus { initial, loading, success, failure }

enum NoticeFormStatus { initial, submitting, success, error }

class NoticeState {
  final NoticeStatus status;
  final NoticeFormStatus formStatus;
  final List<NoticeResponse> notices;
  final String? errorMessage;
  final String? formErrorMessage;

  const NoticeState({
    this.status = NoticeStatus.initial,
    this.formStatus = NoticeFormStatus.initial,
    this.notices = const [],
    this.errorMessage,
    this.formErrorMessage,
  });

  NoticeState copyWith({
    NoticeStatus? status,
    NoticeFormStatus? formStatus,
    List<NoticeResponse>? notices,
    String? errorMessage,
    String? formErrorMessage,
  }) {
    return NoticeState(
      status: status ?? this.status,
      formStatus: formStatus ?? this.formStatus,
      notices: notices ?? this.notices,
      errorMessage: errorMessage,
      formErrorMessage: formErrorMessage,
    );
  }
}