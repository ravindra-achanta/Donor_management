class ActivityRequest {
  final String callStatus;
  final String description;
  final int jeevandiNo;
  final String date;

  ActivityRequest({
    required this.callStatus,
    required this.description,
    required this.jeevandiNo,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'callStatus': callStatus,
      'description': description,
      'jeevandiNo': jeevandiNo,
      'date': date,
    };
  }
}