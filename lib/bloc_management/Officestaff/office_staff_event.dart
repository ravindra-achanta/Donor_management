import 'package:equatable/equatable.dart';

abstract class OfficeStaffEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchOfficeStaffEvent extends OfficeStaffEvent {
  final int page;
  final String? searchQuery;

  FetchOfficeStaffEvent(this.page, [this.searchQuery]);
}

class DeleteOfficeStaffEvent extends OfficeStaffEvent {
  final String userId;
  DeleteOfficeStaffEvent(this.userId);
}

class FetchOfficeStaffProfileEvent extends OfficeStaffEvent {
  final String userId;
  FetchOfficeStaffProfileEvent(this.userId);
}

class CloseOfficeStaffProfile extends OfficeStaffEvent {}

class CloseOfficeStaffProfileView extends OfficeStaffEvent {}