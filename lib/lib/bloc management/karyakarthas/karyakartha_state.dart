

import 'package:vikas_app/screeens/models/request/karyakartha.dart';

abstract class KaryakarthasState {}

class KaryakarthasInitial extends KaryakarthasState {}

class KaryakarthasLoading extends KaryakarthasState {}

class KaryakarthasLoaded extends KaryakarthasState {
  final List<Karyakartha> karyakarthas;
  KaryakarthasLoaded(this.karyakarthas);
}

class KaryakarthasError extends KaryakarthasState {
  final String message;
  KaryakarthasError(this.message);
}
