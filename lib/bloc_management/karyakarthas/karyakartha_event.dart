import 'package:equatable/equatable.dart';

abstract class KaryakarthaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchKaryakattasEvent extends KaryakarthaEvent {
  final int page;
  final String? searchQuery;

  FetchKaryakattasEvent(this.page, [this.searchQuery]);
}

class CloseProfileView extends KaryakarthaEvent {}

class FetchKaryakarthaProfileEvent extends KaryakarthaEvent {
  final String userId;
  FetchKaryakarthaProfileEvent(this.userId);
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

class DeleteKaryakarthaEvent extends KaryakarthaEvent {
  final String userId;
  DeleteKaryakarthaEvent(this.userId);
}

class GetKaryakartha extends KaryakarthaEvent {
  final String userId;
  GetKaryakartha(this.userId);
}
