import 'package:equatable/equatable.dart';

abstract class JeevanaadiEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchJeevanaadiProfileEvent extends JeevanaadiEvent {
  final String userId;
  FetchJeevanaadiProfileEvent(this.userId);
}

class FetchJeevanaadisEvent extends JeevanaadiEvent {
  final int page;
  FetchJeevanaadisEvent(this.page);
}

class CloseProfileView extends JeevanaadiEvent {}

// class AddUserEvent extends KaryakarthaEvent {
//   final LocalUser user;
//   AddUserEvent(this.user);

//   @override
//   List<Object?> get props => [user];
// }

// class UpdateUserEvent extends KaryakarthaEvent {
//   final LocalUser user;
//   UpdateUserEvent(this.user);

//   @override
//   List<Object?> get props => [user];
// }
