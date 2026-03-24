class VisitMetrics {
  final String month;
  final int totalVisits;
  final int totalVisitors;

  VisitMetrics({
    required this.month,
    required this.totalVisits,
    required this.totalVisitors,
  });

  factory VisitMetrics.fromJson(Map<String, dynamic> json) {
    return VisitMetrics(
      month: json['month'],
      totalVisits: json['totalVisits'] ?? 0,
      totalVisitors: json['totalVisitors'] ?? 0,
    );
  }
}