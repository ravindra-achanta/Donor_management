class UserMetricsResponse {
  final int activeKaryakarthas;
  final int inactiveKaryakarthas;
  final int totalKaryakarthas;
  final int totalJeevanadis;
  final int activeJeevanadis;
  final int inActiveJeevanadis;
  final int assignedJeevanadis;
  final int unAssignedJeevanadis;
  final double updationPercentgaeByKaryakartha; // FIXED
  final int activeAdmins;
  final int activeStaff;
  final int pendingRequests;
  final int inProgressRequests;
  final int completedRequests;

  UserMetricsResponse({
    required this.activeKaryakarthas,
    required this.inactiveKaryakarthas,
    required this.totalKaryakarthas,
    required this.totalJeevanadis,
    required this.activeJeevanadis,
    required this.inActiveJeevanadis,
    required this.assignedJeevanadis,
    required this.unAssignedJeevanadis,
    required this.updationPercentgaeByKaryakartha,
    required this.activeAdmins,
    required this.activeStaff,
    required this.pendingRequests,
    required this.inProgressRequests,
    required this.completedRequests,
  });

  factory UserMetricsResponse.fromJson(Map<String, dynamic> json) {
    return UserMetricsResponse(
      activeKaryakarthas: json['activeKaryakarthas'] ?? 0,
      inactiveKaryakarthas: json['inactiveKaryakarthas'] ?? 0,
      totalKaryakarthas: json['totalKaryakarthas'] ?? 0,
      totalJeevanadis: json['totalJeevanadis'] ?? 0,
      activeJeevanadis: json['activeJeevanadis'] ?? 0,
      inActiveJeevanadis: json['inActiveJeevanadis'] ?? 0,
      assignedJeevanadis: json['assignedJeevanadis'] ?? 0,
      unAssignedJeevanadis: json['unAssignedJeevanadis'] ?? 0,
      activeAdmins: json['activeAdmins'] ?? 0,
      activeStaff: json['activeStaff'] ?? 0,
      pendingRequests: json['pendingReqests'] ?? 0,
      inProgressRequests: json['inProgressReqests'] ?? 0,
      completedRequests: json['completedReqests'] ?? 0,
      updationPercentgaeByKaryakartha:
          (json['updationPercentgaeByKaryakartha'] ?? 0).toDouble(),
    );
  }
}
