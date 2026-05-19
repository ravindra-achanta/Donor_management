import 'package:equatable/equatable.dart';

class MonthlyDonation extends Equatable {
  final int year;
  final int month;
  final double totalAmount;

  const MonthlyDonation({
    required this.year,
    required this.month,
    required this.totalAmount,
  });

  factory MonthlyDonation.fromJson(Map<String, dynamic> json) {
    return MonthlyDonation(
      year: json['year'] ?? 0,
      month: json['month'] ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'year': year,
    'month': month,
    'totalAmount': totalAmount,
  };

  @override
  List<Object?> get props => [year, month, totalAmount];
}

class MonthlyDonationsResponse extends Equatable {
  final List<MonthlyDonation> donations;

  const MonthlyDonationsResponse({required this.donations});

  factory MonthlyDonationsResponse.fromJson(List<dynamic> json) {
    return MonthlyDonationsResponse(
      donations: json.map((item) => MonthlyDonation.fromJson(item)).toList(),
    );
  }

  @override
  List<Object?> get props => [donations];
}
