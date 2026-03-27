import 'package:equatable/equatable.dart';
import 'package:vikas_app/screeens/models/request/visit_model.dart';

abstract class VisitEvent extends Equatable {
  const VisitEvent();

  @override
  List<Object?> get props => [];
}

class LoadVisits extends VisitEvent {
  final int page;
  final int size;
  const LoadVisits({this.page = 0, this.size = 10});
  @override
  List<Object?> get props => [page, size];
}

class LoadVisitDetails extends VisitEvent {
  final String id;
  const LoadVisitDetails(this.id);
  @override
  List<Object?> get props => [id];
}

class AddVisit extends VisitEvent {
  final VisitModel visit;
  const AddVisit(this.visit);
  @override
  List<Object?> get props => [visit];
}

class UpdateVisit extends VisitEvent {
  final VisitModel visit;
  const UpdateVisit(this.visit);
  @override
  List<Object?> get props => [visit];
}

class DeleteVisit extends VisitEvent {
  final String id;
  const DeleteVisit(this.id);
  @override
  List<Object?> get props => [id];
}

class CloseVisitProfileView extends VisitEvent {
  const CloseVisitProfileView();
}
class LoadVisitMetrics extends VisitEvent {}
class ToggleChartView extends VisitEvent {
  final bool showMonthly;
  const ToggleChartView(this.showMonthly);
}
class SelectMonth extends VisitEvent {
  final int index;
  const SelectMonth(this.index);
}

class ClearMonthSelection extends VisitEvent {}