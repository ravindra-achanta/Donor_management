import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:vikas_app/screeens/models/request/notice_request.dart';

abstract class NoticeEvent {}

class FetchNoticesEvent extends NoticeEvent {}
class FetchNoticesNewEvent extends NoticeEvent {}

class CreateNoticeEvent extends NoticeEvent {
  final NoticeRequest request;

  CreateNoticeEvent(this.request);
}

class UpdateNoticeEvent extends NoticeEvent {
  final String id;
  final NoticeRequest request;

  UpdateNoticeEvent(this.id, this.request);
}

class MarkNoticeReadEvent extends NoticeEvent {
  final String id;

  MarkNoticeReadEvent(this.id);
}

class UploadNoticeImageEvent extends NoticeEvent {
  final XFile file;

  UploadNoticeImageEvent({required this.file});
}

class DeleteNoticeEvent extends NoticeEvent {
  final String id;

  DeleteNoticeEvent(this.id);
}



class ClearDeleteStatusEvent extends NoticeEvent {}