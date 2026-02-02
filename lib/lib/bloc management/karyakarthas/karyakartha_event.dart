
import 'package:vikas_app/screeens/models/request/karyakartha.dart';

abstract class KaryakarthasEvent {}

class LoadKaryakarthas extends KaryakarthasEvent {}

class AddKaryakartha extends KaryakarthasEvent {
  final Karyakartha karyakartha;
  AddKaryakartha(this.karyakartha);
}

class UpdateKaryakartha extends KaryakarthasEvent {
  final Karyakartha karyakartha;
  UpdateKaryakartha(this.karyakartha);
}

class DeleteKaryakartha extends KaryakarthasEvent {
  final String id;
  DeleteKaryakartha(this.id);
}

class ToggleKaryakarthaStatus extends KaryakarthasEvent {
  final String id;
  final bool isActive;
  ToggleKaryakarthaStatus(this.id, this.isActive);
}
