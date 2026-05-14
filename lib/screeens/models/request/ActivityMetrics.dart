class ActivityMetrics {
  final String month;
  final int totalCalls;

  ActivityMetrics({
    required this.month,
    required this.totalCalls,
  });

  factory ActivityMetrics.fromJson(Map<String, dynamic> json) {
    return ActivityMetrics(
      month: json['month'] ?? '',
      totalCalls: json['totalCalls'] ?? 0,
    );
  }
}