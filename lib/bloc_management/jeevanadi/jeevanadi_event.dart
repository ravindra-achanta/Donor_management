import 'package:equatable/equatable.dart';

abstract class JeevanaadiEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchJeevanaadiProfileEvent extends JeevanaadiEvent {
  final String id;
  FetchJeevanaadiProfileEvent(this.id);
}

class FetchJeevanaadisEvent extends JeevanaadiEvent {
  final int page;
  FetchJeevanaadisEvent(this.page);
}



class CloseProfileView extends JeevanaadiEvent {}

// class FetchJeevanadiMemberEvent extends JeevanaadiEvent {
//   final String memberId;
//   FetchJeevanadiMemberEvent(this.memberId);

//   @override
//   List<Object?> get props => [memberId];
// }

class FetchAssignedKaryakarthasEvent extends JeevanaadiEvent {
  final String memberId;
  final int page; 
  final int size;
  FetchAssignedKaryakarthasEvent(this.memberId, this.page, this.size);

  @override
  List<Object?> get props => [memberId, page, size];
}



class ToggleUnassignedSelectionEvent extends JeevanaadiEvent {
  final String userId;
  ToggleUnassignedSelectionEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}


class AssignSelectedKaryakarthasEvent extends JeevanaadiEvent {
  final String karyakarthaId; 
  final List<String> memberIds; 

  AssignSelectedKaryakarthasEvent({
    required this.karyakarthaId,
    required this.memberIds,
  });

  @override
  List<Object?> get props => [karyakarthaId, memberIds];
}

class RemoveAssignedKaryakarthaEvent extends JeevanaadiEvent {
  final String karyakarthaId;
  final String memberId;

   RemoveAssignedKaryakarthaEvent({
    required this.karyakarthaId,
    required this.memberId,
  });


  @override
  List<Object?> get props => [karyakarthaId,memberId];
}


//full profile view
class FetchJeevanaadiProfileFullEvent extends JeevanaadiEvent {
  final String jeevanadiNo;

  FetchJeevanaadiProfileFullEvent(this.jeevanadiNo);

  @override
  List<Object?> get props => [jeevanadiNo];
}

class FetchUnassignedKaryakarthasEvent extends JeevanaadiEvent {
  final int page;
  FetchUnassignedKaryakarthasEvent(this.page);

  @override
  List<Object?> get props => [page];
}

class UpdateJeevanaadiProfileEvent extends JeevanaadiEvent {
  final String userid;
  final Map<String, dynamic> updateData;

  UpdateJeevanaadiProfileEvent({
    required this.userid,
    required this.updateData,
  });

  @override
  List<Object> get props => [userid, updateData];
}

class FetchReferredByUsersEvent extends JeevanaadiEvent {
  final int page;
  final int size;
  final String? searchQuery;

  FetchReferredByUsersEvent({
    this.page = 0,
    this.size = 20,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [page, size, searchQuery];
}


class ToggleAssignedSelectionEvent extends JeevanaadiEvent {
  final String userId;
  ToggleAssignedSelectionEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

class ClearAssignedSelectionEvent extends JeevanaadiEvent {
  @override
  List<Object?> get props => [];
}

class RemoveSelectedAssignedMembersEvent extends JeevanaadiEvent {
  final String karyakarthaId;
  RemoveSelectedAssignedMembersEvent({required this.karyakarthaId});
  @override
  List<Object?> get props => [karyakarthaId];
}


class FetchJeevanaadiProfileFromRequestEvent extends JeevanaadiEvent {
  final String jeevanadiId;
  
  FetchJeevanaadiProfileFromRequestEvent(this.jeevanadiId);
  
  @override
  List<Object?> get props => [jeevanadiId];
}







