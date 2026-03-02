class ReviewRequest {
  final String jeevnadiName;
  final String jeevanadiId;
  final String updatedBy;
  String? status;

  ReviewRequest({
    required this.jeevnadiName,
    required this.jeevanadiId,
    required this.updatedBy,
    this.status,
  });

  factory ReviewRequest.fromJson(Map<String, dynamic> json) {
    return ReviewRequest(
      jeevnadiName: json['jeevnadiName'] ?? '',
      jeevanadiId: json['jeevanadiId'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jeevnadiName': jeevnadiName,
      'jeevanadiId': jeevanadiId,
      'updatedBy': updatedBy,
    };
  }

  String get id => jeevanadiId;
}