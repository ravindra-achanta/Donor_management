import 'package:equatable/equatable.dart';

abstract class DonationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDonationsMetricsAllEvent extends DonationEvent {
  @override
  List<Object?> get props => [];
}

class ResetDonationStateEvent extends DonationEvent {
  @override
  List<Object?> get props => [];
}