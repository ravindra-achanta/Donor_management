import 'package:equatable/equatable.dart';

class DonationsAllMetrics extends Equatable {
  final String totalContributions;
  final int monthlyAvgFrequency;
  final String monthlyAmountAvgFrequency;

  const DonationsAllMetrics({
    required this.totalContributions,
    required this.monthlyAvgFrequency,
    required this.monthlyAmountAvgFrequency,
  });

  factory DonationsAllMetrics.fromJson(Map<String, dynamic> json) {
    return DonationsAllMetrics(
      totalContributions: json['totalContributions']?.toString() ?? '0',
      monthlyAvgFrequency: (json['monthlyAvgFrequency'] as num?)?.toInt() ?? 0,
      monthlyAmountAvgFrequency: 
          json['monthlyAmountAvgFrequency']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() => {
    'totalContributions': totalContributions,
    'monthlyAvgFrequency': monthlyAvgFrequency,
    'monthlyAmountAvgFrequency': monthlyAmountAvgFrequency,
  };

  @override
  List<Object?> get props => [
    totalContributions,
    monthlyAvgFrequency,
    monthlyAmountAvgFrequency,
  ];
}