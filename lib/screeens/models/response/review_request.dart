class ReviewRequest {
  final String jeevnadiName;
  final int jeevanadiId; 
  final String jeevanadiNo;
  final String updatedBy;
  final double profileCompletionPercentage;
  final List<dynamic> percentageHistory;
  String? status;

  ReviewRequest({
    required this.jeevnadiName,
    required this.jeevanadiNo,
    required this.jeevanadiId,
    required this.updatedBy,
    this.status,
    this.profileCompletionPercentage = 0.0,
    this.percentageHistory = const [],

  });

  factory ReviewRequest.fromJson(Map<String, dynamic> json) {
    return ReviewRequest(
      jeevnadiName: json['jeevnadiName'] ?? '',
        jeevanadiNo: json['jeevanadiNo'] ?? '',
       jeevanadiId: json['jeevanadiId'] != null 
          ? json['jeevanadiId'] as int 
          : 0,
      updatedBy: json['updatedBy'] ?? '',
      status: json['status'],
      profileCompletionPercentage: json['profileCompletionPercentage'] != null 
          ? (json['profileCompletionPercentage'] as num).toDouble() 
          : 0.0,
      percentageHistory: json['percentageHistory'] != null 
          ? List<dynamic>.from(json['percentageHistory']) 
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jeevnadiName': jeevnadiName,
      'jeevanadiNo': jeevanadiNo,
      'jeevanadiId': jeevanadiId,
      'updatedBy': updatedBy,
      'profileCompletionPercentage': profileCompletionPercentage,
      'percentageHistory': percentageHistory,
      'status': status,
    };
  }

 String get id => jeevanadiId.toString();
}