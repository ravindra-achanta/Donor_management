// lib/blocs/dharmasetu/dharmasetu_event.dart

import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/request/dharmasetu_model.dart';

abstract class DharmasetuEvent extends Equatable {
  const DharmasetuEvent();

  @override
  List<Object?> get props => [];
}

class LoadDharmasetu extends DharmasetuEvent {
  final int page;

  const LoadDharmasetu({this.page = 0});

  @override
  List<Object?> get props => [page];
}

class AddDharmasetu extends DharmasetuEvent {
  final DharmasetuModel dharmasetu;
  const AddDharmasetu(this.dharmasetu);
  @override
  List<Object?> get props => [dharmasetu];
}

class UpdateDharmasetu extends DharmasetuEvent {
  final DharmasetuModel dharmasetu;
  const UpdateDharmasetu(this.dharmasetu);
  @override
  List<Object?> get props => [dharmasetu];
}

class DeleteDharmasetu extends DharmasetuEvent {
  final String id;
  const DeleteDharmasetu(this.id);
  @override
  List<Object?> get props => [id];
}