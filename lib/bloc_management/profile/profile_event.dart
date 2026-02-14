import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchProfile extends ProfileEvent {
  final String id;
  FetchProfile({required this.id});
}

class UpdateProfile extends ProfileEvent {
  final String id;
  final User user;

  UpdateProfile({
    required this.id,
    required this.user,
  });

  @override
  List<Object?> get props => [id, user];
}
