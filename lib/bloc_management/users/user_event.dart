import 'package:equatable/equatable.dart';

class UserEvent extends Equatable {
  List<Object?> get props => [];
}

class FetchUsersEvent extends UserEvent {
  final int page;
  final int size;
  final String? searchQuery;
  FetchUsersEvent({required this.page, required this.size, this.searchQuery});
}

class FetchUsersProfileEvent extends UserEvent {
  final String userId;
  FetchUsersProfileEvent({required this.userId});
}

class CloseProfileView extends UserEvent {}
