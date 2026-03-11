class JeevanaadiUser {
  final String id;
  final String fullName;
  final String? email;
  final double? profileCompletionPercentage;
  final String? jeevanaadiNo;
  // final List<double> percentageHistory;

  const JeevanaadiUser({
    required this.id,
    required this.fullName,
    this.profileCompletionPercentage,
    this.email,
    this.jeevanaadiNo,
    // required this.percentageHistory,
  });

  factory JeevanaadiUser.fromJson(Map<String, dynamic> json) {
    return JeevanaadiUser(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '-',
      profileCompletionPercentage: json['profileCompletionPercentage'] != null
          ? (json['profileCompletionPercentage'] as num).toDouble()
          : null,
      jeevanaadiNo: json['jeevanaadiNo']?.toString(),
      email: json['email']?.toString(),
      // percentageHistory: json['percentageHistory'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'profileCompletionPercentage': profileCompletionPercentage,
      'jeevanaadiNo': jeevanaadiNo,
      // 'percentageHistory': percentageHistory,
    };
  }
}
