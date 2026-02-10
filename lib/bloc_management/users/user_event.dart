import 'package:equatable/equatable.dart';

class UserEvent extends Equatable {
  List<Object?> get props => [];
}

class FetchUsersEvent extends UserEvent {
  final int page;
  FetchUsersEvent({required this.page});
}

class FetchUsersProfileEvent extends UserEvent {
  final String userId;
  FetchUsersProfileEvent({required this.userId});
}

class CloseProfileView extends UserEvent {}
