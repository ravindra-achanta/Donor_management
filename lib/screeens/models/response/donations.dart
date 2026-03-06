class DonationEvent {
  final double amount;
  final String eventType;
  final DateTime date;

  DonationEvent({
    required this.amount,
    required this.eventType,
    required this.date,
  });

  factory DonationEvent.fromJson(Map<String, dynamic> json) {
    return DonationEvent(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      eventType: json['eventType']?.toString() ?? '',
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'eventType': eventType,
      'date': date.toIso8601String(),
    };
  }
}