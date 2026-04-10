// lib/screeens/models/response/activity_dashboard_metrics.dart

class ActivityDashboardMetrics {
  final String date;
  final int dashboardCount;
  final int dharmasetuCount;
  final int visitsCount;
  final int updationCount;
  final String lastLoginDate;

  ActivityDashboardMetrics({
    required this.date,
    required this.dashboardCount,
    required this.dharmasetuCount,
    required this.visitsCount,
    required this.updationCount,
    required this.lastLoginDate,
  });

  factory ActivityDashboardMetrics.fromJson(Map<String, dynamic> json) {
    return ActivityDashboardMetrics(
      date: json['date'] ?? '',
      dashboardCount: json['dashboardCount'] ?? 0,
      dharmasetuCount: json['dharmasetuCount'] ?? 0,
      visitsCount: json['visitsCount'] ?? 0,
      updationCount: json['updationCount'] ?? 0,
      lastLoginDate: json['lastLogindate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'dashboardCount': dashboardCount,
      'dharmasetuCount': dharmasetuCount,
      'visitsCount': visitsCount,
      'updationCount': updationCount,
      'lastLogindate': lastLoginDate,
    };
  }
}