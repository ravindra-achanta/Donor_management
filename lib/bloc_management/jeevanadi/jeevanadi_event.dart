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

class FetchJeevanadiMemberEvent extends JeevanaadiEvent {
  final String memberId;
  FetchJeevanadiMemberEvent(this.memberId);

  @override
  List<Object?> get props => [memberId];
}

class FetchAssignedKaryakarthasEvent extends JeevanaadiEvent {
  final String memberId;
  FetchAssignedKaryakarthasEvent(this.memberId);

  @override
  List<Object?> get props => [memberId];
}

// class FetchUnassignedKaryakarthasEvent extends JeevanaadiEvent {
//   final String memberId;
//   final int page;
//   FetchUnassignedKaryakarthasEvent(this.memberId, this.page);

//   @override
//   List<Object?> get props => [memberId, page];
// }

class ToggleUnassignedSelectionEvent extends JeevanaadiEvent {
  final String userId;
  ToggleUnassignedSelectionEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AssignSelectedKaryakarthasEvent extends JeevanaadiEvent {
  final String memberId;
  AssignSelectedKaryakarthasEvent(this.memberId);

  @override
  List<Object?> get props => [memberId];
}

class RemoveAssignedKaryakarthaEvent extends JeevanaadiEvent {
  final String memberId;
  final String karyakarthaId;
  RemoveAssignedKaryakarthaEvent(this.memberId, this.karyakarthaId);

  @override
  List<Object?> get props => [memberId, karyakarthaId];
}


//full profile view
class FetchJeevanaadiProfileFullEvent extends JeevanaadiEvent {
  final String userId;

  FetchJeevanaadiProfileFullEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FetchUnassignedKaryakarthasEvent extends JeevanaadiEvent {
  final int page;
  FetchUnassignedKaryakarthasEvent(this.page);

  @override
  List<Object?> get props => [page];
}

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
