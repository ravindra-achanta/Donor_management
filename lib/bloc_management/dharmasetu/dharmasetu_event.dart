// lib/bloc_management/dharmasetu/dharmasetu_event.dart

import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/request/dharmasetu_model.dart';

abstract class DharmasetuEvent extends Equatable {
  const DharmasetuEvent();

  @override
  List<Object?> get props => [];
}

class LoadDharmasetu extends DharmasetuEvent {
  final int page;
  final int size;
  const LoadDharmasetu({this.page = 0, this.size = 10});
  @override
  List<Object?> get props => [page, size];
}

class LoadDharmasetuDetails extends DharmasetuEvent {
  final String id;
  const LoadDharmasetuDetails(this.id);
  @override
  List<Object?> get props => [id];
}

class AddDharmasetuEvent extends DharmasetuEvent {  
  final DharmasetuModel dharmasetu;
  const AddDharmasetuEvent(this.dharmasetu);
  @override
  List<Object?> get props => [dharmasetu];
}

class UpdateDharmasetuEvent extends DharmasetuEvent { 
  final DharmasetuModel dharmasetu;
  const UpdateDharmasetuEvent(this.dharmasetu);
  @override
  List<Object?> get props => [dharmasetu];
}

class DeleteDharmasetu extends DharmasetuEvent {
  final String id;
  const DeleteDharmasetu(this.id);
  @override
  List<Object?> get props => [id];
}

class CloseDharmasetuProfileView extends DharmasetuEvent {
  const CloseDharmasetuProfileView();
}