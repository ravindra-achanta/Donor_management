import 'package:vikas_app/screeens/models/response/notice_response.dart';

enum NoticeStatus { initial, loading, success, failure }

enum NoticeFormStatus { initial, submitting, success, error }

enum NoticeImageUploadStatus { initial, uploading, success, failure }

class NoticeState {
  final NoticeStatus status;
  final NoticeFormStatus formStatus;
  final NoticeImageUploadStatus imageUploadStatus;

  final List<NoticeResponse> notices;
  final List<NoticeResponse> allnotices;

  final String? uploadedImageUrl;

  final String? errorMessage;
  final String? formErrorMessage;
  final String? imageUploadError;

  const NoticeState({
    this.status = NoticeStatus.initial,
    this.formStatus = NoticeFormStatus.initial,
    this.imageUploadStatus = NoticeImageUploadStatus.initial,
    this.notices = const [],
    this.allnotices = const [],
    this.uploadedImageUrl,
    this.errorMessage,
    this.formErrorMessage,
    this.imageUploadError,
  });

  NoticeState copyWith({
    NoticeStatus? status,
    NoticeFormStatus? formStatus,
    NoticeImageUploadStatus? imageUploadStatus,
    List<NoticeResponse>? notices,
    List<NoticeResponse>? allnotices,
    String? uploadedImageUrl,

    String? errorMessage,
    String? formErrorMessage,
    String? imageUploadError,
  }) {
    return NoticeState(
      status: status ?? this.status,
      formStatus: formStatus ?? this.formStatus,
      imageUploadStatus: imageUploadStatus ?? this.imageUploadStatus,
      notices: notices ?? this.notices,
      allnotices: allnotices ?? this.allnotices,
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      formErrorMessage: formErrorMessage ?? this.formErrorMessage,
      imageUploadError: imageUploadError ?? this.imageUploadError,
    );
  }
}